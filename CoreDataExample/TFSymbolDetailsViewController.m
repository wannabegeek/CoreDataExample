//
//  TFDetailViewController.m
//  CoreDataExample
//
//  Created by Tom Fewster on 09/01/2013.
//  Copyright (c) 2013 Tom Fewster. All rights reserved.
//

#import "TFSymbolDetailsViewController.h"
#import "TFSymbol.h"
#import "TFAsynchronousURLLoader.h"

@interface TFSymbolDetailsViewController () {
	NSNumberFormatter *priceFormatter;
	NSNumberFormatter *changeFormatter;
	id coreDataObserver;
}

@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation TFSymbolDetailsViewController

@synthesize symbol = _symbol;

@synthesize tickerLabel = _tickerLabel;
@synthesize companyLabel = _companyLabel;
@synthesize priceLabel = _priceLabel;
@synthesize highLabel = _highLabel;
@synthesize lowLabel = _lowLabel;
@synthesize volumeLabel = _volumeLabel;
@synthesize graphImageView = _graphImageView;


#pragma mark - Managing the detail item

- (void)setSymbol:(TFSymbol *)symbol
{
    if (_symbol != symbol) {
        _symbol = symbol;
        
        // Update the view.
        [self configureView];

		if (coreDataObserver) {
			[[NSNotificationCenter defaultCenter] removeObserver:coreDataObserver];
			coreDataObserver = nil;
		}
		coreDataObserver = [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextObjectsDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
			if ([[note valueForKey:NSUpdatedObjectsKey] containsObject:_symbol]) {
				[self configureView];
			}
		}];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)viewWillAppear:(BOOL)animated {
	self.title = _symbol.ticker;
	[self configureView];
}

- (void)viewDidDisappear:(BOOL)animated {
	if (coreDataObserver) {
		[[NSNotificationCenter defaultCenter] removeObserver:coreDataObserver];
		coreDataObserver = nil;
	}
}

- (void)configureView
{
    // Update the user interface for the detail item.

	if (_symbol) {
		_tickerLabel.text = _symbol.ticker;
		_companyLabel.text = _symbol.company;
		_priceLabel.text = [NSString stringWithFormat:@"%@ (%@)", [priceFormatter stringFromNumber:_symbol.price], [changeFormatter stringFromNumber:_symbol.change]];
		_highLabel.text = [priceFormatter stringFromNumber:_symbol.high];
		_lowLabel.text = [priceFormatter stringFromNumber:_symbol.low];
		_volumeLabel.text = [priceFormatter stringFromNumber:_symbol.volume];

		TFAsynchronousURLLoader *loader = [[TFAsynchronousURLLoader alloc] init];
		[loader asynchonouslLoadDataFromURL:_symbol.chartURL completionHander:^(BOOL success, NSData *value) {
			if (success) {
				_graphImageView.image = [UIImage imageWithData:value];
			}
		}];
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	priceFormatter = [[NSNumberFormatter alloc] init];
	[priceFormatter setMinimumIntegerDigits:1];
	[priceFormatter setMinimumFractionDigits:2];
	[priceFormatter setMaximumFractionDigits:2];
	[priceFormatter setNilSymbol:@"--"];

	changeFormatter = [[NSNumberFormatter alloc] init];
	changeFormatter.positiveSuffix = @"%";
	changeFormatter.negativeSuffix = changeFormatter.positiveSuffix;
	[changeFormatter setMinimumIntegerDigits:1];
	[changeFormatter setMinimumFractionDigits:2];
	[changeFormatter setMaximumFractionDigits:2];
	[changeFormatter setNilSymbol:@"--"];

	// Do any additional setup after loading the view, typically from a nib.
	[self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
