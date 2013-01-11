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

@interface BadgedTableViewCell ()
@property (strong) BadgeView *badgeView;
@end

@implementation BadgedTableViewCell

@synthesize badgeNumber = _badgeNumber;
@synthesize badgeView = _badgeView;
@synthesize badgeColor = _badgeColor;
@synthesize badgeColorHighlighted = _badgeColorHighlighted;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		// Initialization code
		_badgeView = [[BadgeView alloc] initWithFrame:CGRectZero];
		_badgeView.parent = self;
		
		[self.contentView addSubview:_badgeView];

		[_badgeView setNeedsDisplay];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		// Initialization code
		_badgeView = [[BadgeView alloc] initWithFrame:CGRectZero];
		_badgeView.parent = self;
		
		[self.contentView addSubview:_badgeView];
		[_badgeView setNeedsDisplay];
    }
    return self;
}

- (void) layoutSubviews {
	[super layoutSubviews];
	
	if(_badgeNumber > 0) {
		//force badges to hide on edit.
		if(self.editing) {
			[_badgeView setHidden:YES];
		} else {
			[_badgeView setHidden:NO];
		}
		
		CGSize badgeSize = [[NSString stringWithFormat: @"%d", _badgeNumber] sizeWithFont:[UIFont boldSystemFontOfSize:14]];
				
		CGRect badgeframe;
		
		badgeframe = CGRectMake(self.contentView.frame.size.width - (badgeSize.width+16) - 10, round((self.contentView.frame.size.height - 18) / 2), badgeSize.width+16, 18);
		
		[_badgeView setFrame:badgeframe];
		[_badgeView setBadgeNumber:_badgeNumber];
		[_badgeView setParent:self];
		
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
			_badgeView.badgeColorHighlighted = self.badgeColorHighlighted;
		} else {
			_badgeView.badgeColorHighlighted = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.000];
		}
		
		//set badge colours or impose defaults
		if(self.badgeColor) {
			_badgeView.badgeColor = self.badgeColor;
		} else {
			_badgeView.badgeColor = [UIColor blueTextColor];
		}
	} else {
		[_badgeView setHidden:YES];
	}
	
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
	[super setHighlighted:highlighted animated:animated];
	[_badgeView setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	[_badgeView setNeedsDisplay];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];
	
	if (editing) {
		_badgeView.hidden = YES;
		[_badgeView setNeedsDisplay];
		[self setNeedsDisplay];
	} else {
		_badgeView.hidden = NO;
		[_badgeView setNeedsDisplay];
		[self setNeedsDisplay];
	}
}

@end
