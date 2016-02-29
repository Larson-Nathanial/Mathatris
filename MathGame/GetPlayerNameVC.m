//
//  GetPlayerNameVC.m
//  MathGame
//
//  Created by Nathan Larson on 10/20/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import "GetPlayerNameVC.h"

@interface GetPlayerNameVC ()<UITextFieldDelegate>

@end

@implementation GetPlayerNameVC

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@"your name here"]) {
        textField.text = @"";
        textField.textColor = [UIColor whiteColor];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (_playNameTextField.text.length != 0) {
        [textField resignFirstResponder];
        [[NSUserDefaults standardUserDefaults] setValue:textField.text forKey:@"user_player_name"];
        [self.delegate savedPlayerName];
    }
    
    return NO;
}

@end
