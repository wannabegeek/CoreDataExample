//
//  TFSymbolsViewController.m
//  CoreDataExample
//
//  Created by Tom Fewster on 09/01/2013.
//  Copyright (c) 2013 Tom Fewster. All rights reserved.
//

#import "TFSymbolsViewController.h"
#import "TFExchange.h"
#import "TFSymbol.h"
#import "EditStringViewController.h"
#import "TFSymbolDetailsViewController.h"

#import "StockTableViewCell.h"
#import "TFPriceMoveColourValueTransformer.h"

@interface TFSymbolsViewController () {
	NSNumberFormatter *priceFormatter;
	NSNumberFormatter *changeFormatter;
	TFPriceMoveColourValueTransformer *priceColorTransformer;
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong) NSPredicate *basePredicate;

@end

@implementation TFSymbolsViewController

//@synthesize fetchedResultsController = _fetchedResultsController;
//@synthesize managedObjectContext = _managedObjectContext;

@synthesize  exchange = _exchange;
@synthesize basePredicate = _basePredicate;

- (void)awakeFromNib {
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
	    self.clearsSelectionOnViewWillAppear = NO;
	    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
	}

	priceFormatter = [[NSNumberFormatter alloc] init];
	[priceFormatter setMinimumIntegerDigits:1];
	[priceFormatter setMinimumFractionDigits:2];
	[priceFormatter setMaximumFractionDigits:2];
	[priceFormatter setNilSymbol:@"--"];

	changeFormatter = [[NSNumberFormatter alloc] init];
	changeFormatter.negativeSuffix = changeFormatter.positiveSuffix;
	[changeFormatter setMinimumIntegerDigits:1];
	[changeFormatter setMinimumFractionDigits:2];
	[changeFormatter setMaximumFractionDigits:2];
	[changeFormatter setNilSymbol:@"--"];

	priceColorTransformer = [[TFPriceMoveColourValueTransformer alloc] init];

    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
	self.title = _exchange.mnemonic;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setExchange:(TFExchange *)exchange {
	_exchange = exchange;

	// since our exchange has changed, we need to reload out fetched results controller with a new predicate
	_basePredicate = [NSPredicate predicateWithFormat:@"self.listingExchange = %@", _exchange];
	_fetchedResultsController = nil;

	NSError *error = nil;
	[[self fetchedResultsController] performFetch:&error];
	if (error) {
		NSLog(@"Error Occoured: %@", error);
	}
}

- (IBAction)addSymbol:(id)sender {
	[self performSegueWithIdentifier:@"addSymbol" sender:self];
}

- (IBAction)removeSelectedSymbols:(id)sender {
	// itterate over all symbols and remove them from the exchange and delete the managed object
	NSMutableSet *symbols = [_exchange mutableSetValueForKey:@"symbols"];
	for (NSIndexPath *indexPath in [self.tableView indexPathsForSelectedRows]) {
		TFSymbol *symbol = [self.fetchedResultsController objectAtIndexPath:indexPath];
		[symbols removeObject:symbol];
		[_exchange.managedObjectContext deleteObject:symbol];
	}
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];
	[self.navigationController setToolbarHidden:!editing animated:animated];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
	return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StockTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"StockTicker" forIndexPath:indexPath];
	[self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];

        NSError *error = nil;
        if (![context save:&error]) {
			// Replace this implementation with code to handle the error appropriately.
			// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	TFSymbol *symbol = [[self fetchedResultsController] objectAtIndexPath:indexPath];
	if (!self.editing && !symbol.refreshInProgress) {
		if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//			self.detailViewController.exchange = symbol;
		} else {
			[self performSegueWithIdentifier:@"viewDetails" sender:self];
		}
	}
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"viewDetails"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        TFSymbol *symbol = [[self fetchedResultsController] objectAtIndexPath:indexPath];
		NSLog(@"Displaying details for %@", symbol.ticker);
		TFSymbolDetailsViewController *viewController = segue.destinationViewController;
		viewController.symbol = symbol;
	} else if ([[segue identifier] isEqualToString:@"addSymbol"]) {

		EditStringViewController *viewController = segue.destinationViewController;
		viewController.completionHandler = ^(BOOL success, NSString *result) {
			if (success) {
				NSEntityDescription *entity = [self.fetchedResultsController.fetchRequest entity];
				TFSymbol *newSymbol = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:self.fetchedResultsController.managedObjectContext];

				newSymbol.ticker = result;
				newSymbol.listingExchange = _exchange;

				// Save the context.
				NSError *error = nil;
				if (![self.fetchedResultsController.managedObjectContext save:&error]) {
					// Replace this implementation with code to handle the error appropriately.
					// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
					NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
					abort();
				}
			}
		};
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TFSymbol" inManagedObjectContext:_exchange.managedObjectContext];
    [fetchRequest setEntity:entity];

	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"self.listingExchange = %@", _exchange];

    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];

    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ticker" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];

    [fetchRequest setSortDescriptors:sortDescriptors];

    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_exchange.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;

	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
		// Replace this implementation with code to handle the error appropriately.
		// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}

    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;

    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeUpdate:
            [self configureCell:(StockTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;

        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.

 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
 {
 // In the simplest, most efficient, case, reload the table view.
 [self.tableView reloadData];
 }
 */

- (void)configureCell:(StockTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    TFSymbol *symbol = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.ticker.text = symbol.ticker;
    cell.companyName.text = symbol.company;
    cell.price.text = [priceFormatter stringFromNumber:symbol.price];
	cell.price.textColor = [priceColorTransformer transformedValue:[NSNumber numberWithInteger:symbol.priceChange]];
    cell.change.text = [NSString stringWithFormat:@"(%@)", [changeFormatter stringFromNumber:symbol.change]];
	cell.change.textColor = [priceColorTransformer transformedValue:[NSNumber numberWithInteger:symbol.priceChange]];

	if (symbol.refreshInProgress) {
		UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		activityIndicator.frame = CGRectMake(0.0, 0.0, 24.0, 24.0);
		[activityIndicator startAnimating];
		cell.accessoryView = activityIndicator;
	} else {
		cell.accessoryView = nil;
	}
}

#pragma mark - Search Bar delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.ticker contains[cd] %@", searchText];

	self.fetchedResultsController.fetchRequest.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[_basePredicate, predicate]];

	NSError *error = nil;
	[[self fetchedResultsController] performFetch:&error];
	if (error) {
		NSLog(@"Error Occoured: %@", error);
	}
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
	self.fetchedResultsController.fetchRequest.predicate = _basePredicate;
	NSError *error = nil;
	[[self fetchedResultsController] performFetch:&error];
	if (error) {
		NSLog(@"Error Occoured: %@", error);
	}

    return;
}


@end
