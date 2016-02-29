//
//  GamePlayVC.h
//  MathGame
//
//  Created by Nathan Larson on 10/16/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GamePlayVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *scoreRequiredLabel;

@property (nonatomic) NSString *gameType;
@property (nonatomic) NSString *levelSelected;
@property (nonatomic) BOOL timerOn;
@property (nonatomic) NSString *timerAmount;

- (IBAction)pauseGameButtonAction:(id)sender;

@property (nonatomic) UIView *countDownCover;
@property (nonatomic) UILabel *countDownLabel;
@property (nonatomic) UILabel *levelLabel;
@property (nonatomic) UIView *playView;
@property (weak, nonatomic) IBOutlet UIProgressView *timerProgressView;
@property (weak, nonatomic) IBOutlet UILabel *timeRemainingLabel;
@property (weak, nonatomic) IBOutlet UILabel *incorrectLabel;
@property (weak, nonatomic) IBOutlet UILabel *incorrectAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainingLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainingAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *solvedLabel;
@property (weak, nonatomic) IBOutlet UILabel *solvedAmountLabel;


@property (weak, nonatomic) IBOutlet UIButton *solveItPowerUpOutlet;
- (IBAction)solveItPowerUpAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *countOfSolveItPowerups;

@property (weak, nonatomic) IBOutlet UIButton *thirtySecondPowerUpOutlet;
- (IBAction)thirtySecondPowerUpAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *countOfThirtySecondPowerups;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *numStarsLabel;

@end
