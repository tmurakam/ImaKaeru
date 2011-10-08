// -*-  Mode:ObjC; c-basic-offset:4; tab-width:8; indent-tabs-mode:nil -*-
/*
 * ImaKaeru
 * Copyright (C) 2011, Takuya & Yasuko Murakami, All rights reserved.
 * For conditions of distribution and use, see LICENSE file.
 */

#import "ConfigViewController.h"
#import "InfoViewController.h"

#import "Common.h"

#define K_MSG1 0
#define K_MSG2 1
#define K_MSG3 2

#define K_IS_SEND_LOCATION 3

#define K_EMAIL_ADDRESS 4

#define K_IS_USE_DIRECT_MESSAGE 6
#define K_TWITTER_ADDRESS 7


@interface ConfigViewController ()
- (void)doneAction:(id)sender;
- (UITableViewCell *)getPlainCell:(NSString *)label;
- (CellWithSwitch *)getCellWithSwitch:(int)identifier label:(NSString *)label on:(BOOL)on;
- (CellWithSwitch *)getCellWithText:(int)identifier label:(NSString *)label placeholder:(NSString *)placeholder text:(NSString *)text;
@end

@implementation ConfigViewController

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
    mConfig = [Config instance];

    self.title = _L(@"config");
    
    self.navigationItem.rightBarButtonItem = 
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    mConfig = nil;
}

- (IBAction)doneAction:(id)sender
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
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
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return _L(@"messages_config");
        case 1:
            return _L(@"email_config");
        case 2:
            return _L(@"twitter_config");
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 4;
        case 1:
            return 1;
        case 2:
            return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSString *label;

    switch (indexPath.section) {
        case 0:
            // Message settings
            label = [NSString stringWithFormat:@"%@%d", _L(@"message"), indexPath.row + 1];
            switch (indexPath.row) {
                case 0:
                    cell = [self getCellWithText:K_MSG1 label:label placeholder:@"Message" text:mConfig.message1];
                    break;
                case 1:
                    cell = [self getCellWithText:K_MSG2 label:label placeholder:@"Message" text:mConfig.message2];
                    break;
                case 2:
                    cell = [self getCellWithText:K_MSG3 label:label placeholder:@"Message" text:mConfig.message3];
                    break;
                case 3:
                    cell = [self getCellWithSwitch:K_IS_SEND_LOCATION label:_L(@"send_location") on:mConfig.isSendLocation];
                    break;
            }
            break;
            
        case 1:
            // Email settings
            switch (indexPath.row) {
                case 0:
                    cell = [self getCellWithText:K_EMAIL_ADDRESS label:@"To:" placeholder:@"example.gmail.com" text:mConfig.emailAddress];
                    break;
            }
            break;
            
        case 2:
            // Twitter settings
            switch (indexPath.row) {
                case 0:
                    // direct message
                    cell = [self getCellWithSwitch:K_IS_USE_DIRECT_MESSAGE label:_L(@"direct_message") on:mConfig.isUseDirectMessage];
                    break;
                    
                case 1:
                    // address
                    cell = [self getCellWithText:K_TWITTER_ADDRESS label:_L(@"destination") placeholder:@"twitter account" text:mConfig.twitterAddress];
                    break;
            }
            break;
    }
    
    /*
    
    return cell;
     */
    
    return cell;
}

- (UITableViewCell *)getPlainCell:(NSString *)text
{
    static NSString *CellIdentifier = @"PlainCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.textLabel.text = text;
    return cell;
}

- (CellWithSwitch *)getCellWithSwitch:(int)identifier label:(NSString *)label on:(BOOL)on
{
    CellWithSwitch *cell;
    
    cell = [CellWithSwitch getCell:self.tableView];
    [cell setLabel:label];
    cell.identifier = identifier;
    cell.on = on;
    cell.delegate = self;
    return cell;
}

- (CellWithText *)getCellWithText:(int)identifier label:(NSString *)label placeholder:(NSString *)placeholder text:(NSString *)text
{
    CellWithText *cell;
    
    cell = [CellWithText getCell:self.tableView];
    [cell setLabel:label];
    cell.identifier = identifier;
    cell.placeholder = placeholder;
    cell.text = text;
    cell.delegate = self;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 3 && indexPath.row == 0) {
        // info
        InfoViewController *vc = [[InfoViewController alloc] initWithNibName:@"InfoView" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Data changed
- (void)cellWithSwitchChanged:(CellWithSwitch *)cell
{
    switch (cell.identifier) {
        case K_IS_SEND_LOCATION:
            mConfig.isSendLocation = cell.on;
            break;

        case K_IS_USE_DIRECT_MESSAGE:
            mConfig.isUseDirectMessage = cell.on;
            break;
    }
    [mConfig save];
}

- (void)cellWithTextChanged:(CellWithText *)cell
{
    switch (cell.identifier) {
        case K_MSG1:
            mConfig.message1 = cell.text;
            break;

        case K_MSG2:
            mConfig.message2 = cell.text;
            break;
            
        case K_MSG3:
            mConfig.message3 = cell.text;
            break;
            
        case K_EMAIL_ADDRESS:
            mConfig.emailAddress = cell.text;
            break;
            
        case K_TWITTER_ADDRESS:
            mConfig.twitterAddress = cell.text;
            break;
    }
    [mConfig save];
}

@end
