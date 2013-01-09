//
//  TFSymbol.m
//  CoreDataExample
//
//  Created by Tom Fewster on 09/01/2013.
//  Copyright (c) 2013 Tom Fewster. All rights reserved.
//

#import "TFSymbol.h"
#import "TFExchange.h"

@interface TFSymbol ()
@property (strong) NSURLConnection *connection;
@property (strong) NSMutableData *receiveCache;
@end


@implementation TFSymbol

@dynamic lastUpdate;
@dynamic price;
@dynamic volume;
@dynamic ticker;
@dynamic chartURL;
@dynamic company;
@dynamic high;
@dynamic low;
@dynamic change;
@dynamic listingExchange;

@synthesize connection = _connection;
@synthesize receiveCache = _receiveCache;

- (void)awakeFromFetch {
	[super awakeFromFetch];
	[self requestQuote];
}

// We can't request quote data immediatly since we probably won;t have our ticker value set
//- (void)awakeFromInsert {
//	[super awakeFromFetch];
//	[self requestQuote];
//}

- (void)willTurnIntoFault {
	[super willTurnIntoFault];

	// since we are about to fault, we need to release cancel any out stnding requests
	if (_connection) {
		[_connection cancel];
	}
}

- (void)setTicker:(NSString *)ticker {
	[self willChangeValueForKey:@"ticker"];
	[self setPrimitiveValue:ticker forKey:@"ticker"];
	[self didChangeValueForKey:@"ticker"];
	[self requestQuote];
}


////////////////
// Non CoreData specific methods
////////////////


- (void)requestQuote {
	_receiveCache = [NSMutableData data];
	NSString *urlString = [NSString stringWithFormat:@"http://www.google.com/ig/api?stock=%@", self.ticker];
	NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:60];

	_connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
	if (_connection) {
		NSLog(@"Connection failed");
	}
}


#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [_receiveCache setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_receiveCache appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection failed! Error - %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Succeeded! Received %d bytes of data", [_receiveCache length]);

	NSXMLParser * parser = [[NSXMLParser alloc] initWithData:_receiveCache];
	[parser setDelegate:self];
	[parser parse];
}

#pragma mark - NSXMLParserDelegate Methods

- (void)parserDidStartDocument:(NSXMLParser *)parser {
	//the parser started this document.
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
	if ([elementName isEqualToString:@"symbol"]) {
//		NSString *symbol = [attributeDict valueForKey:@"data"];
	} else if ([elementName isEqualToString:@"company"]) {
		self.company = [attributeDict valueForKey:@"data"];
	} else if ([elementName isEqualToString:@"last"]) {
		self.price = [NSNumber numberWithDouble:[[attributeDict valueForKey:@"data"] doubleValue]];
	} else if ([elementName isEqualToString:@"high"]) {
		self.high = [NSNumber numberWithDouble:[[attributeDict valueForKey:@"data"] doubleValue]];
	} else if ([elementName isEqualToString:@"low"]) {
		self.low = [NSNumber numberWithDouble:[[attributeDict valueForKey:@"data"] doubleValue]];
	} else if ([elementName isEqualToString:@"volume"]) {
		self.volume = [NSNumber numberWithDouble:[[attributeDict valueForKey:@"data"] doubleValue]];
	} else if ([elementName isEqualToString:@"change"]) {
		self.change = [NSNumber numberWithDouble:[[attributeDict valueForKey:@"data"] doubleValue]];
	} else if ([elementName isEqualToString:@"chart_url"]) {
		NSURL *url = [NSURL URLWithString:[@"http://www.google.com" stringByAppendingString:[attributeDict valueForKey:@"data"]]];
		self.chartURL = url;
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	//the parser finished.
}

@end
