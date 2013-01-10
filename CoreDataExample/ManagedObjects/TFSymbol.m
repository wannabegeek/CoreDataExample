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
@synthesize refreshInProgress = _refreshInProgress;

+ (NSSet *)keyPathsForValuesAffectingPriceChange {
	return [NSSet setWithObject:@"change"];
}

- (void)awakeFromFetch {
	[super awakeFromFetch];
	[self requestQuote];
}

// We can't request quote data immediatly since we probably won;t have our ticker value set
//- (void)awakeFromInsert {
//	[super awakeFromFetch];
//	[self requestQuote];
//}

- (void)awakeFromSnapshotEvents:(NSSnapshotEventType)flags {
	// We should reall check why we are being called here.
	// But I'm making the assumption it is either because of undo a refesh request, or a merge back to the main context
	// in either situation, we probably want to cancel any outstanding request if there are any
	// and re-request with the new details (i.e the symbol could have changed)
	[self cancelOutstandingRequests];
	[self requestQuote];
}


- (void)willTurnIntoFault {
	[super willTurnIntoFault];

	// since we are about to fault, we need to release cancel any outstnding connection requests
	[self cancelOutstandingRequests];
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

- (kTFSymolPriceMove)priceChange {
	if ([self.change doubleValue] > 0) {
		return kTFPriceUp;
	} else if ([self.change doubleValue] < 0) {
		return kTFPriceDown;
	}

	return kTFPriceNoChange;
}


- (void)requestQuote {
	if (_connection) {
		NSLog(@"Already have an outstanding request");
	} else {
			_receiveCache = [NSMutableData data];
			NSString *urlString = [NSString stringWithFormat:@"http://www.google.com/ig/api?stock=%@", self.ticker];
			NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
			NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:60];

			_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
			if (!_connection) {
				NSLog(@"Connection failed");
			} else {
				[self willChangeValueForKey:@"refreshInProgress"];
				_refreshInProgress = YES;
				[self didChangeValueForKey:@"refreshInProgress"];
			}
	}
}

- (void)cancelOutstandingRequests {
	if (_connection) {
		[_connection cancel];
		_connection = nil;

		[self willChangeValueForKey:@"refreshInProgress"];
		_refreshInProgress = NO;
		[self didChangeValueForKey:@"refreshInProgress"];
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
	[self willChangeValueForKey:@"refreshInProgress"];
	_refreshInProgress = NO;
	[self didChangeValueForKey:@"refreshInProgress"];
	[parser setDelegate:self];
	[parser parse];
	_connection = nil;
}

#pragma mark - NSXMLParserDelegate Methods

- (void)parserDidStartDocument:(NSXMLParser *)parser {
	//the parser started this document.
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {

	NSMutableDictionary *changeDictionary = [NSMutableDictionary dictionaryWithCapacity:7];

	if ([elementName isEqualToString:@"symbol"]) {
//		NSString *symbol = [attributeDict valueForKey:@"data"];
	} else if ([elementName isEqualToString:@"company"]) {
		[changeDictionary setObject:[attributeDict valueForKey:@"data"] forKey:@"company"];
	} else if ([elementName isEqualToString:@"last"]) {
		[changeDictionary setObject:[NSNumber numberWithDouble:[[attributeDict valueForKey:@"data"] doubleValue]] forKey:@"price"];
	} else if ([elementName isEqualToString:@"high"]) {
		[changeDictionary setObject:[NSNumber numberWithDouble:[[attributeDict valueForKey:@"data"] doubleValue]] forKey:@"high"];
	} else if ([elementName isEqualToString:@"low"]) {
		[changeDictionary setObject:[NSNumber numberWithDouble:[[attributeDict valueForKey:@"data"] doubleValue]] forKey:@"low"];
	} else if ([elementName isEqualToString:@"volume"]) {
		[changeDictionary setObject:[NSNumber numberWithDouble:[[attributeDict valueForKey:@"data"] doubleValue]] forKey:@"volume"];
	} else if ([elementName isEqualToString:@"change"]) {
		[changeDictionary setObject:[NSNumber numberWithDouble:[[attributeDict valueForKey:@"data"] doubleValue]] forKey:@"change"];
	} else if ([elementName isEqualToString:@"chart_url"]) {
		NSURL *url = [NSURL URLWithString:[@"http://www.google.com" stringByAppendingString:[attributeDict valueForKey:@"data"]]];
		[changeDictionary setObject:url forKey:@"chartURL"];
	}

	[self.managedObjectContext performBlockAndWait:^{
		[self setValuesForKeysWithDictionary:changeDictionary];
	}];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	//the parser finished.
}

@end
