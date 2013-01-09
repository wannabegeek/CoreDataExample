//
//  BadgeView.h
//  Route Monitor
//
//  Created by Tom Fewster on 06/09/2010.
//  Copyright 2010 Tom Fewster. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BadgeView : UIView {
	NSUInteger width;
	NSUInteger badgeNumber;
	
	UIFont *font;
}

@property (nonatomic, assign) NSUInteger badgeNumber;
@property (nonatomic, assign) UITableViewCell *parent;
@property (nonatomic, strong) UIColor *badgeColor;
@property (nonatomic, strong) UIColor *badgeColorHighlighted;

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) NSUInteger width;
@end