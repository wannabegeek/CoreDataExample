//
//  TFPriceMoveColourValueTransformer.m
//  CoreDataExample
//
//  Created by Tom Fewster on 09/01/2013.
//  Copyright (c) 2013 Tom Fewster. All rights reserved.
//

#import "TFPriceMoveColourValueTransformer.h"
#import "TFSymbol.h"

@implementation TFPriceMoveColourValueTransformer

+ (Class)transformedValueClass {
	return [UIColor class];
}

+ (BOOL)allowsReverseTransformation {
	return NO;
}

- (id)transformedValue:(NSNumber *)value {
	if (value == nil)
		return [UIColor blackColor];

	switch ([value integerValue]) {
		case kTFPriceDown:
			return [UIColor redColor];
			break;
		case kTFPriceUp:
			return [UIColor greenColor];
			break;
		default:
			return [UIColor blackColor];
			break;
	}
}

@end
