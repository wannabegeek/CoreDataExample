//
//  TFAsynchronousURLLoader.m
//  CoreDataExample
//
//  Created by Tom Fewster on 09/01/2013.
//  Copyright (c) 2013 Tom Fewster. All rights reserved.
//

#import "TFAsynchronousURLLoader.h"

@interface TFAsynchronousURLLoader ()
@property (strong) NSMutableData *receiveData;
@property (copy) void(^completionHandler)(BOOL success, NSData *value);
@end

@implementation TFAsynchronousURLLoader

@synthesize receiveData = _receiveData;
@synthesize completionHandler = _completionHandler;

- (NSURLConnection *)asynchonouslLoadDataFromURL:(NSURL *)url completionHander:(void(^)(BOOL success, NSData *data))completionHandler {
	_completionHandler = completionHandler;
	NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];
	return [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
	if (_receiveData == nil) {
		_receiveData = [[NSMutableData alloc] initWithCapacity:2048];
	}
	[_receiveData appendData:incrementalData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	if (_completionHandler) {
		_completionHandler(NO, nil);
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection {
	if (_completionHandler) {
		_completionHandler(YES, [_receiveData copy]);
	}
	_receiveData = nil;
}

@end
