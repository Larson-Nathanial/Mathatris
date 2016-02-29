//
//  GamePlayVC.m
//  MathGame
//
//  Created by Nathan Larson on 10/16/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

/*
 1. load first set of blocks.
 2. set buttons on the top but alpha out
 3. do countdown
 4. once countdown finishes, start moving 4 pieces.
 
 */

#import "GamePlayVC.h"
#import "GameObject.h"
#import "GameLogic.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Explode.h"
#import "objc/runtime.h"
#import "GameCompletedVC.h"
#import "PauseGameVC.h"
#import "GetPowerupsVC.h"
#import "ManageScores.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface GamePlayVC ()<PauseGameDelegate, GameCompletedDelegate>

@property (nonatomic) UIButton *b1;
@property (nonatomic) UIButton *b2;
@property (nonatomic) UIButton *b3;
@property (nonatomic) UIButton *b4;
@property (nonatomic) NSTimer *startGameTimer;
@property (nonatomic) NSTimer *answerTimer;
@property (nonatomic) NSTimer *theGameTimer;
@property (nonatomic) NSTimer *wrongAnswerTimer;
@property (nonatomic) int wrongAnswerTimerCount;

@property (nonatomic) UIView *bottomNextEquationView;

@property (nonatomic) float topY;
@property (nonatomic) float startingYPos;

@property (nonatomic) NSArray *currentRowAnswers;
@property (nonatomic) NSMutableArray *allEquationsCurrentlyLoaded;
@property (nonatomic) NSMutableArray *allEquationLabelsOnScreen;

@property (nonatomic) int timeRemaining;

//@property (nonatomic) NSArray *currentEquation;
//@property (nonatomic) NSArray *currentEquationLabels;
//
//@property (nonatomic) NSMutableArray *allEquationsOnScreen;
//@property (nonatomic) NSMutableArray *equationsCurrentlyDisplayed;

@property (nonatomic) UIView *mainCoverView;

@property (nonatomic) NSArray *objectSolved;

@property (nonatomic) int numberEquationsSolved;
@property (nonatomic) int numberEquationsIncorrect;
@property (nonatomic) int numberOfEquationsRemaining;

@property (nonatomic) PauseGameVC *PGView;
@property (nonatomic) GameCompletedVC *gcView;
@property (nonatomic) int currentlyPlaying;

@property (nonatomic) int currentScoreForLevel;

@property (nonatomic) AVAudioPlayer *player;
@property (nonatomic) AVAudioPlayer *explosion1Player;
@property (nonatomic) AVAudioPlayer *explosion2Player;

@property (nonatomic) int scoreRequiredToPass;
@property (nonatomic) int currentLevel;



@property (nonatomic) int currentCorrectStreak;

@end

@implementation GamePlayVC

- (void)viewDidLoad
{
//    _equationsCurrentlyDisplayed = [NSMutableArray new];
    _allEquationsCurrentlyLoaded = [NSMutableArray new];
    _allEquationLabelsOnScreen = [NSMutableArray new];
    
    _numberEquationsIncorrect = 0;
    _numberEquationsSolved = 0;
    _wrongAnswerTimerCount = 0;
    _currentlyPlaying = 0;
    _currentLevel = _levelSelected.intValue;
    
    _currentCorrectStreak = 0;
    
    int curTime = _timerAmount.intValue;
    curTime = curTime * 60;
    int num = curTime / 4;
    
    NSString *last_num = [_levelSelected substringFromIndex: [_levelSelected length] - 1];
    
    num = num - 3 + last_num.intValue;
    
    _scoreRequiredToPass = num * 25;
    
    _scoreRequiredLabel.text = [NSString stringWithFormat:@"To Pass: %i", _scoreRequiredToPass];
    
    self.navigationItem.hidesBackButton = YES;
   
    
    // Set countdown label invisible.
    _countDownLabel.alpha = 0.0;
    
    // give the playview a border.
    self.playView.layer.borderColor = [UIColor blackColor].CGColor;
    self.playView.layer.borderWidth = 1.0;

    [self.playView removeFromSuperview];
    self.playView = nil;
    self.playView = [UIView new];
    [self.view addSubview:self.playView];
    
    if (_timerOn) {
        _remainingAmountLabel.alpha = 0.0;
        _remainingLabel.alpha = 0.0;
    }else {
        _timeRemainingLabel.alpha = 0.0;
        _timerProgressView.alpha = 0.0;
    }
    
    NSString *countSolveItPU = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_num_equation_solvers"];
    if (countSolveItPU == nil || countSolveItPU.intValue == 0) {
        _countOfSolveItPowerups.text = @"(0)";
    }else {
        _countOfSolveItPowerups.text = [NSString stringWithFormat:@"(%i)", countSolveItPU.intValue];
    }
    
    NSString *countThirtySecPU = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_num_thirty_second_boosters"];
    if (countThirtySecPU == nil || countThirtySecPU.intValue == 0) {
        _countOfThirtySecondPowerups.text = @"(0)";
    }else {
        _countOfThirtySecondPowerups.text = [NSString stringWithFormat:@"(%i)", countThirtySecPU.intValue];
    }
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"is_sound_effects_on"] isEqualToString:@"YES"]) {
        NSString *soundFilePath = [NSString stringWithFormat:@"%@/explode1.m4a",
                                   [[NSBundle mainBundle] resourcePath]];
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        
        _explosion1Player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL
                                                                   error:nil];
        _explosion1Player.numberOfLoops = 0;
        
        NSString *soundFilePath2 = [NSString stringWithFormat:@"%@/explode2.m4a",
                                    [[NSBundle mainBundle] resourcePath]];
        NSURL *soundFileURL2 = [NSURL fileURLWithPath:soundFilePath2];
        
        _explosion2Player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL2
                                                                   error:nil];
        _explosion2Player.numberOfLoops = 0;
    }
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"is_background_music_on"] isEqualToString:@"YES"]) {
        NSString *soundFilePath3 = [NSString stringWithFormat:@"%@/gameTrack1.mp3",
                                    [[NSBundle mainBundle] resourcePath]];
        NSURL *soundFileURL3 = [NSURL fileURLWithPath:soundFilePath3];
        
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL3
                                                         error:nil];
        _player.numberOfLoops = -1; //Infinite
    }
    
    
    
    
    [self createObjects];
    
}

