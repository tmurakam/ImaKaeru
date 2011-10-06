// -*-  Mode:ObjC; c-basic-offset:4; tab-width:8; indent-tabs-mode:nil -*-
/*
 * ImaKaeru
 * Copyright (C) 2011, Takuya & Yasuko Murakami, All rights reserved.
 * For conditions of distribution and use, see LICENSE file.
 */

#import "CellWithText.h"

@interface CellWithText ()
- (void)setUp;
- (void)textChanged:(id)sender;
@end

@implementation CellWithText

@synthesize identifier = mIdentifier;
@synthesize delegate = mDelegate;

#define CELL_ID @"CellWithText"

+ (CellWithText *)getCell:(UITableView *)tableView
{
    CellWithText *cell = (CellWithText *)[tableView dequeueReusableCellWithIdentifier:CELL_ID];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:@"CellWithText" bundle:nil];
        NSArray *array = [nib instantiateWithOwner:nil options:nil];
        cell = [array objectAtIndex:0];
        
        [cell setUp];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}

- (void)setUp
{
    [mTextField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setLabel:(NSString *)label
{
    [mLabel setText:label];
}

- (void)setPlaceholder:(NSString *)text
{
    [mTextField setPlaceholder:text];
}

- (NSString *)placeholder
{
    return [mTextField placeholder];
}

- (void)setText:(NSString *)text
{
    [mTextField setText:text];
}

- (NSString *)text
{
    return [mTextField text];
}

- (void)textChanged:(id)sender {
    [mDelegate cellWithTextChanged:self];
}

#if 0
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#endif

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
