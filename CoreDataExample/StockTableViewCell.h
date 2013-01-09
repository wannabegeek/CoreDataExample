//
//  StockTableViewCell.h
//  CoreDataExample
//
//  Created by Tom Fewster on 09/01/2013.
//  Copyright (c) 2013 Tom Fewster. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StockTableViewCell : UITableViewCell

@property (weak) IBOutlet UILabel *price;
@property (weak) IBOutlet UILabel *change;
@property (weak) IBOutlet UILabel *ticker;
@property (weak) IBOutlet UILabel *companyName;

@end