- (void)createObjects
{
    [_bottomNextEquationView removeFromSuperview];
    _bottomNextEquationView = nil;
    _bottomNextEquationView = [UIView new];
    
    [self.countDownCover removeFromSuperview];
    self.countDownCover = nil;
    self.countDownCover = [UIView new];
    
    [self.countDownLabel removeFromSuperview];
    self.countDownLabel = nil;
    self.countDownLabel = [UILabel new];
    
    [self.levelLabel removeFromSuperview];
    self.levelLabel = nil;
    self.levelLabel = [UILabel new];
    
    [_b1 removeFromSuperview];
    _b1 = nil;
    _b1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _b1.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    [_b2 removeFromSuperview];
    _b2 = nil;
    _b2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _b2.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    [_b3 removeFromSuperview];
    _b3 = nil;
    _b3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _b3.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    [_b4 removeFromSuperview];
    _b4 = nil;
    _b4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _b4.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    [_b1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_b2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_b3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_b4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _b1.tag = 1;
    _b2.tag = 2;
    _b3.tag = 3;
    _b4.tag = 4;
    
    _b1.layer.cornerRadius = 3.0;
    _b1.layer.masksToBounds = YES;
    _b2.layer.cornerRadius = 3.0;
    _b2.layer.masksToBounds = YES;
    _b3.layer.cornerRadius = 3.0;
    _b3.layer.masksToBounds = YES;
    _b4.layer.cornerRadius = 3.0;
    _b4.layer.masksToBounds = YES;
    
    [_b1.titleLabel setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:22.0]];
    [_b2.titleLabel setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:22.0]];
    [_b3.titleLabel setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:22.0]];
    [_b4.titleLabel setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:22.0]];
    
    
    [_b1 addTarget:self action:@selector(tappedAnswer:) forControlEvents:UIControlEventTouchUpInside];
    [_b2 addTarget:self action:@selector(tappedAnswer:) forControlEvents:UIControlEventTouchUpInside];
    [_b3 addTarget:self action:@selector(tappedAnswer:) forControlEvents:UIControlEventTouchUpInside];
    [_b4 addTarget:self action:@selector(tappedAnswer:) forControlEvents:UIControlEventTouchUpInside];
    
    _currentScoreForLevel = 0;
    _scoreLabel.text = @"0";
}

- (void)setupGame
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.playView.frame = CGRectMake(80.0, 126.0, self.view.bounds.size.width - 160.0,  _timerProgressView.frame.origin.y - 8.0 - 126.0);
    }else {
        if (self.view.bounds.size.width == 320.0) {
            self.playView.frame = CGRectMake(55.0, 126.0, self.view.bounds.size.width - 110.0,  _timerProgressView.frame.origin.y - 8.0 - 126.0);
        }else {
            self.playView.frame = CGRectMake(20.0, 126.0, self.view.bounds.size.width - 40.0,  _timerProgressView.frame.origin.y - 8.0 - 126.0);
        }
        
    }
    
    self.countDownCover.frame = CGRectMake(0.0, 0.0, self.playView.bounds.size.width, self.playView.bounds.size.height);
    
    self.playView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    self.playView.layer.cornerRadius = 3.0;
    self.playView.clipsToBounds = YES;
    self.playView.layer.masksToBounds = YES;
    self.countDownCover.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.86];
    self.countDownCover.tag = 548;
    
    
    self.countDownLabel.frame = CGRectMake((self.playView.bounds.size.width / 2.0) - (135.0 / 2.0), (self.playView.bounds.size.height / 2.0) - (135.0 / 2.0), 135.0, 135.0);
    self.countDownLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:144.0];
    self.countDownLabel.textColor = [UIColor whiteColor];
    self.countDownLabel.text = @"3";
    self.countDownLabel.alpha = 0.0;
    self.countDownLabel.textAlignment = NSTextAlignmentCenter;
    self.countDownLabel.tag = 549;
    [self.countDownCover addSubview:self.countDownLabel];
    
    self.levelLabel.frame = CGRectMake(0.0, 0.0, self.playView.bounds.size.width, 100.0);
    self.levelLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:65.0];
    self.levelLabel.textColor = [UIColor whiteColor];
    self.levelLabel.text = [NSString stringWithFormat:@"Level %@", _levelSelected];
    self.levelLabel.textAlignment = NSTextAlignmentCenter;
    self.levelLabel.tag = 547;
    [self.countDownCover addSubview:self.levelLabel];
    
    
    
    [self.playView addSubview:self.countDownCover];
    
    _mainCoverView = [UIView new];
    _mainCoverView.frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height);
    _mainCoverView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    _mainCoverView.alpha = 0.0;
    [self.view addSubview:_mainCoverView];
    
    _PGView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PauseGameVC class]) owner:self options:nil] objectAtIndex:0];
    _PGView.frame = CGRectMake((self.view.bounds.size.width / 2.0) - 150.0, (self.view.bounds.size.height / 2.0) - (204.0 / 2.0), 300.0, 204.0);
    _PGView.layer.cornerRadius = 3.0;
    _PGView.layer.masksToBounds = YES;
    _PGView.delegate = self;
    _PGView.alpha = 0.0;
    [_mainCoverView addSubview:_PGView];
    
    _gcView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GameCompletedVC class]) owner:self options:nil] objectAtIndex:0];
    _gcView.frame = CGRectMake((self.view.bounds.size.width / 2.0) - 150.0, (self.view.bounds.size.height / 2.0) - (315.0 / 2.0), 300.0, 315.0);
    _gcView.layer.cornerRadius = 3.0;
    _gcView.layer.masksToBounds = YES;
    _gcView.delegate = self;
    _gcView.alpha = 0.0;
    [_mainCoverView addSubview:_gcView];
}



- (void)setupAnswers
{
    // clear all blocks from the screen.
    for (UILabel *label in self.playView.subviews) {
        if (label.tag != 547 && label.tag != 548 && label.tag != 549) {
            [label removeFromSuperview];
        }
    }
    
    
    // Load first set of blocks.
    NSArray *equations = [[GameLogic functions] equationsBasedOnType:_gameType withCombo:nil level:_levelSelected timer:_timerOn];
    _allEquationsCurrentlyLoaded = [NSMutableArray arrayWithArray:equations];
    _numberOfEquationsRemaining = (int)_allEquationsCurrentlyLoaded.count;
    _remainingAmountLabel.text = [NSString stringWithFormat:@"%i", _numberOfEquationsRemaining];
    [self loadEquations:equations];
//    _currentEquation = [NSArray arrayWithArray:equations[_equationsCurrentlyDisplayed.count - 1]];
    
    // setup the bottom cover
    
    _bottomNextEquationView.frame = CGRectMake(0.0, self.playView.bounds.size.height - ((self.playView.bounds.size.width / 5.0) * 2.0), self.playView.bounds.size.width, (self.playView.bounds.size.width / 5.0) * 2.0);
    _bottomNextEquationView.backgroundColor = [UIColor colorWithWhite:55.0 / 255.0 alpha:0.9];
    [self.playView addSubview:_bottomNextEquationView];
    
    // Set buttons on the top but alpha out.
    
    NSArray *topMostEquation = [_allEquationsCurrentlyLoaded objectAtIndex:_allEquationsCurrentlyLoaded.count - 1];
    GameObject *object = nil;
    for (GameObject *gO in topMostEquation) {
        NSLog(@"%@", gO.blockTitle);
        if (gO.isAnswer) {
            object = gO;
        }
    }
    
    float widthHeight = self.playView.bounds.size.width / 5.0;
    float spacing = (self.playView.bounds.size.width - (widthHeight * 4.0)) / 5.0;
    
    _b1.frame = CGRectMake(spacing, 0.0, widthHeight, widthHeight);
    [self.playView addSubview:_b1];
    
    _b2.frame = CGRectMake(spacing + widthHeight + (spacing), 0.0, widthHeight, widthHeight);
    [self.playView addSubview:_b2];
    
    _b3.frame = CGRectMake(spacing + widthHeight + (spacing) + widthHeight + (spacing), 0.0, widthHeight, widthHeight);
    [self.playView addSubview:_b3];
    
    _b4.frame = CGRectMake(spacing + widthHeight + (spacing) + widthHeight + (spacing) + widthHeight + (spacing), 0.0, widthHeight, widthHeight);
    [self.playView addSubview:_b4];
    
    _b1.alpha = 0.0;
    _b2.alpha = 0.0;
    _b3.alpha = 0.0;
    _b4.alpha = 0.0;
    
    [self newSetOfAnswers:[[GameLogic functions] generatePossibleAnswersForLevel:_levelSelected andAnswer:object]];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [_player stop];
}

