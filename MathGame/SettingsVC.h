//
//  SettingsVC.h
//  MathGame
//
//  Created by Nathan Larson on 10/21/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsVC : UIViewController
- (IBAction)doneButtonAction:(id)sender;
- (IBAction)backgroundMusicSwitchAction:(id)sender;
- (IBAction)soundEffectSwitchAction:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *backgroundMusicSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *soundEffectsSwitch;

@end
