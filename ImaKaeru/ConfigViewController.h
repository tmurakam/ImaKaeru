//
//  ConfigViewController.h
//  ImaKaeru
//
//  Created by 村上 卓弥 on 11/09/17.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellWithSwitch.h"
#import "Config.h"

@interface ConfigViewController : UITableViewController <CellWithSwitchDelegate>
{
    Config *mConfig;
}

@end