- (void)viewDidAppear:(BOOL)animated
{
   self.numStarsLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"stars_earned"];
    
    [_player play];
    
    
    if (_currentlyPlaying == 0) {
        _currentlyPlaying = 1;
        [self setupGame];
        
        [self setupAnswers];
        
        [self startCountDown];
    }
    
    
}

- (void)startCountDown
{
    // Countdown
    [self.playView bringSubviewToFront:_countDownCover];
    [self.playView bringSubviewToFront:_countDownLabel];
    
    _countDownLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:144.0]; // set font size which you want instead of 35
    _countDownLabel.transform = CGAffineTransformScale(_countDownLabel.transform, 0.35, 0.35);
    [UIView animateWithDuration:0.5 animations:^{
        _countDownLabel.alpha = 1.0;
        _countDownLabel.transform = CGAffineTransformScale(_countDownLabel.transform, 3.5, 3.5);
    }];
    _timeRemainingLabel.text = [NSString stringWithFormat:@"%i:00", _timerAmount.intValue];
    _startGameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownGame) userInfo:nil repeats:YES];
}

- (void)countDownGame
{
    int currentNumber = _countDownLabel.text.intValue;
    if (currentNumber == 1) {
        [UIView animateWithDuration:0.5 animations:^{
            _countDownCover.alpha = 0.0;
            _countDownLabel.alpha = 0.0;
            
            _b1.alpha = 1.0;
            _b2.alpha = 1.0;
            _b3.alpha = 1.0;
            _b4.alpha = 1.0;
            
        }completion:^(BOOL finished){
            [_startGameTimer invalidate];
            if (_timerOn) {
                [self startCountingForGame];
            }
            [self startThisSet];
        }];
    }else {
        currentNumber--;
        _countDownLabel.text = [NSString stringWithFormat:@"%i", currentNumber];
        
        _countDownLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:144.0]; // set font size which you want instead of 35
        _countDownLabel.transform = CGAffineTransformScale(_countDownLabel.transform, 0.35, 0.35);
        [UIView animateWithDuration:0.5 animations:^{
            _countDownLabel.transform = CGAffineTransformScale(_countDownLabel.transform, 3.5, 3.5);
        }];
    }
}

- (void)startCountingForGame
{
    _timeRemaining = _timerAmount.intValue * 60;
    _theGameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(isTimerUp) userInfo:nil repeats:YES];
    
}

- (void)isTimerUp
{
    _timeRemaining--;
    
    float progressAmount = _timeRemaining / (_timerAmount.floatValue * 60.0);
    
    self.timerProgressView.progress = progressAmount;
    
    if (_timeRemaining < 59) {
        if (_timeRemaining < 10) {
            _timeRemainingLabel.text = [NSString stringWithFormat:@"0:0%i", _timeRemaining];
        }else {
            _timeRemainingLabel.text = [NSString stringWithFormat:@"0:%i", _timeRemaining];
        }
    }else {
        int seconds = _timeRemaining % 60;
        int minutes = (_timeRemaining - seconds) / 60;
        if (seconds < 10) {
            _timeRemainingLabel.text = [NSString stringWithFormat:@"%i:0%i", minutes, seconds];
        }else {
            _timeRemainingLabel.text = [NSString stringWithFormat:@"%i:%i", minutes, seconds];
        }
    }
    
    if (_timeRemaining == 0) {
        // the end
        [_theGameTimer invalidate];
        [_answerTimer invalidate];
        
        
     
        _gcView.menuTitleLabel.text = @"Time's Up!";
        _gcView.goalLabel.text = [NSString stringWithFormat:@"%i", _scoreRequiredToPass];
        _gcView.actualLabel.text = [NSString stringWithFormat:@"%i", _currentScoreForLevel];
        
        if (_currentScoreForLevel >= _scoreRequiredToPass) {
            _gcView.nextLevelButton.alpha = 1.0;
            _currentLevel = _currentLevel + 1;
            [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:[NSString stringWithFormat:@"%@level%ilocked", _gameType, _currentLevel]];
            _currentLevel = _currentLevel - 1;
            
            int curTime = _timerAmount.intValue;
            curTime = curTime * 60;
            int num = curTime / 4;
            
            NSString *last_num = [[NSString stringWithFormat:@"%i", _currentLevel] substringFromIndex:[[NSString stringWithFormat:@"%i", _currentLevel] length] - 1];
            
            num = num - 3 + last_num.intValue;
            
            _scoreRequiredToPass = num * 25;
            
//            _scoreRequiredLabel.text = [NSString stringWithFormat:@"To Pass: %i", _scoreRequiredToPass];
            
            
            
        }else {
            _gcView.nextLevelButton.alpha = 0.0;
        }
        
        
       
        [[ManageScores scoreManager] completedLevel:_levelSelected forTime:_timerAmount withScore:[NSString stringWithFormat:@"%i", _currentScoreForLevel] ofGameType:_gameType];
        
        [UIView animateWithDuration:0.3 animations:^{
            _mainCoverView.alpha = 1.0;
            _gcView.alpha = 1.0;
        }];
        
        _currentScoreForLevel = 0;
        _numberEquationsIncorrect = 0;
        _numberEquationsSolved = 0;
        _scoreLabel.text = @"0";
        _solvedAmountLabel.text = @"0";
        _incorrectAmountLabel.text = @"0";
    }
}

// first load only.
- (void)loadEquations:(NSArray *)equations
{
    float yPos = self.playView.bounds.size.height - ((self.playView.bounds.size.width / 5.0) * 3);
    float blockHeightWidth = self.playView.bounds.size.width / 5.0;
    
    NSMutableArray *mArray = [NSMutableArray new];
    
    for (int i = 1; i <= 3; i++) {
        NSMutableArray *mBArray = [NSMutableArray new];
//        [_equationsCurrentlyDisplayed addObject:equations[i]];
        for (int j = 0; j < 5; j++) {
            
            GameObject *gameObject = (GameObject *)equations[equations.count - i][j];
            
            UILabel *block = [UILabel new];
            
            if ([gameObject.blockTitle isEqualToString:@""]) {
                block.backgroundColor = [UIColor clearColor];
            }else {
                block.backgroundColor = gameObject.blockColor;
            }
            
            block.font = [UIFont fontWithName:@"AvenirNext-Regular" size:22.0];
            block.textColor = [UIColor whiteColor];
            block.textAlignment = NSTextAlignmentCenter;
            block.text = gameObject.blockTitle;
            block.layer.cornerRadius = 3.0;
            block.layer.masksToBounds = YES;
            
            block.frame = CGRectMake(blockHeightWidth * j, yPos, blockHeightWidth, blockHeightWidth);
            
            block.numberOfLines = 1;
            block.adjustsFontSizeToFitWidth = YES;
            block.minimumScaleFactor = 4. / block.font.pointSize;
            
            [mBArray addObject:block];
            block.alpha = 0.0;
            [self.playView addSubview:block];
            [UIView animateWithDuration:0.5 animations:^{
                block.alpha = 1.0;
            }];
        }
        [mArray addObject:mBArray];
        yPos = yPos + blockHeightWidth;
    }
    _allEquationLabelsOnScreen = [NSMutableArray arrayWithArray:mArray];
    _topY = self.playView.bounds.size.height - ((self.playView.bounds.size.width / 5.0) * 4);
}

