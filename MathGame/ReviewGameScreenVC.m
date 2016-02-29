//
//  ReviewGameScreenVC.m
//  MathGame
//
//  Created by Nathan Larson on 10/15/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import "ReviewGameScreenVC.h"
#import "GamePlayVC.h"
#import "GetPlayerNameVC.h"

@interface ReviewGameScreenVC ()<GetPlayerNameDelegate>

@property (nonatomic) NSMutableArray *availableTimes;
@property (nonatomic) NSString *selectedTime;

@property (nonatomic) UIView *cover;
@property (nonatomic) GetPlayerNameVC *getPlayerName;

@end

@implementation ReviewGameScreenVC

- (void)viewWillAppear:(BOOL)animated
{
    self.gameLevelLabel.text = [NSString stringWithFormat:@"Level %@", _levelSelected];
    self.gameLevelLabel.backgroundColor = _levelColor;
    
    self.gameTypeLabel.text = _gameType;
    self.gameTypeLabel.backgroundColor = _gameTypeColor;
    
    
    _availableTimes = [NSMutableArray new];
    for (int i = 1; i <= 60; i++) {
        [_availableTimes addObject:[NSString stringWithFormat:@"%i", i]];
    }
    
    _timeLimitLabel.text = @"2:00 Minutes";
    _selectedTime = @"2";
    
    UITapGestureRecognizer *tappedTime = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeTimeLimit)];
    _timeLimitLabel.userInteractionEnabled = YES;
    [_timeLimitLabel addGestureRecognizer:tappedTime];
}

- (void)viewDidAppear:(BOOL)animated
{
    
}
- (IBAction)chooseLevelButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)playGameAction:(id)sender {
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"user_player_name"] == nil) {
        
        _cover = [UIView new];
        _cover.frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height);
        _cover.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
        [self.view addSubview:_cover];
        
        _getPlayerName = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GetPlayerNameVC class]) owner:self options:nil] objectAtIndex:0];
        _getPlayerName.frame = CGRectMake((self.view.bounds.size.width / 2.0) - 150.0, 5.0, 300.0, 250.0);
        _getPlayerName.layer.cornerRadius = 3.0;
        _getPlayerName.layer.masksToBounds = YES;
        _getPlayerName.delegate = self;
        _getPlayerName.alpha = 0.0;
        _getPlayerName.playNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.view addSubview:_getPlayerName];
        [UIView animateWithDuration:0.3 animations:^{
            _getPlayerName.alpha = 1.0;
        }completion:^(BOOL finished){
            [_getPlayerName.playNameTextField becomeFirstResponder];
        }];
    }else {
        GamePlayVC *viewController = [GamePlayVC new];
        viewController.gameType = _gameType;
        viewController.levelSelected = _levelSelected;
        viewController.timerOn = _timeLimitActiveSwitch.on;
        viewController.timerAmount = _selectedTime;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)savedPlayerName
{
    [UIView animateWithDuration:0.3 animations:^{
        _cover.alpha = 0.0;
        _getPlayerName.alpha = 0.0;
    }completion:^(BOOL finished){
        GamePlayVC *viewController = [GamePlayVC new];
        viewController.gameType = _gameType;
        viewController.levelSelected = _levelSelected;
        viewController.timerOn = _timeLimitActiveSwitch.on;
        viewController.timerAmount = _selectedTime;
        [self.navigationController pushViewController:viewController animated:YES];
    }];
}

- (void)changeTimeLimit
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Time Limit" message:@"Choose a new time limit." preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (int i = 0; i < _availableTimes.count; i++) {
        if (i == 0) {
            [alert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@:00 Minute", _availableTimes[i]] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [self setLabelWithtime:_availableTimes[i]];
            }]];
        }else {
            [alert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@:00 Minutes", _availableTimes[i]] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [self setLabelWithtime:_availableTimes[i]];
            }]];
        }
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)setLabelWithtime:(NSString *)time_selected
{
    _selectedTime = time_selected;
    if (time_selected.intValue == 1) {
        _timeLimitLabel.text = [NSString stringWithFormat:@"%@:00 Minute", time_selected];
    }else {
        _timeLimitLabel.text = [NSString stringWithFormat:@"%@:00 Minutes", time_selected];
    }
}

- (IBAction)turnOnOffTimeLimitAction:(id)sender {
    
    if (((UISwitch *)sender).on) {
        _timeLimitLabel.alpha = 1.0;
        _tapToChangeLabel.alpha = 1.0;
    }else {
        _timeLimitLabel.alpha = 0.0;
        _tapToChangeLabel.alpha = 0.0;
    }
}
@end
