// -*-  Mode:ObjC; c-basic-offset:4; tab-width:8; indent-tabs-mode:nil -*-
/*
 * ImaKaeru
 * Copyright (C) 2011, Takuya & Yasuko Murakami, All rights reserved.
 * For conditions of distribution and use, see LICENSE file.
 */

#import "InfoViewController.h"
#import "Common.h"

@implementation InfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    self.title = _L(@"info");
    
    self.navigationItem.rightBarButtonItem = 
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    
    [mAppNameLabel setText:_L(@"app_name")];
     
    NSString *version = [info valueForKey:@"CFBundleShortVersionString"];
    [mVersionLabel setText:[NSString stringWithFormat:@"Version %@", version]];
}

- (void)viewDidUnload
{
    mAppNameLabel = nil;
    mVersionLabel = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)doneAction:(id)sender {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (IBAction)showHelp:(id)sender {
}

- (IBAction)showWebsite:(id)sender {
}

- (IBAction)showFacebook:(id)sender {
}
@end
