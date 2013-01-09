//
//  UIColor+Custom.h
//  ShootStudio
//
//  Created by Tom Fewster on 30/09/2011.
//  Copyright (c) 2011 Tom Fewster. All rights reserved.
//

#import "UIColor+Custom.h"

@implementation UIColor (Custom)

+ (UIColor *)blueTextColor {
	return [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
}

- (UIColor *)lighterColor {
    float h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a]) {
        return [UIColor colorWithHue:h saturation:s brightness:MIN(b * 1.3, 1.0) alpha:1.0];
	}
    return nil;
}

- (UIColor *)darkerColor {
    float h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a]) {
        return [UIColor colorWithHue:h saturation:s brightness:b * 0.75 alpha:1.0];
	}
	
    return nil;
}

- (UIColor *)greyscaleColor {
    float h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a]) {
        return [UIColor colorWithHue:h saturation:0.0 brightness:b alpha:1.0];
	}

    return nil;
}
@end
