//
//  BadgedTableViewCell.h
//  Route Monitor
//
//  Created by Tom Fewster on 06/09/2010.
//  Copyright 2010 Tom Fewster. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BadgedTableViewCell : UITableViewCell

@property NSInteger badgeNumber;
@property (nonatomic, strong) UIColor *badgeColor;
@property (nonatomic, strong) UIColor *badgeColorHighlighted;

@end
