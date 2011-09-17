//
//  CellWithSwitch.h
//  ImaKaeru
//
//  Created by 村上 卓弥 on 11/09/17.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CellWithSwitch;

@protocol CellWithSwitchDelegate
- (void)cellWithSwitchChanged:(CellWithSwitch *)cell;
@end

@interface CellWithSwitch : UITableViewCell
{
    IBOutlet UILabel *mLabel;
    IBOutlet UISwitch *mSwitch;
    
    id<CellWithSwitchDelegate> __unsafe_unretained mDelegate;
}

@property(nonatomic,unsafe_unretained) id<CellWithSwitchDelegate> delegate;
@property(nonatomic,readonly) BOOL on;

+ (CellWithSwitch *)getCell:(UITableView *)tableView;
@end