- (void)showMoreEquations
{
    float yPos = self.playView.bounds.size.height;
    float blockHeightWidth = self.playView.bounds.size.width / 5.0;
    
    NSMutableArray *mArray = [NSMutableArray new];
    
//    NSMutableArray *qAr = [NSMutableArray arrayWithArray:_allEquationsOnScreen];
//    [qAr removeObjectAtIndex:_allEquationsOnScreen.count - 1];
//    _allEquationsOnScreen = [NSMutableArray arrayWithArray:qAr];
    
    int maxLimit = 2;
    if (_allEquationsCurrentlyLoaded.count == 2) {
        maxLimit = 1;
    }
    
    NSLog(@"All Equations on screen: %i", (int)_allEquationsCurrentlyLoaded.count);
    
    for (int i = 1; i <= maxLimit; i++) {
        NSMutableArray *mBArray = [NSMutableArray new];
        for (int j = 0; j < 5; j++) {
            
            GameObject *gameObject = (GameObject *)_allEquationsCurrentlyLoaded[_allEquationsCurrentlyLoaded.count - (i + 1)][j];
            
            UILabel *block = [UILabel new];
            NSLog(@"Game Object Title: %@", gameObject.blockTitle);
            NSLog(@"i value: %i", i);
            if ([gameObject.blockTitle isEqualToString:@""]) {
                block.backgroundColor = [UIColor clearColor];
            }else {
                block.backgroundColor = gameObject.blockColor;
            }
            
            block.font = [UIFont fontWithName:@"AvenirNext-Regular" size:22.0];
            block.textColor = [UIColor whiteColor];
            block.textAlignment = NSTextAlignmentCenter;
            block.text = gameObject.blockTitle;
            block.layer.cornerRadius = 3.0;
            block.layer.masksToBounds = YES;
            
            block.frame = CGRectMake(blockHeightWidth * j, yPos, blockHeightWidth, blockHeightWidth);
            [mBArray addObject:block];
            [self.playView addSubview:block];
        }
        [mArray addObject:mBArray];
        yPos = yPos + blockHeightWidth;
    }
    NSMutableArray *uRay = [NSMutableArray arrayWithArray:_allEquationLabelsOnScreen];
    for (UILabel *gO in mArray) {
        [uRay addObject:gO];
    }
    _allEquationLabelsOnScreen = [NSMutableArray arrayWithArray:uRay];
    
    [self.playView bringSubviewToFront:_bottomNextEquationView];
    
    if (maxLimit == 1) {
        [UIView animateWithDuration:0.3 animations:^{
            _bottomNextEquationView.frame = CGRectMake(0.0, self.playView.bounds.size.height - ((self.playView.bounds.size.width / 5.0) * 1.0), self.playView.bounds.size.width, (self.playView.bounds.size.width / 5.0) * 1.0);
        }];
        for (int i = 0; i < _allEquationLabelsOnScreen.count; i++) {
            for (int j = 0; j < 5; j++) {
                UILabel *block = (UILabel *)_allEquationLabelsOnScreen[i][j];
                [UIView animateWithDuration:0.5 animations:^{
                    block.frame = CGRectMake(block.frame.origin.x, block.frame.origin.y - ((self.playView.bounds.size.width / 5.0) * 1.0), block.frame.size.width, block.frame.size.height);
                }];
                
            }
        }
        _topY = self.playView.bounds.size.height - (blockHeightWidth * 4.0);
    }else if (maxLimit == 2) {
        [UIView animateWithDuration:0.3 animations:^{
            _bottomNextEquationView.frame = CGRectMake(0.0, self.playView.bounds.size.height - ((self.playView.bounds.size.width / 5.0) * 2.0), self.playView.bounds.size.width, (self.playView.bounds.size.width / 5.0) * 2.0);
        }];
        for (int i = 0; i < _allEquationLabelsOnScreen.count; i++) {
            for (int j = 0; j < 5; j++) {
                UILabel *block = (UILabel *)_allEquationLabelsOnScreen[i][j];
                [UIView animateWithDuration:0.5 animations:^{
                    block.frame = CGRectMake(block.frame.origin.x, (block.frame.origin.y - ((self.playView.bounds.size.width / 5.0) * 2.0)), block.frame.size.width, block.frame.size.height);
                }completion:^(BOOL finished){
                    
                }];
                
                
            }
        }
        _topY = self.playView.bounds.size.height - (blockHeightWidth * 5.0);
    }
}

- (void)showMoreEquationsForTimedGame
{
    NSArray *equations = [[GameLogic functions] loadTwoMoreEquationsForType:_gameType withCombo:nil level:_levelSelected];
    for (NSArray *array in equations) {
        [_allEquationsCurrentlyLoaded insertObject:array atIndex:0];
    }
    [self showMoreEquations];
}

- (void)addRowAndMoveEquationsUp
{
    NSArray *equation = [[GameLogic functions] loadEquationForType:_gameType withCombo:nil level:_levelSelected];
    for (NSArray *array in equation) {
        [_allEquationsCurrentlyLoaded insertObject:array atIndex:0];
    }
    
    float yPos = self.playView.bounds.size.height;
    float blockHeightWidth = self.playView.bounds.size.width / 5.0;
    
    NSMutableArray *mArray = [NSMutableArray new];
    
    for (int i = 1; i <= 1; i++) {
        NSMutableArray *mBArray = [NSMutableArray new];
        for (int j = 0; j < 5; j++) {
            
            GameObject *gameObject = (GameObject *)_allEquationsCurrentlyLoaded[_allEquationsCurrentlyLoaded.count - (i + _allEquationLabelsOnScreen.count)][j];
            
            UILabel *block = [UILabel new];
            NSLog(@"Game Object Title: %@", gameObject.blockTitle);
            NSLog(@"i value: %i", i);
            if ([gameObject.blockTitle isEqualToString:@""]) {
                block.backgroundColor = [UIColor clearColor];
            }else {
                block.backgroundColor = gameObject.blockColor;
            }
            
            block.font = [UIFont fontWithName:@"AvenirNext-Regular" size:22.0];
            block.textColor = [UIColor whiteColor];
            block.textAlignment = NSTextAlignmentCenter;
            block.text = gameObject.blockTitle;
            block.layer.cornerRadius = 3.0;
            block.layer.masksToBounds = YES;
            
            
            block.frame = CGRectMake(blockHeightWidth * j, yPos, blockHeightWidth, blockHeightWidth);
            
            block.numberOfLines = 1;
            block.adjustsFontSizeToFitWidth = YES;
            block.minimumScaleFactor = 4. / block.font.pointSize;
            
            [mBArray addObject:block];
            [self.playView addSubview:block];
        }
        [mArray addObject:mBArray];
        yPos = yPos + blockHeightWidth;
    }
    NSMutableArray *uRay = [NSMutableArray arrayWithArray:_allEquationLabelsOnScreen];
    for (UILabel *gO in mArray) {
        [uRay addObject:gO];
    }
    _allEquationLabelsOnScreen = [NSMutableArray arrayWithArray:uRay];
    
    [self.playView bringSubviewToFront:_bottomNextEquationView];
    
    [UIView animateWithDuration:0.3 animations:^{
        _bottomNextEquationView.frame = CGRectMake(0.0, self.playView.bounds.size.height - ((self.playView.bounds.size.width / 5.0) * (_allEquationLabelsOnScreen.count - 1.0)), self.playView.bounds.size.width, (self.playView.bounds.size.width / 5.0) * (_allEquationLabelsOnScreen.count - 1.0));
    }];
    
    for (int i = 0; i < _allEquationLabelsOnScreen.count; i++) {
        for (int j = 0; j < 5; j++) {
            UILabel *block = (UILabel *)_allEquationLabelsOnScreen[i][j];
            [UIView animateWithDuration:0.5 animations:^{
                block.frame = CGRectMake(block.frame.origin.x, (block.frame.origin.y - ((self.playView.bounds.size.width / 5.0) * 1.0)), block.frame.size.width, block.frame.size.height);
            }completion:^(BOOL finished){
                
            }];
        }
    }
    
    _topY = self.playView.bounds.size.height - (blockHeightWidth * (_allEquationLabelsOnScreen.count + 1.0));
}

