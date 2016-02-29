//
//  ViewController.m
//  MathGame
//
//  Created by Nathan Larson on 10/15/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

/*
 Red: 255 59 48
 Orange: 255 149 0
 Yellow: 255 204 0
 Green: 76 217 100
 Light Blue: 52 170 220
 Blue: 0 122 255
 Purple: 88 86 214
 Pink: 255 45 85
 Dark Grey: 142 142 147
 Light Grey: 199 199 204
 
 */

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@property (nonatomic) NSArray *colors;
@property (nonatomic) int numberOfStartingEquations;
@property (nonatomic) NSMutableArray *onScreenEquations;
@property (nonatomic) NSMutableArray *answers;
@property (nonatomic) int currentRow;

@property (nonatomic) UIButton *b1;
@property (nonatomic) UIButton *b2;
@property (nonatomic) UIButton *b3;
@property (nonatomic) UIButton *b4;

@property (nonatomic) float topY;
@property (nonatomic) float startingYPos;
@property (nonatomic) NSTimer *kTimer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _colors = @[[UIColor redColor], [UIColor greenColor], [UIColor orangeColor], [UIColor purpleColor]];
    _numberOfStartingEquations = 3;
    _onScreenEquations = [NSMutableArray new];
    _answers = [NSMutableArray new];
    
    [self buildStartingEquations];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self buildOnScreenLabels];
    _currentRow = 0;
    
    float widthHeight = self.playView.bounds.size.width / 5.0;
    float spacing = (self.playView.bounds.size.width - (widthHeight * 4.0)) / 5.0;
    
    _b1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _b2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _b3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _b4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    
    
    _b1.frame = CGRectMake(spacing, 0.0, widthHeight, widthHeight);
    _b1.backgroundColor = [UIColor purpleColor];
    [_b1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.playView addSubview:_b1];
    
    _b2.frame = CGRectMake(spacing + widthHeight + (spacing), 0.0, widthHeight, widthHeight);
    _b2.backgroundColor = [UIColor purpleColor];
    [_b2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.playView addSubview:_b2];
    
    _b3.frame = CGRectMake(spacing + widthHeight + (spacing) + widthHeight + (spacing), 0.0, widthHeight, widthHeight);
    _b3.backgroundColor = [UIColor purpleColor];
    [_b3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.playView addSubview:_b3];
    
    _b4.frame = CGRectMake(spacing + widthHeight + (spacing) + widthHeight + (spacing) + widthHeight + (spacing), 0.0, widthHeight, widthHeight);
    _b4.backgroundColor = [UIColor purpleColor];
    [_b4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.playView addSubview:_b4];
    
    [_b1 addTarget:self action:@selector(tappedButtonOne:) forControlEvents:UIControlEventTouchUpInside];
    [_b2 addTarget:self action:@selector(tappedButtonTwo:) forControlEvents:UIControlEventTouchUpInside];
    [_b3 addTarget:self action:@selector(tappedButtonThree:) forControlEvents:UIControlEventTouchUpInside];
    [_b4 addTarget:self action:@selector(tappedButtonFour:) forControlEvents:UIControlEventTouchUpInside];
    
    [self startGame];
}

- (void)tappedButtonOne:(UIButton *)sender
{
    NSString *selc = sender.titleLabel.text;
    if ([selc isEqualToString:_answers[_onScreenEquations.count - _currentRow - 1]]) {
        [self moveButton:sender];
        [_kTimer invalidate];
    }
    NSLog(@"One");
}

- (void)tappedButtonTwo:(UIButton *)sender
{
    NSString *selc = sender.titleLabel.text;
    if ([selc isEqualToString:_answers[_onScreenEquations.count - _currentRow - 1]]) {
        [self moveButton:sender];
        [_kTimer invalidate];
    }
    NSLog(@"Two");
}

- (void)tappedButtonThree:(UIButton *)sender
{
    NSString *selc = sender.titleLabel.text;
    if ([selc isEqualToString:_answers[_onScreenEquations.count - _currentRow - 1]]) {
        [self moveButton:sender];
        [_kTimer invalidate];
    }
    NSLog(@"Three");
}

