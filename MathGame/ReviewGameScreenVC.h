//
//  ReviewGameScreenVC.h
//  MathGame
//
//  Created by Nathan Larson on 10/15/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewGameScreenVC : UIViewController

@property (nonatomic) NSString *gameType;
@property (nonatomic) UIColor *gameTypeColor;
@property (nonatomic) NSString *levelSelected;
@property (nonatomic) UIColor *levelColor;

@property (weak, nonatomic) IBOutlet UILabel *gameTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *gameLevelLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLimitLabel;
@property (weak, nonatomic) IBOutlet UILabel *tapToChangeLabel;
@property (weak, nonatomic) IBOutlet UISwitch *timeLimitActiveSwitch;

- (IBAction)playGameAction:(id)sender;

- (IBAction)turnOnOffTimeLimitAction:(id)sender;

@end