//- (void)animateNextBlock:(UILabel *)block
//{
//    float blocksYPos = block.frame.origin.y;
//    
//    
//    [UIView animateWithDuration:1.5 animations:^{
//        block.frame = CGRectMake(block.frame.origin.x, (blocksYPos - ((self.playView.bounds.size.width / 5.0) * 2.0)) + 25.0, block.frame.size.width, block.frame.size.height);
//    }completion:^(BOOL finished){
//        [UIView animateWithDuration:1.5 animations:^{
//            block.frame = CGRectMake(block.frame.origin.x, (blocksYPos - ((self.playView.bounds.size.width / 5.0) * 2.0)) - 5.0, block.frame.size.width, block.frame.size.height);
//        }completion:^(BOOL finished){
//            [UIView animateWithDuration:1.5 animations:^{
//                block.frame = CGRectMake(block.frame.origin.x, (blocksYPos - ((self.playView.bounds.size.width / 5.0) * 2.0)), block.frame.size.width, block.frame.size.height);
//            }completion:^(BOOL finished){
//                
//            }];
//        }];
//    }];
//}

- (void)newSetOfAnswers:(NSArray *)answers
{
    _currentRowAnswers = [NSArray arrayWithArray:answers];
    
    GameObject *obj1 = answers[0];
    GameObject *obj2 = answers[1];
    GameObject *obj3 = answers[2];
    GameObject *obj4 = answers[3];
    
    [_b1 setTitle:obj1.blockTitle forState:UIControlStateNormal];
    _b1.backgroundColor = obj1.blockColor;
    
    [_b2 setTitle:obj2.blockTitle forState:UIControlStateNormal];
    _b2.backgroundColor = obj2.blockColor;
    
    [_b3 setTitle:obj3.blockTitle forState:UIControlStateNormal];
    _b3.backgroundColor = obj3.blockColor;
    
    [_b4 setTitle:obj4.blockTitle forState:UIControlStateNormal];
    _b4.backgroundColor = obj4.blockColor;
    
    _startingYPos = 0.0;
}

- (void)startThisSet
{
    
    
    float timeInterval = 0.01;
    if (_levelSelected.intValue == 2 || _levelSelected.intValue == 12 || _levelSelected.intValue == 22) {
        timeInterval = timeInterval - 0.001;
    }else if (_levelSelected.intValue == 3 || _levelSelected.intValue == 13 || _levelSelected.intValue == 23) {
        timeInterval = timeInterval - 0.002;
    }else if (_levelSelected.intValue == 4 || _levelSelected.intValue == 14 || _levelSelected.intValue == 24) {
        timeInterval = timeInterval - 0.003;
    }else if (_levelSelected.intValue == 5 || _levelSelected.intValue == 15 || _levelSelected.intValue == 25) {
        timeInterval = timeInterval - 0.004;
    }else if (_levelSelected.intValue == 6 || _levelSelected.intValue == 16 || _levelSelected.intValue == 26) {
        timeInterval = timeInterval - 0.005;
    }else if (_levelSelected.intValue == 7 || _levelSelected.intValue == 17 || _levelSelected.intValue == 27) {
        timeInterval = timeInterval - 0.006;
    }else if (_levelSelected.intValue == 8 || _levelSelected.intValue == 18 || _levelSelected.intValue == 28) {
        timeInterval = timeInterval - 0.007;
    }else if (_levelSelected.intValue == 9 || _levelSelected.intValue == 19 || _levelSelected.intValue == 29) {
        timeInterval = timeInterval - 0.008;
    }else if (_levelSelected.intValue == 10 || _levelSelected.intValue == 20 || _levelSelected.intValue == 30) {
        timeInterval = timeInterval - 0.009;
    }
    
    
    _answerTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(moveAnswers) userInfo:nil repeats:YES];
}

- (void)moveAnswers
{
    if (_startingYPos < _topY) {
        if ((_topY - (self.playView.bounds.size.width / 5.0)) < self.playView.bounds.origin.y) {
            
            _gcView.nextLevelButton.alpha = 0.0;
            _gcView.menuTitleLabel.text = @"Over the top!";
            _gcView.goalLabel.text = [NSString stringWithFormat:@"%i", _scoreRequiredToPass];
            _gcView.actualLabel.text = [NSString stringWithFormat:@"%i", _currentScoreForLevel];
            _mainCoverView.alpha = 0.0;
            _gcView.alpha = 0.0;
            [UIView animateWithDuration:0.3 animations:^{
                _mainCoverView.alpha = 1.0;
                _gcView.alpha = 1.0;
            }];
            [_theGameTimer invalidate];
            [_answerTimer invalidate];
        }else {
            _b1.frame = CGRectMake(_b1.frame.origin.x, _startingYPos, _b1.frame.size.width, _b1.frame.size.height);
            _b2.frame = CGRectMake(_b2.frame.origin.x, _startingYPos, _b2.frame.size.width, _b2.frame.size.height);
            _b3.frame = CGRectMake(_b3.frame.origin.x, _startingYPos, _b3.frame.size.width, _b3.frame.size.height);
            _b4.frame = CGRectMake(_b4.frame.origin.x, _startingYPos, _b4.frame.size.width, _b4.frame.size.height);
            _startingYPos = _startingYPos + 0.1;
        }
        
        
    }else {
        
        _gcView.nextLevelButton.alpha = 0.0;
        _gcView.menuTitleLabel.text = @"Too Slow!";
        _gcView.goalLabel.text = [NSString stringWithFormat:@"%i", _scoreRequiredToPass];
        _gcView.actualLabel.text = [NSString stringWithFormat:@"%i", _currentScoreForLevel];
        
      
        [UIView animateWithDuration:0.3 animations:^{
            _mainCoverView.alpha = 1.0;
            _gcView.alpha = 1.0;
        }];

        [_theGameTimer invalidate];
        [_answerTimer invalidate];
    }
}

