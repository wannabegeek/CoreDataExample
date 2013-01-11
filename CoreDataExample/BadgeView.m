//
//  BadgeView.m
//  Route Monitor
//
//  Created by Tom Fewster on 06/09/2010.
//  Copyright 2010 Tom Fewster. All rights reserved.
//

#import "BadgeView.h"
#import "UIColor+Custom.h"

@interface BadgeView ()
@property (nonatomic, assign) NSUInteger width;
@end

@implementation BadgeView

@synthesize width = _width;
@synthesize badgeNumber = _badgeNumber;
@synthesize parent = _parent;
@synthesize badgeColor = _badgeColor;
@synthesize badgeColorHighlighted = _badgeColorHighlighted;
	// from private
@synthesize font = _font;

- (id) initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		_font = [UIFont boldSystemFontOfSize: 14];
		self.backgroundColor = [UIColor clearColor];
	}
	
	return self;	
}

- (void) drawRect:(CGRect)rect {	
	NSString *countString = [[NSString alloc] initWithFormat:@"%d", _badgeNumber];
	
	CGSize numberSize = [countString sizeWithFont:_font];
	self.width = numberSize.width + 16;
	
	CGRect bounds = CGRectMake(0 , 0, numberSize.width + 16 , 18);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	float radius = bounds.size.height / 2.0;
	
	CGContextSaveGState(context);
	
	UIColor *col;
	if (_parent.highlighted || _parent.selected) {
		if (_badgeColorHighlighted) {
			col = _badgeColorHighlighted;
		} else {
			col = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.000];
		}
	} else {
		if (_badgeColor) {
			col = _badgeColor;
		} else {
			col = [UIColor blueTextColor];
		}
	}
	
	CGContextSetFillColorWithColor(context, [col CGColor]);
	
	CGContextBeginPath(context);
	CGContextAddArc(context, radius, radius, radius, M_PI / 2 , 3 * M_PI / 2, NO);
	CGContextAddArc(context, bounds.size.width - radius, radius, radius, 3 * M_PI / 2, M_PI / 2, NO);
	CGContextClosePath(context);
	CGContextFillPath(context);
	CGContextRestoreGState(context);
	
	bounds.origin.x = (bounds.size.width - numberSize.width) / 2 +0.5;
	
	CGContextSetBlendMode(context, kCGBlendModeClear);
	[countString drawInRect:bounds withFont:_font];
}

@end
