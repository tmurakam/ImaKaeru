// -*-  Mode:ObjC; c-basic-offset:4; tab-width:8; indent-tabs-mode:nil -*-
/*
 * ImaKaeru
 * Copyright (C) 2011, Takuya & Yasuko Murakami, All rights reserved.
 * For conditions of distribution and use, see LICENSE file.
 */

#import <UIKit/UIKit.h>
#import "CellWithSwitch.h"
#import "CellWithText.h"
#import "Config.h"

@interface ConfigViewController : UITableViewController <CellWithSwitchDelegate, CellWithTextDelegate>
{
    Config *mConfig;
}

- (IBAction)doneAction:(id)sender;

@end