- (void)tappedAnswer:(UIButton *)button
{
    int pAnswer = button.titleLabel.text.intValue;
    int equationAnswer = 0;
    for (GameObject *object in _allEquationsCurrentlyLoaded[_allEquationsCurrentlyLoaded.count - 1]) {
        if (object.isAnswer) {
            equationAnswer = object.blockTitle.intValue;
        }
    }
    
    if (equationAnswer == pAnswer) {
        _numberEquationsSolved++;
        _solvedAmountLabel.text = [NSString stringWithFormat:@"%i", _numberEquationsSolved];
        _numberOfEquationsRemaining--;
        _remainingAmountLabel.text = [NSString stringWithFormat:@"%i", _numberOfEquationsRemaining];
        
        _currentScoreForLevel = _currentScoreForLevel + 25;
        _scoreLabel.text = [NSString stringWithFormat:@"%i", _currentScoreForLevel];
        
        _currentCorrectStreak++;
        
        if (_currentCorrectStreak % 5 == 0) {
            int nu = [[[NSUserDefaults standardUserDefaults] valueForKey:@"stars_earned"] intValue];
            nu++;
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%i", nu] forKey:@"stars_earned"];
            self.numStarsLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"stars_earned"];
        }
        
        [self selectedAnswer:button];
        [_answerTimer invalidate];
    }else {
        
        if ([_gameType isEqualToString:@"Multiplication x"]) {

            int countOfZeros = 0;
            
            for (GameObject *object in _allEquationsCurrentlyLoaded[_allEquationsCurrentlyLoaded.count - 1]) {
                if ([object.blockTitle isEqualToString:@"0"]) {
                    countOfZeros = countOfZeros + 1;
                }
            }
            
            if (countOfZeros >= 2) {
                _numberEquationsSolved++;
                _solvedAmountLabel.text = [NSString stringWithFormat:@"%i", _numberEquationsSolved];
                _numberOfEquationsRemaining--;
                _remainingAmountLabel.text = [NSString stringWithFormat:@"%i", _numberOfEquationsRemaining];
                
                _currentScoreForLevel = _currentScoreForLevel + 25;
                _scoreLabel.text = [NSString stringWithFormat:@"%i", _currentScoreForLevel];
                
                _currentCorrectStreak++;
                
                if (_currentCorrectStreak % 5 == 0) {
                    int nu = [[[NSUserDefaults standardUserDefaults] valueForKey:@"stars_earned"] intValue];
                    nu++;
                    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%i", nu] forKey:@"stars_earned"];
                    self.numStarsLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"stars_earned"];
                }
                
                [self selectedAnswer:button];
                [_answerTimer invalidate];
            }else {
                _numberEquationsIncorrect++;
                _numberOfEquationsRemaining++;
                _currentScoreForLevel = _currentScoreForLevel - 50;
                _scoreLabel.text = [NSString stringWithFormat:@"%i", _currentScoreForLevel];
                _remainingAmountLabel.text = [NSString stringWithFormat:@"%i", _numberOfEquationsRemaining];
                _incorrectAmountLabel.text = [NSString stringWithFormat:@"%i", _numberEquationsIncorrect];
                
                
                [self selectedWrongAnswer];
                [_answerTimer invalidate];
            }
        }else {
            _numberEquationsIncorrect++;
            _numberOfEquationsRemaining++;
            _currentScoreForLevel = _currentScoreForLevel - 50;
            _scoreLabel.text = [NSString stringWithFormat:@"%i", _currentScoreForLevel];
            _remainingAmountLabel.text = [NSString stringWithFormat:@"%i", _numberOfEquationsRemaining];
            _incorrectAmountLabel.text = [NSString stringWithFormat:@"%i", _numberEquationsIncorrect];
            
            
            [self selectedWrongAnswer];
            [_answerTimer invalidate];
        
        }
    
        
        
    }
    
    
}

- (void)selectedWrongAnswer
{
    _wrongAnswerTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(blowUpAnswerButtons) userInfo:nil repeats:YES];
    _wrongAnswerTimerCount = 0;
}

- (void)blowUpAnswerButtons
{
    _wrongAnswerTimerCount++;
    if (_wrongAnswerTimerCount == 5) {
        NSLog(@"Stopped");
        [_wrongAnswerTimer invalidate];
        [self addRowAndMoveEquationsUp];
        
        float widthHeight = self.playView.bounds.size.width / 5.0;
        float spacing = (self.playView.bounds.size.width - (widthHeight * 4.0)) / 5.0;
        
        _b1.frame = CGRectMake(spacing, 0.0, widthHeight, widthHeight);
//        [self.playView addSubview:_b1];
        
        _b2.frame = CGRectMake(spacing + widthHeight + (spacing), 0.0, widthHeight, widthHeight);
//        [self.playView addSubview:_b2];
        
        _b3.frame = CGRectMake(spacing + widthHeight + (spacing) + widthHeight + (spacing), 0.0, widthHeight, widthHeight);
//        [self.playView addSubview:_b3];
        
        _b4.frame = CGRectMake(spacing + widthHeight + (spacing) + widthHeight + (spacing) + widthHeight + (spacing), 0.0, widthHeight, widthHeight);
//        [self.playView addSubview:_b4];
        
        _startingYPos = 0.00;
        
        [UIView animateWithDuration:1.5 animations:^{
            _b1.alpha = 1.0;
            _b2.alpha = 1.0;
            _b3.alpha = 1.0;
            _b4.alpha = 1.0;
        }completion:^(BOOL finished){
            [_answerTimer invalidate];
            [self startThisSet];
        }];
        
    }else {
        if (_wrongAnswerTimerCount == 1) {
            UIImage *image = [self imageWithButton:_b1];
            UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
            imgView.frame = _b1.frame;
            _b1.alpha = 0.0;
            [self.playView addSubview:imgView];
            [_explosion2Player play];
            [imgView lp_explode];
            
            // move to next row.
            
        }else if (_wrongAnswerTimerCount == 2) {
            UIImage *image = [self imageWithButton:_b2];
            UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
            imgView.frame = _b2.frame;
            _b2.alpha = 0.0;
            [self.playView addSubview:imgView];
            [imgView lp_explode];
            
            // move to next row.

        }else if (_wrongAnswerTimerCount == 3) {
            UIImage *image = [self imageWithButton:_b3];
            UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
            imgView.frame = _b3.frame;
            _b3.alpha = 0.0;
            [self.playView addSubview:imgView];
            [imgView lp_explode];
            
            // move to next row.

        }else if (_wrongAnswerTimerCount == 4) {
            UIImage *image = [self imageWithButton:_b4];
            UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
            imgView.frame = _b4.frame;
            _b4.alpha = 0.0;
            [self.playView addSubview:imgView];
            [imgView lp_explode];
            
            // move to next row.
            
        }
    }
    
    
    
}

