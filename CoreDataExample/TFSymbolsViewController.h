//
//  TFSymbolsViewController.h
//  CoreDataExample
//
//  Created by Tom Fewster on 09/01/2013.
//  Copyright (c) 2013 Tom Fewster. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TFExchange;

@interface TFSymbolsViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) TFExchange *exchange;

- (IBAction)addSymbol:(id)sender;
- (IBAction)removeSelectedSymbols:(id)sender;

@end
