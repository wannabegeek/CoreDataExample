//
//  BadgedTableViewCell.m
//  Route Monitor
//
//  Created by Tom Fewster on 06/09/2010.
//  Copyright 2010 Tom Fewster. All rights reserved.
//

#import "BadgedTableViewCell.h"
#import "BadgeView.h"
#import "UIColor+Custom.h"

@implementation BadgedTableViewCell

@synthesize badgeNumber, badge, badgeColor, badgeColorHighlighted;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
			// Initialization code
		badge = [[BadgeView alloc] initWithFrame:CGRectZero];
		badge.parent = self;
		
			//redraw cells in accordance to accessory
		float version = [[[UIDevice currentDevice] systemVersion] floatValue];
		
		if (version <= 3.0)
			[self addSubview:self.badge];
		else 
			[self.contentView addSubview:self.badge];
		
		[self.badge setNeedsDisplay];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		// Initialization code
		badge = [[BadgeView alloc] initWithFrame:CGRectZero];
		badge.parent = self;
		
		[self.contentView addSubview:self.badge];
		[self.badge setNeedsDisplay];
    }
    return self;
}

- (void) layoutSubviews {
	[super layoutSubviews];
	
	if(self.badgeNumber > 0) {
			//force badges to hide on edit.
		if(self.editing) {
			[self.badge setHidden:YES];
		} else {
			[self.badge setHidden:NO];
		}
		
		CGSize badgeSize = [[NSString stringWithFormat: @"%d", self.badgeNumber] sizeWithFont:[UIFont boldSystemFontOfSize: 14]];
				
		CGRect badgeframe;
		
		badgeframe = CGRectMake(self.contentView.frame.size.width - (badgeSize.width+16) - 10, round((self.contentView.frame.size.height - 18) / 2), badgeSize.width+16, 18);
		
		[self.badge setFrame:badgeframe];
		[badge setBadgeNumber:self.badgeNumber];
		[badge setParent:self];
		
		if ((self.textLabel.frame.origin.x + self.textLabel.frame.size.width) >= badgeframe.origin.x) {
			CGFloat badgeWidth = self.textLabel.frame.size.width - badgeframe.size.width - 10.0;
			
			self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x, self.textLabel.frame.origin.y, badgeWidth, self.textLabel.frame.size.height);
		}
		
		if ((self.detailTextLabel.frame.origin.x + self.detailTextLabel.frame.size.width) >= badgeframe.origin.x) {
			CGFloat badgeWidth = self.detailTextLabel.frame.size.width - badgeframe.size.width - 10.0;
			
			self.detailTextLabel.frame = CGRectMake(self.detailTextLabel.frame.origin.x, self.detailTextLabel.frame.origin.y, badgeWidth, self.detailTextLabel.frame.size.height);
		}
			//set badge highlighted colours or use defaults
		if(self.badgeColorHighlighted) {
			badge.badgeColorHighlighted = self.badgeColorHighlighted;
		} else {
			badge.badgeColorHighlighted = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.000];
		}
		
			//set badge colours or impose defaults
		if(self.badgeColor)
			badge.badgeColor = self.badgeColor;
		else
			badge.badgeColor = [UIColor blueTextColor];
	} else {
		[self.badge setHidden:YES];
	}
	
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
	[super setHighlighted:highlighted animated:animated];
	[badge setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	[badge setNeedsDisplay];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];
	
	if (editing) {
		badge.hidden = YES;
		[badge setNeedsDisplay];
		[self setNeedsDisplay];
	} else {
		badge.hidden = NO;
		[badge setNeedsDisplay];
		[self setNeedsDisplay];
	}
}

@end