- (void)selectedAnswer:(UIButton *)button
{
    if (button == _b1) {
        [UIView animateWithDuration:0.2 animations:^{
            _b2.alpha = 0.0;
            _b3.alpha = 0.0;
            _b4.alpha = 0.0;
        }];
    }else if (button == _b2) {
        [UIView animateWithDuration:0.2 animations:^{
            _b1.alpha = 0.0;
            _b3.alpha = 0.0;
            _b4.alpha = 0.0;
        }];
    }else if (button == _b3) {
        [UIView animateWithDuration:0.2 animations:^{
            _b1.alpha = 0.0;
            _b2.alpha = 0.0;
            _b4.alpha = 0.0;
        }];
    }else if (button == _b4) {
        [UIView animateWithDuration:0.2 animations:^{
            _b1.alpha = 0.0;
            _b3.alpha = 0.0;
            _b2.alpha = 0.0;
        }];
    }
    
    // move button to place
    NSArray *currentEquationLabels = [NSArray arrayWithArray:_allEquationLabelsOnScreen[0]];
    for (int i = 0; i < currentEquationLabels.count; i++) {
        if ([((UILabel *)currentEquationLabels[i]).backgroundColor isEqual:[UIColor clearColor]]) {
            if (i == 0) {
                [UIView animateWithDuration:0.7 animations:^{
                    button.frame = CGRectMake(0.0, _topY + (self.playView.bounds.size.width / 5.0), self.playView.bounds.size.width / 5.0, self.playView.bounds.size.width / 5.0);
                }completion:^(BOOL finished){
                    [self blowUpTopRowandButton:button withCurrentEquationLabels:currentEquationLabels];
                }];
            }else if (i == 1) {
                [UIView animateWithDuration:0.7 animations:^{
                    button.frame = CGRectMake((self.playView.bounds.size.width / 5.0) * 1, _topY + (self.playView.bounds.size.width / 5.0), self.playView.bounds.size.width / 5.0, self.playView.bounds.size.width / 5.0);
                }completion:^(BOOL finished){
                    [self blowUpTopRowandButton:button withCurrentEquationLabels:currentEquationLabels];
                }];
            }else if (i == 2) {
                [UIView animateWithDuration:0.7 animations:^{
                    button.frame = CGRectMake((self.playView.bounds.size.width / 5.0) * 2, _topY + (self.playView.bounds.size.width / 5.0), self.playView.bounds.size.width / 5.0, self.playView.bounds.size.width / 5.0);
                }completion:^(BOOL finished){
                    [self blowUpTopRowandButton:button withCurrentEquationLabels:currentEquationLabels];
                }];
            }else if (i == 3) {
                [UIView animateWithDuration:0.7 animations:^{
                    button.frame = CGRectMake((self.playView.bounds.size.width / 5.0) * 3, _topY + (self.playView.bounds.size.width / 5.0), self.playView.bounds.size.width / 5.0, self.playView.bounds.size.width / 5.0);
                }completion:^(BOOL finished){
                    [self blowUpTopRowandButton:button withCurrentEquationLabels:currentEquationLabels];
                }];
            }else if (i == 4) {
                [UIView animateWithDuration:0.7 animations:^{
                    button.frame = CGRectMake((self.playView.bounds.size.width / 5.0) * 4, _topY + (self.playView.bounds.size.width / 5.0), self.playView.bounds.size.width / 5.0, self.playView.bounds.size.width / 5.0);
                }completion:^(BOOL finished){
                    [self blowUpTopRowandButton:button withCurrentEquationLabels:currentEquationLabels];
                }];
            }
        }
    }
    
}

- (void)blowUpTopRowandButton:(UIButton *)button withCurrentEquationLabels:(NSArray *)currentEquationLabels
{
    for (int i = 0; i < currentEquationLabels.count; i++) {
        UILabel *label = (UILabel *)currentEquationLabels[i];
        UIImage *image = [self imageWithLabel:(UILabel *)currentEquationLabels[i]];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
        imgView.frame = label.frame;
        [label removeFromSuperview];
        label = nil;
        [self.playView addSubview:imgView];
        [imgView lp_explode];
    }
    UIImage *image = [self imageWithButton:button];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    imgView.frame = button.frame;
    button.alpha = 0.0;
    [self.playView addSubview:imgView];
    
    [_explosion1Player play];
    
    [imgView lp_explode];
    
    // move to next row.
    [self checkIfEndOfGame];
}



- (UIImage *) imageWithLabel:(UILabel *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

- (UIImage *) imageWithButton:(UIButton *)button
{
    UIGraphicsBeginImageContextWithOptions(button.bounds.size, button.opaque, 0.0);
    [button.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

- (void)checkIfEndOfGame
{
    if (!_timerOn) {
        if (_allEquationsCurrentlyLoaded.count - 1 == 0) {
            [self performSelector:@selector(loadNextLevel) withObject:nil afterDelay:2.0];
        }else {
            [self keepPlaying];
        }
    }else {
        [self keepPlaying];
    }
    
    
//    if (_allEquationsCurrentlyLoaded.count - 1 == 0) {
//        
//        if (_timerOn) {
//            [self.navigationController setNavigationBarHidden:YES animated:YES];
    
//        }else{
//            // going to reload everything, but for the next level.
//            [self performSelector:@selector(loadNextLevel) withObject:nil afterDelay:2.0];
////            [self loadNextLevel];
//        }
//        
//    }else {
//        [self keepPlaying];
//    }
}

- (void)keepPlaying
{
    // remove the equation
    // remove the label
    
    [_allEquationsCurrentlyLoaded removeObjectAtIndex:_allEquationsCurrentlyLoaded.count - 1];
    [_allEquationLabelsOnScreen removeObjectAtIndex:0];
    
    
//    _objectSolved = [_equationsCurrentlyDisplayed objectAtIndex:_equationsCurrentlyDisplayed.count - 1];
//    [_allEquationsOnScreen removeObjectIdenticalTo:_objectSolved];
//    [_equationsCurrentlyDisplayed removeObjectAtIndex:_equationsCurrentlyDisplayed.count - 1];
//    NSMutableArray *array = [NSMutableArray arrayWithArray:_allEquationLabelsOnScreen];
//    [array removeObjectAtIndex:_allEquationLabelsOnScreen.count - 1];
//    _allEquationLabelsOnScreen = [NSArray arrayWithArray:array];
    
    if (_allEquationLabelsOnScreen.count > 0) {
        [UIView animateWithDuration:0.3 animations:^{
            _bottomNextEquationView.frame = CGRectMake(0.0, self.playView.bounds.size.height - ((self.playView.bounds.size.width / 5.0) * (_allEquationLabelsOnScreen.count - 1.0)), self.playView.bounds.size.width, (self.playView.bounds.size.width / 5.0) * (_allEquationLabelsOnScreen.count - 1.0));
        }];
    }
    
    if (!_timerOn) {
        if (_allEquationLabelsOnScreen.count == 1 && _allEquationsCurrentlyLoaded.count > 1) {
            [self showMoreEquations];
        }
    }else {
        if (_allEquationLabelsOnScreen.count == 1 && _allEquationsCurrentlyLoaded.count == 1) {
            [self showMoreEquationsForTimedGame];
        }
    }
    
    
    
//    _currentEquation = [NSArray arrayWithArray:_equationsCurrentlyDisplayed[_equationsCurrentlyDisplayed.count - 1]];
    
    _topY = _topY + (self.playView.bounds.size.width / 5.0);
    
    NSArray *topMostEquation = [_allEquationsCurrentlyLoaded objectAtIndex:_allEquationsCurrentlyLoaded.count - 1];
    GameObject *object = nil;
    for (GameObject *gO in topMostEquation) {
        NSLog(@"%@", gO.blockTitle);
        if (gO.isAnswer) {
            object = gO;
        }
    }
    
    [self newSetOfAnswers:[[GameLogic functions] generatePossibleAnswersForLevel:_levelSelected andAnswer:object]];
    
    float widthHeight = self.playView.bounds.size.width / 5.0;
    float spacing = (self.playView.bounds.size.width - (widthHeight * 4.0)) / 5.0;
    
    _b1.frame = CGRectMake(spacing, 0.0, widthHeight, widthHeight);
    [self.playView addSubview:_b1];
    
    _b2.frame = CGRectMake(spacing + widthHeight + (spacing), 0.0, widthHeight, widthHeight);
    [self.playView addSubview:_b2];
    
    _b3.frame = CGRectMake(spacing + widthHeight + (spacing) + widthHeight + (spacing), 0.0, widthHeight, widthHeight);
    [self.playView addSubview:_b3];
    
    _b4.frame = CGRectMake(spacing + widthHeight + (spacing) + widthHeight + (spacing) + widthHeight + (spacing), 0.0, widthHeight, widthHeight);
    
    
    _b1.alpha = 1.0;
    _b2.alpha = 1.0;
    _b3.alpha = 1.0;
    _b4.alpha = 1.0;
    
    [self startThisSet];
}

- (void)loadNextLevel
{
    _allEquationsCurrentlyLoaded = [NSMutableArray new];
    _allEquationLabelsOnScreen = [NSMutableArray new];
    [[ManageScores scoreManager] completedLevel:_levelSelected forTime:_timerAmount withScore:[NSString stringWithFormat:@"%i", _currentScoreForLevel] ofGameType:_gameType];
    int curLevel = _levelSelected.intValue;
    if (curLevel < 30) {
        curLevel++;
        _levelSelected = [NSString stringWithFormat:@"%i", curLevel];
        [self createObjects];
        [self setupGame];
        _countDownCover.alpha = 0.0;
        [UIView animateWithDuration:0.5 animations:^{
            _countDownCover.alpha = 1.0;
            _levelLabel.alpha = 1.0;
        }completion:^(BOOL finished){
            [self performSelector:@selector(actualLoadOfNextLevel) withObject:nil afterDelay:1.0];
        }];
    }
    
    
    
    
    
    //  set new level, display level overlay, call create objects, setup game, setup answers
}

- (void)actualLoadOfNextLevel
{
    
    [self setupAnswers];
    [UIView animateWithDuration:1.5 animations:^{
        _countDownCover.alpha = 0.0;
        _countDownLabel.alpha = 0.0;
        _levelLabel.alpha = 0.0;
        
        _b1.alpha = 1.0;
        _b2.alpha = 1.0;
        _b3.alpha = 1.0;
        _b4.alpha = 1.0;
        
    }completion:^(BOOL finished){
        [self startThisSet];
    }];
}

- (IBAction)pauseGameShowMenu:(id)sender
{
    [_answerTimer invalidate];
    if (_timerOn) {
        [_theGameTimer invalidate];
    }
    
    
    _PGView.alpha = 1.0;

    [UIView animateWithDuration:0.3 animations:^{
        _mainCoverView.alpha = 1.0;
    }];

}

#pragma mark - PG Methods (Game Paused)

- (void)PGMENU
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)PGRESUME
{
    [UIView animateWithDuration:0.3 animations:^{
        _mainCoverView.alpha = 0.0;
    }completion:^(BOOL finished){
        // start timer if timer on
        // start answers moving again.
        if (_timerOn) {
            _theGameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(isTimerUp) userInfo:nil repeats:YES];
        }
        [self startThisSet];
        
    }];
}

- (void)PGPOWERUPS
{
    NSLog(@"POWERUPS!!!");
    [self presentViewController:[GetPowerupsVC new] animated:YES completion:nil];
}

#pragma mark - GC Methods (Game Completed)

- (void)GCGETPOWERUPS
{
    NSLog(@"POWERUPS!!!");
    [self presentViewController:[GetPowerupsVC new] animated:YES completion:nil];
}

- (void)GCMAINMENU
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)GCPLAYAGAIN
{
    _currentScoreForLevel = 0;
    _numberEquationsIncorrect = 0;
    _numberEquationsSolved = 0;
    _scoreLabel.text = @"0";
    _solvedAmountLabel.text = @"0";
    _incorrectAmountLabel.text = @"0";
    
    [UIView animateWithDuration:0.5 animations:^{
        _mainCoverView.alpha = 0.0;
        _gcView.alpha = 0.0;
    }completion:^(BOOL finished){
        [self setupAnswers];
        
        [self startCountDown];
    }];
    
    
}

