//
//  CellWithSwitch.m
//  ImaKaeru
//
//  Created by 村上 卓弥 on 11/09/17.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CellWithSwitch.h"

@interface CellWithSwitch ()
- (void)switchChanged:(id)sender;
@end

@implementation CellWithSwitch

@synthesize delegate = mDelegate;

#define CELL_ID @"CellWithSwitch"

+ (CellWithSwitch *)getCell:(UITableView *)tableView
{
    CellWithSwitch *cell = (CellWithSwitch *)[tableView dequeueReusableCellWithIdentifier:CELL_ID];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:@"CellWithSwitch" bundle:nil];
        NSArray *array = [nib instantiateWithOwner:nil options:nil];
        cell = [array objectAtIndex:0];
    }
    
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [mSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)switchChanged:(id)sender {
    [mDelegate cellWithSwitchChanged:self];
}

- (BOOL)on
{
    return mSwitch.on;
}

#if 0
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#endif



@end
