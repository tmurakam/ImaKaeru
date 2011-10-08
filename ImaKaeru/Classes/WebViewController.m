// -*-  Mode:ObjC; c-basic-offset:4; tab-width:8; indent-tabs-mode:nil -*-
/*
 * ImaKaeru
 * Copyright (C) 2011, Takuya & Yasuko Murakami, All rights reserved.
 * For conditions of distribution and use, see LICENSE file.
 */

#import "WebViewController.h"
#import "Common.h"

@implementation WebViewController

@synthesize urlString = mUrlString;

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
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:mUrlString]];
    [mWebView loadRequest:req];
}

- (void)viewDidUnload
{
    mWebView = nil;
    mBackButton = nil;
    mForwardButton = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)goBackward:(id)sender {
    [mWebView goBack];
}

- (IBAction)goForward:(id)sender {
    [mWebView goForward];
}

- (IBAction)reloadPage:(id)sender {
    [mWebView reload];
}

- (IBAction)doAction:(id)sender {
    UIActionSheet *as = 
        [[UIActionSheet alloc] initWithTitle:nil 
                                    delegate:self
                           cancelButtonTitle:_L(@"Cancel")
                            destructiveButtonTitle:nil
                           otherButtonTitles:_L(@"Open with Safari"), nil];
    [as showInView:self.view];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)v shouldStartLoadWithReq:(NSURLRequest *)req
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //[activityIndicator startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)v
{
    //[activityIndicator stopAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
    mBackButton.enabled = [v canGoBack];
    mForwardButton.enabled = [v canGoForward];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError*)err
{
    //[activityIndicator stopAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - ActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSURL *url;
    switch (buttonIndex) {
        case 0:
            url = [mWebView.request URL];
            [[UIApplication sharedApplication] openURL:url];
            break;
    }
}

@end
