//
//  TFSymbol.h
//  CoreDataExample
//
//  Created by Tom Fewster on 09/01/2013.
//  Copyright (c) 2013 Tom Fewster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TFExchange;

typedef enum {
	kTFPriceUp = -1,
	kTFPriceNoChange = 0,
	kTFPriceDown = 1
} kTFSymolPriceMove;

@interface TFSymbol : NSManagedObject <NSXMLParserDelegate, NSURLConnectionDelegate>

@property (nonatomic, retain) NSDate * lastUpdate;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * volume;
@property (nonatomic, retain) NSString * ticker;
@property (nonatomic, retain) NSURL *chartURL;
@property (nonatomic, retain) NSString * company;
@property (nonatomic, retain) NSNumber * high;
@property (nonatomic, retain) NSNumber * low;
@property (nonatomic, retain) NSNumber * change;
@property (nonatomic, retain) TFExchange *listingExchange;

@property (readonly) kTFSymolPriceMove priceChange;
- (void)requestQuote;
@end
