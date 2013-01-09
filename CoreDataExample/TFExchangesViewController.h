//
//  TFMasterViewController.h
//  CoreDataExample
//
//  Created by Tom Fewster on 09/01/2013.
//  Copyright (c) 2013 Tom Fewster. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TFSymbolDetailsViewController;

#import <CoreData/CoreData.h>

@interface TFExchangesViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) TFSymbolDetailsViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
