//
//  SettingsVC.m
//  MathGame
//
//  Created by Nathan Larson on 10/21/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import "SettingsVC.h"

@implementation SettingsVC

- (void)viewDidAppear:(BOOL)animated
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"is_background_music_on"] isEqualToString:@"YES"]) {
        [_backgroundMusicSwitch setOn:YES animated:YES];
    }else {
        [_backgroundMusicSwitch setOn:NO animated:YES];
    }
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"is_sound_effects_on"] isEqualToString:@"YES"]) {
        [_soundEffectsSwitch setOn:YES animated:YES];
    }else {
        [_soundEffectsSwitch setOn:NO animated:YES];
    }
}

- (IBAction)doneButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)backgroundMusicSwitchAction:(id)sender {
    UISwitch *sw = (UISwitch *)sender;
    if (sw.on) {
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"is_background_music_on"];
    }else {
        [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:@"is_background_music_on"];
    }
}

- (IBAction)soundEffectSwitchAction:(id)sender {
    UISwitch *sw = (UISwitch *)sender;
    if (sw.on) {
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"is_sound_effects_on"];
    }else {
        [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:@"is_sound_effects_on"];
    }
}
@end
