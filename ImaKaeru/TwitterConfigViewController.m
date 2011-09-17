//
//  ConfigViewController.m
//  ImaKaeru
//
//  Created by 村上 卓弥 on 11/09/17.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TwitterConfigViewController.h"
#import "Twitter.h"

@interface TwitterConfigViewController ()
- (void)doneAction:(id)sender;
- (void)cancelAction:(id)sender;
- (CellWithSwitch *)getCellWithText:(int)identifier label:(NSString *)label placeholder:(NSString *)placeholder;
@end

@implementation TwitterConfigViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        mConfig = [Config instance];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Twitter";
    
    self.navigationItem.rightBarButtonItem = 
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
    
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction:)];
}

- (void)doneAction:(id)sender
{
    // authenticate
    if (![Twitter authenticate:mAccount password:mPassword]) {
        // TBD: auth failed
    }
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)cancelAction:(id)sender
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;

    switch (indexPath.row) {
        case 0:
            cell = [self getCellWithText:0 label:@"Account" placeholder:@"Account"];
            break;
            
        case 1:
            cell = [self getCellWithText:1 label:@"Password" placeholder:@"Password"];
            break;
    }

    return cell;
}

- (CellWithText *)getCellWithText:(int)identifier label:(NSString *)label placeholder:(NSString *)placeholder
{
    CellWithText *cell;
    
    cell = [CellWithText getCell:self.tableView];
    [cell setLabel:label];
    cell.identifier = identifier;
    cell.placeholder = placeholder;
    cell.text = @"";
    cell.delegate = self;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Data changed
- (void)cellWithTextChanged:(CellWithText *)cell
{
    switch (cell.identifier) {
        case 0:
            mAccount = cell.text;
            break;

        case 1:
            mPassword = cell.text;
            break;
    }
}

@end
