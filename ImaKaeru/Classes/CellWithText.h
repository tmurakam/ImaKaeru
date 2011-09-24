//
//  CellWithSwitch.h
//  ImaKaeru
//
//  Created by 村上 卓弥 on 11/09/17.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CellWithText;

@protocol CellWithTextDelegate
- (void)cellWithTextChanged:(CellWithText *)cell;
@end

@interface CellWithText : UITableViewCell <UITextFieldDelegate>
{
    IBOutlet UILabel *mLabel;
    IBOutlet UITextField *mTextField;
    
    int mIdentifier;
    
    __unsafe_unretained id<CellWithTextDelegate> mDelegate;
}

@property int identifier;

@property(unsafe_unretained) id<CellWithTextDelegate> delegate;
@property(strong) NSString *placeholder;
@property(strong) NSString *text;

+ (CellWithText *)getCell:(UITableView *)tableView;
- (void)setLabel:(NSString *)label;

@end