- (void)tappedButtonFour:(UIButton *)sender
{
    NSString *selc = sender.titleLabel.text;
    if ([selc isEqualToString:_answers[_onScreenEquations.count - _currentRow - 1]]) {
        [self moveButton:sender];
        [_kTimer invalidate];
    }
    NSLog(@"Four");
}

- (void)moveButton:(UIButton *)button
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
    
    
    NSArray *arr1 = _onScreenEquations[_onScreenEquations.count - _currentRow - 1];
    for (int i = 0; i < arr1.count; i++) {
        if ([arr1[i] isEqualToString:@""]) {
            if (i == 0) {
                [UIView animateWithDuration:0.7 animations:^{
                    button.frame = CGRectMake(0.0, _topY + (self.playView.bounds.size.width / 5.0), self.playView.bounds.size.width / 5.0, self.playView.bounds.size.width / 5.0);
                }];
            }else if (i == 1) {
                [UIView animateWithDuration:0.7 animations:^{
                    button.frame = CGRectMake((self.playView.bounds.size.width / 5.0) * 1, _topY + (self.playView.bounds.size.width / 5.0), self.playView.bounds.size.width / 5.0, self.playView.bounds.size.width / 5.0);
                }];
            }else if (i == 2) {
                [UIView animateWithDuration:0.7 animations:^{
                    button.frame = CGRectMake((self.playView.bounds.size.width / 5.0) * 2, _topY + (self.playView.bounds.size.width / 5.0), self.playView.bounds.size.width / 5.0, self.playView.bounds.size.width / 5.0);
                }];
            }else if (i == 3) {
                [UIView animateWithDuration:0.7 animations:^{
                    button.frame = CGRectMake((self.playView.bounds.size.width / 5.0) * 3, _topY + (self.playView.bounds.size.width / 5.0), self.playView.bounds.size.width / 5.0, self.playView.bounds.size.width / 5.0);
                }];
            }else if (i == 4) {
                [UIView animateWithDuration:0.7 animations:^{
                    button.frame = CGRectMake((self.playView.bounds.size.width / 5.0) * 4, _topY + (self.playView.bounds.size.width / 5.0), self.playView.bounds.size.width / 5.0, self.playView.bounds.size.width / 5.0);
                }];
            }
        }
    }
}

- (void)buildStartingEquations
{
    for (int i = 0; i < _numberOfStartingEquations; i++) {
        int first_number = arc4random_uniform(9);
        int second_number= arc4random_uniform(9);
        int answer_number = first_number + second_number;
        NSString *plus = @"+";
        NSString *equals = @"=";
        
        NSString *first = [NSString stringWithFormat:@"%i", first_number];
        NSString *second = [NSString stringWithFormat:@"%i", second_number];
        NSString *answer = [NSString stringWithFormat:@"%i", answer_number];
        
        [_onScreenEquations addObject:@[first, plus, second, equals, answer]];
        
        
    }
    
    for (int i = 0; i < (int)_onScreenEquations.count; i++) {
        int position_to_remove = arc4random_uniform(4);
        
        NSMutableArray *array = [NSMutableArray arrayWithArray:_onScreenEquations[i]];
        NSString *number = [array objectAtIndex:position_to_remove];
        [_answers addObject:number];
        [array replaceObjectAtIndex:position_to_remove withObject:@""];
        _onScreenEquations[i] = [NSArray arrayWithArray:array];
    }
}

