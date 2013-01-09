//
//  EditStringViewController.m
//  ShootStudio
//
//  Created by Tom Fewster on 14/10/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EditStringViewController.h"

@implementation EditStringViewController

@synthesize delegate = _delegate;
@synthesize text = _text;
@synthesize placeholder = _placeholder;
@synthesize value = _value;
@synthesize comment = _comment;
@synthesize context = _context;
@synthesize inputTableView = _inputTableView;
@synthesize navigationBar = _navigationBar;
@synthesize completionHandler = _completionHandler;

- (IBAction)dismiss:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
	if (_delegate) {
		[_delegate didUpdateStringValue:_text sender:self];
	} else if (_completionHandler) {
		_completionHandler(YES, _text);
	}
}

- (IBAction)cancel:(id)sender {
	if (_delegate) {
		if ([_delegate respondsToSelector:@selector(didCancelStringUpdate)]) {
			[_delegate didCancelStringUpdate:self];
		}
	} else if (_completionHandler) {
		_completionHandler(NO, nil);
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	_navigationBar.topItem.title = self.title;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	StringInputTableViewCell *cell = (StringInputTableViewCell *)[_inputTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	[cell.textField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (NSUInteger)supportedInterfaceOrientations {
	return UIInterfaceOrientationMaskAll;
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return _comment;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StringInputTableViewCell *cell = (StringInputTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"EditStringCell"];
	cell.textLabel.text = _text;
	cell.textField.text = _value;
	cell.textField.placeholder = _placeholder;
	cell.delegate = self;
    return cell;
}

- (void)tableViewCell:(StringInputTableViewCell *)cell didEndEditingWithString:(NSString *)newString {
	_text = newString;
}

@end
