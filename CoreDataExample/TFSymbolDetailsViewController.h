//
//  TFDetailViewController.h
//  CoreDataExample
//
//  Created by Tom Fewster on 09/01/2013.
//  Copyright (c) 2013 Tom Fewster. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TFSymbol;

@interface TFSymbolDetailsViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) TFSymbol *symbol;

@property (weak) IBOutlet UILabel *tickerLabel;
@property (weak) IBOutlet UILabel *companyLabel;
@property (weak) IBOutlet UILabel *priceLabel;
@property (weak) IBOutlet UILabel *highLabel;
@property (weak) IBOutlet UILabel *lowLabel;
@property (weak) IBOutlet UILabel *volumeLabel;
@property (weak) IBOutlet UIImageView *graphImageView;

@end
