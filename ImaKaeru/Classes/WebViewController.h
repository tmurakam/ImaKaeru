// -*-  Mode:ObjC; c-basic-offset:4; tab-width:8; indent-tabs-mode:nil -*-
/*
 * ImaKaeru
 * Copyright (C) 2011, Takuya & Yasuko Murakami, All rights reserved.
 * For conditions of distribution and use, see LICENSE file.
 */

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>
{
    NSString *mUrlString;
    __weak IBOutlet UIWebView *mWebView;
}

@property(strong) NSString *urlString;

- (IBAction)goBackward:(id)sender;
- (IBAction)goForward:(id)sender;
- (IBAction)reloadPage:(id)sender;
- (IBAction)doAction:(id)sender;

@end
