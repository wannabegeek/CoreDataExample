//
//  TFAsynchronousURLLoader.h
//  CoreDataExample
//
//  Created by Tom Fewster on 09/01/2013.
//  Copyright (c) 2013 Tom Fewster. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFAsynchronousURLLoader : NSObject <NSURLConnectionDelegate>

- (NSURLConnection *)asynchonouslLoadDataFromURL:(NSURL *)url completionHander:(void(^)(BOOL success, NSData *value))completionHandler;
@end
