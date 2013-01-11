//
//  StockTableViewCell.m
//  CoreDataExample
//
//  Created by Tom Fewster on 09/01/2013.
//  Copyright (c) 2013 Tom Fewster. All rights reserved.
//

#import "StockTableViewCell.h"

@implementation StockTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (nil != (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self initFixedTableViewCell];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self initFixedTableViewCell];
}

- (void)initFixedTableViewCell {
    for (NSInteger i = self.constraints.count - 1; i >= 0; i--) {
        NSLayoutConstraint *constraint = [self.constraints objectAtIndex:i];

        id firstItem = constraint.firstItem;
        id secondItem = constraint.secondItem;

        BOOL shouldMoveToContentView = YES;

        if ([firstItem isDescendantOfView:self.contentView]) {
            if (NO == [secondItem isDescendantOfView:self.contentView]) {
                secondItem = self.contentView;
            }
        }
        else if ([secondItem isDescendantOfView:self.contentView]) {
            if (NO == [firstItem isDescendantOfView:self.contentView]) {
                firstItem = self.contentView;
            }
        }
        else {
            shouldMoveToContentView = NO;
        }

        if (shouldMoveToContentView) {
            [self removeConstraint:constraint];
            NSLayoutConstraint *contentViewConstraint = [NSLayoutConstraint constraintWithItem:firstItem
                                                                                     attribute:constraint.firstAttribute
                                                                                     relatedBy:constraint.relation
                                                                                        toItem:secondItem
                                                                                     attribute:constraint.secondAttribute
                                                                                    multiplier:constraint.multiplier
                                                                                      constant:constraint.constant];
            [self.contentView addConstraint:contentViewConstraint];
        }
    }
}

@end