- (void)buildOnScreenLabels
{
    float yPos = self.playView.bounds.size.height - (self.playView.bounds.size.width / 5.0);
    float blockHeightWidth = self.playView.bounds.size.width / 5.0;
    
    
    for (int i = 0; i < _numberOfStartingEquations; i++) {
        for (int j = 0; j < 5; j++) {
            
            UIColor *blockColor = _colors[arc4random_uniform(3)];
            
            UILabel *block = [UILabel new];
            
            if ([_onScreenEquations[i][j] isEqualToString:@""]) {
                block.backgroundColor = [UIColor clearColor];
            }else {
                block.backgroundColor = blockColor;
            }
            
            block.font = [UIFont fontWithName:@"AvenirNext-Regular" size:22.0];
            block.textColor = [UIColor whiteColor];
            block.textAlignment = NSTextAlignmentCenter;
            block.text = _onScreenEquations[i][j];
            block.layer.borderColor = [UIColor lightGrayColor].CGColor;
            block.layer.borderWidth = 0.5;
            
            if ([_onScreenEquations[i][j] isEqualToString:@"+"]) {
                if (j == 0) {
                    block.frame = CGRectMake(0.0, yPos, blockHeightWidth, blockHeightWidth);
                }else if (j == 1) {
                    block.frame = CGRectMake((self.playView.bounds.size.width / 5.0) * 1, yPos, blockHeightWidth, blockHeightWidth);
                }
            }else if ([_onScreenEquations[i][j] isEqualToString:@"="]){
                if (j == 2) {
                    block.frame = CGRectMake((self.playView.bounds.size.width / 5.0) * 2, yPos, blockHeightWidth, blockHeightWidth);
                }else if (j == 3) {
                    block.frame = CGRectMake((self.playView.bounds.size.width / 5.0) * 3, yPos, blockHeightWidth, blockHeightWidth);
                }
            }else {
                if (j == 0) {
                    block.frame = CGRectMake((self.playView.bounds.size.width / 5.0) * 0, yPos, blockHeightWidth, blockHeightWidth);
                }else if (j == 1) {
                    block.frame = CGRectMake((self.playView.bounds.size.width / 5.0) * 1, yPos, blockHeightWidth, blockHeightWidth);
                }else if (j == 2) {
                    block.frame = CGRectMake((self.playView.bounds.size.width / 5.0) * 2, yPos, blockHeightWidth, blockHeightWidth);
                }else if (j == 3) {
                    block.frame = CGRectMake((self.playView.bounds.size.width / 5.0) * 3, yPos, blockHeightWidth, blockHeightWidth);
                }else if (j == 4) {
                    block.frame = CGRectMake((self.playView.bounds.size.width / 5.0) * 4, yPos, blockHeightWidth, blockHeightWidth);
                }
            }
            [self.playView addSubview:block];
        }
        yPos = yPos - blockHeightWidth;
    }
    _topY = yPos;
}

- (void)startGame
{
    _startingYPos = 0.0;
    _kTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(moveThem) userInfo:nil repeats:YES];
    [self nextSet];
}

- (void)nextSet
{
    NSMutableArray *falseAnswers = [NSMutableArray new];
    for (int i = 0; i < 3; i++) {
        int falseAnswer = arc4random_uniform(9);
        [falseAnswers addObject:[NSString stringWithFormat:@"%i", falseAnswer]];
    }
    [falseAnswers addObject:_answers[_onScreenEquations.count - _currentRow - 1]];
    
    for (int i = 0; i < 4; i++) {
        if (i == 0) {
            [_b1 setTitle:falseAnswers[i] forState:UIControlStateNormal];
        }else if (i == 1) {
            [_b2 setTitle:falseAnswers[i] forState:UIControlStateNormal];
        }else if (i == 2) {
            [_b3 setTitle:falseAnswers[i] forState:UIControlStateNormal];
        }else if (i == 3) {
            [_b4 setTitle:falseAnswers[i] forState:UIControlStateNormal];
        }
    }
    
    [self moveThem];
}

- (void)moveThem
{
    if (_startingYPos < _topY) {
        
        _b1.frame = CGRectMake(_b1.frame.origin.x, _startingYPos, _b1.frame.size.width, _b1.frame.size.height);
        _b2.frame = CGRectMake(_b2.frame.origin.x, _startingYPos, _b2.frame.size.width, _b2.frame.size.height);
        _b3.frame = CGRectMake(_b3.frame.origin.x, _startingYPos, _b3.frame.size.width, _b3.frame.size.height);
        _b4.frame = CGRectMake(_b4.frame.origin.x, _startingYPos, _b4.frame.size.width, _b4.frame.size.height);
        _startingYPos = _startingYPos + 0.1;
    }else {
        [_kTimer invalidate];
    }
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