- (void)GCNEXTLEVEL
{
    _currentLevel = _currentLevel + 1;
    [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:[NSString stringWithFormat:@"%@level%ilocked", _gameType, _currentLevel]];
    
    int curTime = _timerAmount.intValue;
    curTime = curTime * 60;
    int num = curTime / 4;
    
    NSString *last_num = [[NSString stringWithFormat:@"%i", _currentLevel] substringFromIndex:[[NSString stringWithFormat:@"%i", _currentLevel] length] - 1];
    
    num = num - 3 + last_num.intValue;
    
    _scoreRequiredToPass = num * 25;
    
    _scoreRequiredLabel.text = [NSString stringWithFormat:@"To Pass: %i", _scoreRequiredToPass];
    
    [UIView animateWithDuration:0.5 animations:^{
        _mainCoverView.alpha = 0.0;
        _gcView.alpha = 0.0;
    }completion:^(BOOL finished){
        [self loadNextLevel];
        _timeRemaining = _timerAmount.intValue * 60;
        _theGameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(isTimerUp) userInfo:nil repeats:YES];
    }];
}

- (IBAction)solveItPowerUpAction:(id)sender {
    NSString *countOfPowerups = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_num_equation_solvers"];
    if (countOfPowerups == nil || countOfPowerups.intValue == 0) {
        [self pauseGameShowMenu:nil];
        [self presentViewController:[GetPowerupsVC new] animated:YES completion:nil];
    }else {

        int equationAnswer = 0;
        for (GameObject *object in _allEquationsCurrentlyLoaded[_allEquationsCurrentlyLoaded.count - 1]) {
            if (object.isAnswer) {
                equationAnswer = object.blockTitle.intValue;
            }
        }
        if (_b1.titleLabel.text.intValue == equationAnswer) {
            [self selectedAnswer:_b1];
        }else if (_b2.titleLabel.text.intValue == equationAnswer) {
            [self selectedAnswer:_b2];
        }else if (_b3.titleLabel.text.intValue == equationAnswer) {
            [self selectedAnswer:_b3];
        }else if (_b4.titleLabel.text.intValue == equationAnswer) {
            [self selectedAnswer:_b4];
        }
        
        _numberEquationsSolved++;
        _solvedAmountLabel.text = [NSString stringWithFormat:@"%i", _numberEquationsSolved];
        _numberOfEquationsRemaining--;
        _remainingAmountLabel.text = [NSString stringWithFormat:@"%i", _numberOfEquationsRemaining];

        int cPU = countOfPowerups.intValue;
        cPU--;
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%i", cPU] forKey:@"user_num_equation_solvers"];
        _countOfSolveItPowerups.text = [NSString stringWithFormat:@"(%i)", cPU];
        [_answerTimer invalidate];
    }
}

- (IBAction)thirtySecondPowerUpAction:(id)sender {
    NSString *countOfPowerups = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_num_thirty_second_boosters"];
    if (countOfPowerups == nil || countOfPowerups.intValue == 0) {
        [self pauseGameShowMenu:nil];
        [self presentViewController:[GetPowerupsVC new] animated:YES completion:nil];
    }else {
        _timeRemaining = _timeRemaining + 30;
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%i", countOfPowerups.intValue - 1] forKey:@"user_num_thirty_second_boosters"];
        _countOfThirtySecondPowerups.text = [NSString stringWithFormat:@"(%i)", countOfPowerups.intValue - 1];
    }
}

@end
