//
//  EditStringViewController.h
//  ShootStudio
//
//  Created by Tom Fewster on 14/10/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringInputTableViewCell.h"

@protocol EditStringDelegete <NSObject>

- (void)didUpdateStringValue:(NSString *)value sender:(id)sender;

@optional
- (void)didCancelStringUpdate:(id)sender;

@end


@interface EditStringViewController : UIViewController <StringInputTableViewCellDelegate> {
	NSString *value;
	NSString *placeholder;
	NSString *title;
	NSString *comment;
}

@property (weak) id<EditStringDelegete> delegate;
@property (copy) void (^completionHandler)(BOOL success, NSString *value);

@property (copy) NSString *value;
@property (copy) NSString *placeholder;
@property (copy) NSString *text;
@property (copy) NSString *comment;
@property (strong) id context;
@property (weak) IBOutlet UITableView *inputTableView;
@property (weak) IBOutlet UINavigationBar *navigationBar;

- (IBAction)dismiss:(id)sender;
- (IBAction)cancel:(id)sender;

@end
