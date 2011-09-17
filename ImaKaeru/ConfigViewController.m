//
//  ConfigViewController.m
//  ImaKaeru
//
//  Created by 村上 卓弥 on 11/09/17.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ConfigViewController.h"

#define K_IS_USE_EMAIL  0
#define K_EMAIL_ADDRESS 1

#define K_IS_USE_TWITTER 10
#define K_IS_USE_DIRECT_MESSAGE 11
#define K_TWITTER_ADDRESS 12


@interface ConfigViewController ()
- (void)doneAction:(id)sender;
- (CellWithSwitch *)getCellWithSwitch:(int)identifier label:(NSString *)label on:(BOOL)on;
@end

@implementation ConfigViewController

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

    self.navigationItem.rightBarButtonItem = 
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
}

- (void)doneAction:(id)sender
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
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Eメール設定";
        case 1:
            return @"Twitter設定";
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;

    switch (indexPath.section) {
        case 0:
            // Email settings
            switch (indexPath.row) {
                case 0:
                    // Email on/off
                    cell = [self getCellWithSwitch:K_IS_USE_EMAIL label:@"Eメール送信" on:mConfig.isUseEmail];
                    break;
            }
            break;
            
        case 1:
            // Twitter settings
            switch (indexPath.row) {
                case 0:
                    // Twitter on/off
                    cell = [self getCellWithSwitch:K_IS_USE_TWITTER label:@"Twitter送信" on:mConfig.isUseTwitter];
                    break;

                case 1:
                    // direct message
                    cell = [self getCellWithSwitch:K_IS_USE_DIRECT_MESSAGE label:@"ダイレクトメッセージ" on:mConfig.isUseDirectMessage];
                    break;
            }
            break;
    }
    
    /*
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    return cell;
     */
    
    return cell;
}

- (CellWithSwitch *)getCellWithSwitch:(int)identifier label:(NSString *)label on:(BOOL)on
{
    CellWithSwitch *cell;
    
    cell = [CellWithSwitch getCell:self.tableView];
    [cell setLabel:label];
    cell.identifier = K_IS_USE_DIRECT_MESSAGE;
    cell.on = on;
    cell.delegate = self;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - Data changed
- (void)cellWithSwitchChanged:(CellWithSwitch *)cell
{
    switch (cell.identifier) {
        case K_IS_USE_EMAIL:
            mConfig.isUseEmail = cell.on;
            break;
            
        case K_IS_USE_TWITTER:
            mConfig.isUseTwitter = cell.on;
            break;
            
        case K_IS_USE_DIRECT_MESSAGE:
            mConfig.isUseDirectMessage = cell.on;
            break;
    }
    [mConfig save];
}

@end
