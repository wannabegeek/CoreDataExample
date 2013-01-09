//
//  BadgedTableViewCell.h
//  Route Monitor
//
//  Created by Tom Fewster on 06/09/2010.
//  Copyright 2010 Tom Fewster. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BadgeView;

@interface BadgedTableViewCell : UITableViewCell {
	NSInteger badgeNumber;
	BadgeView *badge;
	
	UIColor *badgeColor;
	UIColor *badgeColorHighlighted;
}

@property NSInteger badgeNumber;
@property (readonly, retain) BadgeView *badge;
@property (nonatomic, retain) UIColor *badgeColor;
@property (nonatomic, retain) UIColor *badgeColorHighlighted;

@end
