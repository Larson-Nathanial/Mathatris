//
//  ChooseLevelScreenVC.m
//  MathGame
//
//  Created by Nathan Larson on 10/15/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import "ChooseLevelScreenVC.h"
#import "ReviewGameScreenVC.h"
#import "GetPowerupsVC.h"

#import <StoreKit/StoreKit.h>
#import "IAP.h"

@interface ChooseLevelScreenVC ()<IAPHelperDelegate>
@property (nonatomic) NSArray *lockImageViews;
@property (nonatomic) NSArray *iapProducts;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIView *coverView;
@property (nonatomic) int levelUnlocking;
@property (nonatomic) UIColor *colorUnlocking;
@end

@implementation ChooseLevelScreenVC
- (IBAction)chooseGameButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidLoad
{
    [IAP sharedInstance].delegate = self;
    [[IAP sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            _iapProducts = products;
            NSLog(@"%@", _iapProducts);
        }
    }];
    _levelUnlocking = 0;
}

- (IBAction)level1ButtonAction:(id)sender {
    ReviewGameScreenVC *viewController = [ReviewGameScreenVC new];
    viewController.levelSelected = @"1";
    viewController.gameType = _gameType;
    viewController.gameTypeColor = _gameTypeColor;
    viewController.levelColor = ((UIButton *)sender).backgroundColor;
    [self.navigationController pushViewController:viewController animated:YES];
}

// Increase by 7 stars for each level.

- (IBAction)level2ButtonAction:(id)sender {
    
    NSString *key = [NSString stringWithFormat:@"%@level2locked", _gameType];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:key] == nil) {
        
        _levelUnlocking = 2;
        _colorUnlocking = ((UIButton *)sender).backgroundColor;
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"stars_earned"] intValue] >= 7) {
            [self confirmUnlockWithStars];
        }else {
            [self askToBuyMoreStarsToUnlock];
        }

    }else {
        ReviewGameScreenVC *viewController = [ReviewGameScreenVC new];
        viewController.levelSelected = @"2";
        viewController.gameType = _gameType;
        viewController.gameTypeColor = _gameTypeColor;
        viewController.levelColor = ((UIButton *)sender).backgroundColor;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (IBAction)level3ButtonAction:(id)sender {
    
    NSString *key = [NSString stringWithFormat:@"%@level3locked", _gameType];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:key] == nil) {
        
        _levelUnlocking = 3;
        _colorUnlocking = ((UIButton *)sender).backgroundColor;
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"stars_earned"] intValue] >= 14) {
            [self confirmUnlockWithStars];
        }else {
            [self askToBuyMoreStarsToUnlock];
        }
        
    }else {
        ReviewGameScreenVC *viewController = [ReviewGameScreenVC new];
        viewController.levelSelected = @"3";
        viewController.gameType = _gameType;
        viewController.gameTypeColor = _gameTypeColor;
        viewController.levelColor = ((UIButton *)sender).backgroundColor;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    
}

- (IBAction)level4ButtonAction:(id)sender {
    
    NSString *key = [NSString stringWithFormat:@"%@level4locked", _gameType];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:key] == nil) {
        
        _levelUnlocking = 4;
        _colorUnlocking = ((UIButton *)sender).backgroundColor;
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"stars_earned"] intValue] >= 21) {
            [self confirmUnlockWithStars];
        }else {
            [self askToBuyMoreStarsToUnlock];
        }
        
    }else {
        ReviewGameScreenVC *viewController = [ReviewGameScreenVC new];
        viewController.levelSelected = @"4";
        viewController.gameType = _gameType;
        viewController.gameTypeColor = _gameTypeColor;
        viewController.levelColor = ((UIButton *)sender).backgroundColor;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    
}

- (IBAction)level5ButtonAction:(id)sender {
    
    NSString *key = [NSString stringWithFormat:@"%@level5locked", _gameType];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:key] == nil) {
        
        _levelUnlocking = 5;
        _colorUnlocking = ((UIButton *)sender).backgroundColor;
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"stars_earned"] intValue] >= 28) {
            [self confirmUnlockWithStars];
        }else {
            [self askToBuyMoreStarsToUnlock];
        }
        
    }else {
        ReviewGameScreenVC *viewController = [ReviewGameScreenVC new];
        viewController.levelSelected = @"5";
        viewController.gameType = _gameType;
        viewController.gameTypeColor = _gameTypeColor;
        viewController.levelColor = ((UIButton *)sender).backgroundColor;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    
}

- (IBAction)level6ButtonAction:(id)sender {
    
    NSString *key = [NSString stringWithFormat:@"%@level6locked", _gameType];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:key] == nil) {
        
        _levelUnlocking = 6;
        _colorUnlocking = ((UIButton *)sender).backgroundColor;
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"stars_earned"] intValue] >= 35) {
            [self confirmUnlockWithStars];
        }else {
            [self askToBuyMoreStarsToUnlock];
        }
        
    }else {
        ReviewGameScreenVC *viewController = [ReviewGameScreenVC new];
        viewController.levelSelected = @"6";
        viewController.gameType = _gameType;
        viewController.gameTypeColor = _gameTypeColor;
        viewController.levelColor = ((UIButton *)sender).backgroundColor;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    
}

- (IBAction)level7ButtonAction:(id)sender {
    
    NSString *key = [NSString stringWithFormat:@"%@level7locked", _gameType];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:key] == nil) {
        
        _levelUnlocking = 7;
        _colorUnlocking = ((UIButton *)sender).backgroundColor;
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"stars_earned"] intValue] >= 42) {
            [self confirmUnlockWithStars];
        }else {
            [self askToBuyMoreStarsToUnlock];
        }
        
    }else {
        ReviewGameScreenVC *viewController = [ReviewGameScreenVC new];
        viewController.levelSelected = @"7";
        viewController.gameType = _gameType;
        viewController.gameTypeColor = _gameTypeColor;
        viewController.levelColor = ((UIButton *)sender).backgroundColor;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    
}

- (IBAction)level8ButtonAction:(id)sender {
    
    NSString *key = [NSString stringWithFormat:@"%@level8locked", _gameType];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:key] == nil) {
        
        _levelUnlocking = 8;
        _colorUnlocking = ((UIButton *)sender).backgroundColor;
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"stars_earned"] intValue] >= 49) {
            [self confirmUnlockWithStars];
        }else {
            [self askToBuyMoreStarsToUnlock];
        }
        
    }else {
        ReviewGameScreenVC *viewController = [ReviewGameScreenVC new];
        viewController.levelSelected = @"8";
        viewController.gameType = _gameType;
        viewController.gameTypeColor = _gameTypeColor;
        viewController.levelColor = ((UIButton *)sender).backgroundColor;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    
}

- (IBAction)level9ButtonAction:(id)sender {
    
    NSString *key = [NSString stringWithFormat:@"%@level9locked", _gameType];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:key] == nil) {
        
        _levelUnlocking = 9;
        _colorUnlocking = ((UIButton *)sender).backgroundColor;
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"stars_earned"] intValue] >= 56) {
            [self confirmUnlockWithStars];
        }else {
            [self askToBuyMoreStarsToUnlock];
        }
        
    }else {
        ReviewGameScreenVC *viewController = [ReviewGameScreenVC new];
        viewController.levelSelected = @"9";
        viewController.gameType = _gameType;
        viewController.gameTypeColor = _gameTypeColor;
        viewController.levelColor = ((UIButton *)sender).backgroundColor;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    
}

- (IBAction)level10ButtonAction:(id)sender {
    
    NSString *key = [NSString stringWithFormat:@"%@level10locked", _gameType];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:key] == nil) {
        
        _levelUnlocking = 10;
        _colorUnlocking = ((UIButton *)sender).backgroundColor;
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"stars_earned"] intValue] >= 63) {
            [self confirmUnlockWithStars];
        }else {
            [self askToBuyMoreStarsToUnlock];
        }
        
    }else {
        ReviewGameScreenVC *viewController = [ReviewGameScreenVC new];
        viewController.levelSelected = @"10";
        viewController.gameType = _gameType;
        viewController.gameTypeColor = _gameTypeColor;
        viewController.levelColor = ((UIButton *)sender).backgroundColor;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    
}

- (IBAction)level11ButtonAction:(id)sender {
    
    NSString *key = [NSString stringWithFormat:@"%@level11locked", _gameType];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:key] == nil) {
        
        _levelUnlocking = 11;
        _colorUnlocking = ((UIButton *)sender).backgroundColor;
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"stars_earned"] intValue] >= 70) {
            [self confirmUnlockWithStars];
        }else {
            [self askToBuyMoreStarsToUnlock];
        }
        
    }else {
        ReviewGameScreenVC *viewController = [ReviewGameScreenVC new];
        viewController.levelSelected = @"11";
        viewController.gameType = _gameType;
        viewController.gameTypeColor = _gameTypeColor;
        viewController.levelColor = ((UIButton *)sender).backgroundColor;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    
}

- (IBAction)level12ButtonAction:(id)sender {
    
    NSString *key = [NSString stringWithFormat:@"%@level12locked", _gameType];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:key] == nil) {
        
        _levelUnlocking = 12;
        _colorUnlocking = ((UIButton *)sender).backgroundColor;
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"stars_earned"] intValue] >= 77) {
            [self confirmUnlockWithStars];
        }else {
            [self askToBuyMoreStarsToUnlock];
        }
        
    }else {
        ReviewGameScreenVC *viewController = [ReviewGameScreenVC new];
        viewController.levelSelected = @"12";
        viewController.gameType = _gameType;
        viewController.gameTypeColor = _gameTypeColor;
        viewController.levelColor = ((UIButton *)sender).backgroundColor;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    
}

- (IBAction)level13ButtonAction:(id)sender {
    
    NSString *key = [NSString stringWithFormat:@"%@level13locked", _gameType];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:key] == nil) {

        _levelUnlocking = 13;
        _colorUnlocking = ((UIButton *)sender).backgroundColor;
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"stars_earned"] intValue] >= 84) {
            [self confirmUnlockWithStars];
        }else {
            [self askToBuyMoreStarsToUnlock];
        }
        
    }else {
        ReviewGameScreenVC *viewController = [ReviewGameScreenVC new];
        viewController.levelSelected = @"13";
        viewController.gameType = _gameType;
        viewController.gameTypeColor = _gameTypeColor;
        viewController.levelColor = ((UIButton *)sender).backgroundColor;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    
}

- (IBAction)level14ButtonAction:(id)sender {
    
    NSString *key = [NSString stringWithFormat:@"%@level14locked", _gameType];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:key] == nil) {
        
        _levelUnlocking = 14;
        _colorUnlocking = ((UIButton *)sender).backgroundColor;
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"stars_earned"] intValue] >= 91) {
            [self confirmUnlockWithStars];
        }else {
            [self askToBuyMoreStarsToUnlock];
        }
        
    }else {
        ReviewGameScreenVC *viewController = [ReviewGameScreenVC new];
        viewController.levelSelected = @"14";
        viewController.gameType = _gameType;
        viewController.gameTypeColor = _gameTypeColor;
        viewController.levelColor = ((UIButton *)sender).backgroundColor;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    
}

- (IBAction)level15ButtonAction:(id)sender {
    
    NSString *key = [NSString stringWithFormat:@"%@level15locked", _gameType];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:key] == nil) {
        
        _levelUnlocking = 15;
        _colorUnlocking = ((UIButton *)sender).backgroundColor;
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"stars_earned"] intValue] >= 98) {
            [self confirmUnlockWithStars];
        }else {
            [self askToBuyMoreStarsToUnlock];
        }
        
    }else {
        ReviewGameScreenVC *viewController = [ReviewGameScreenVC new];
        viewController.levelSelected = @"15";
        viewController.gameType = _gameType;
        viewController.gameTypeColor = _gameTypeColor;
        viewController.levelColor = ((UIButton *)sender).backgroundColor;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    
}

- (IBAction)level16ButtonAction:(id)sender {
    
    NSString *key = [NSString stringWithFormat:@"%@level16locked", _gameType];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:key] == nil) {
        
        _levelUnlocking = 16;
        _colorUnlocking = ((UIButton *)sender).backgroundColor;
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"stars_earned"] intValue] >= 105) {
            [self confirmUnlockWithStars];
        }else {
            [self askToBuyMoreStarsToUnlock];
        }
        
    }else {
        ReviewGameScreenVC *viewController = [ReviewGameScreenVC new];
        viewController.levelSelected = @"16";
        viewController.gameType = _gameType;
        viewController.gameTypeColor = _gameTypeColor;
        viewController.levelColor = ((UIButton *)sender).backgroundColor;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    
}

- (IBAction)level17ButtonAction:(id)sender {
    
    NSString *key = [NSString stringWithFormat:@"%@level17locked", _gameType];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:key] == nil) {
        
        _levelUnlocking = 17;
        _colorUnlocking = ((UIButton *)sender).backgroundColor;
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"stars_earned"] intValue] >= 112) {
            [self confirmUnlockWithStars];
        }else {
            [self askToBuyMoreStarsToUnlock];
        }
        
    }else {
        ReviewGameScreenVC *viewController = [ReviewGameScreenVC new];
        viewController.levelSelected = @"17";
        viewController.gameType = _gameType;
        viewController.gameTypeColor = _gameTypeColor;
        viewController.levelColor = ((UIButton *)sender).backgroundColor;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    
}

- (IBAction)level18ButtonAction:(id)sender {
    
    NSString *key = [NSString stringWithFormat:@"%@level18locked", _gameType];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:key] == nil) {
        
        _levelUnlocking = 18;
        _colorUnlocking = ((UIButton *)sender).backgroundColor;
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"stars_earned"] intValue] >= 119) {
            [self confirmUnlockWithStars];
        }else {
            [self askToBuyMoreStarsToUnlock];
        }
        
    }else {
        ReviewGameScreenVC *viewController = [ReviewGameScreenVC new];
        viewController.levelSelected = @"18";
        viewController.gameType = _gameType;
        viewController.gameTypeColor = _gameTypeColor;
        viewController.levelColor = ((UIButton *)sender).backgroundColor;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    
}

- (IBAction)level19ButtonAction:(id)sender {
    
    NSString *key = [NSString stringWithFormat:@"%@level19locked", _gameType];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:key] == nil) {

        _levelUnlocking = 19;
        _colorUnlocking = ((UIButton *)sender).backgroundColor;
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"stars_earned"] intValue] >= 126) {
            [self confirmUnlockWithStars];
        }else {
            [self askToBuyMoreStarsToUnlock];
        }
        
    }else {
        ReviewGameScreenVC *viewController = [ReviewGameScreenVC new];
        viewController.levelSelected = @"19";
        viewController.gameType = _gameType;
        viewController.gameTypeColor = _gameTypeColor;
        viewController.levelColor = ((UIButton *)sender).backgroundColor;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    
}

- (IBAction)level20ButtonAction:(id)sender {
    
    NSString *key = [NSString stringWithFormat:@"%@level20locked", _gameType];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:key] == nil) {

        _levelUnlocking = 20;
        _colorUnlocking = ((UIButton *)sender).backgroundColor;
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"stars_earned"] intValue] >= 133) {
            [self confirmUnlockWithStars];
        }else {
            [self askToBuyMoreStarsToUnlock];
        }

    }else {
        ReviewGameScreenVC *viewController = [ReviewGameScreenVC new];
        viewController.levelSelected = @"20";
        viewController.gameType = _gameType;
        viewController.gameTypeColor = _gameTypeColor;
        viewController.levelColor = ((UIButton *)sender).backgroundColor;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    
}

- (IBAction)level21ButtonAction:(id)sender {
    
    NSString *key = [NSString stringWithFormat:@"%@level21locked", _gameType];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:key] == nil) {

        _levelUnlocking = 21;
        _colorUnlocking = ((UIButton *)sender).backgroundColor;
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"stars_earned"] intValue] >= 140) {
            [self confirmUnlockWithStars];
        }else {
            [self askToBuyMoreStarsToUnlock];
        }

    }else {
        ReviewGameScreenVC *viewController = [ReviewGameScreenVC new];
        viewController.levelSelected = @"21";
        viewController.gameType = _gameType;
        viewController.gameTypeColor = _gameTypeColor;
        viewController.levelColor = ((UIButton *)sender).backgroundColor;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    
}

- (IBAction)level22ButtonAction:(id)sender {
    
    NSString *key = [NSString stringWithFormat:@"%@level22locked", _gameType];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:key] == nil) {

        _levelUnlocking = 22;
        _colorUnlocking = ((UIButton *)sender).backgroundColor;
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"stars_earned"] intValue] >= 147) {
            [self confirmUnlockWithStars];
        }else {
            [self askToBuyMoreStarsToUnlock];
        }

    }else {
        ReviewGameScreenVC *viewController = [ReviewGameScreenVC new];
        viewController.levelSelected = @"22";
        viewController.gameType = _gameType;
        viewController.gameTypeColor = _gameTypeColor;
        viewController.levelColor = ((UIButton *)sender).backgroundColor;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    
}

- (IBAction)level23ButtonAction:(id)sender {
    
    NSString *key = [NSString stringWithFormat:@"%@level23locked", _gameType];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:key] == nil) {

        _levelUnlocking = 23;
        _colorUnlocking = ((UIButton *)sender).backgroundColor;
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"stars_earned"] intValue] >= 154) {
            [self confirmUnlockWithStars];
        }else {
            [self askToBuyMoreStarsToUnlock];
        }

    }else {
        ReviewGameScreenVC *viewController = [ReviewGameScreenVC new];
        viewController.levelSelected = @"23";
        viewController.gameType = _gameType;
        viewController.gameTypeColor = _gameTypeColor;
        viewController.levelColor = ((UIButton *)sender).backgroundColor;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    
}

- (IBAction)level24ButtonAction:(id)sender {
    
    NSString *key = [NSString stringWithFormat:@"%@level24locked", _gameType];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:key] == nil) {

        _levelUnlocking = 24;
        _colorUnlocking = ((UIButton *)sender).backgroundColor;
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"stars_earned"] intValue] >= 161) {
            [self confirmUnlockWithStars];
        }else {
            [self askToBuyMoreStarsToUnlock];
        }

    }else {
        ReviewGameScreenVC *viewController = [ReviewGameScreenVC new];
        viewController.levelSelected = @"24";
        viewController.gameType = _gameType;
        viewController.gameTypeColor = _gameTypeColor;
        viewController.levelColor = ((UIButton *)sender).backgroundColor;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    
}

- (IBAction)level25ButtonAction:(id)sender {
    
    NSString *key = [NSString stringWithFormat:@"%@level25locked", _gameType];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:key] == nil) {

        _levelUnlocking = 25;
        _colorUnlocking = ((UIButton *)sender).backgroundColor;
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"stars_earned"] intValue] >= 168) {
            [self confirmUnlockWithStars];
        }else {
            [self askToBuyMoreStarsToUnlock];
        }

    }else {
        ReviewGameScreenVC *viewController = [ReviewGameScreenVC new];
        viewController.levelSelected = @"25";
        viewController.gameType = _gameType;
        viewController.gameTypeColor = _gameTypeColor;
        viewController.levelColor = ((UIButton *)sender).backgroundColor;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    
}

- (IBAction)level26ButonAction:(id)sender {
    
    NSString *key = [NSString stringWithFormat:@"%@level26locked", _gameType];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:key] == nil) {

        _levelUnlocking = 26;
        _colorUnlocking = ((UIButton *)sender).backgroundColor;
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"stars_earned"] intValue] >= 175) {
            [self confirmUnlockWithStars];
        }else {
            [self askToBuyMoreStarsToUnlock];
        }

    }else {
        ReviewGameScreenVC *viewController = [ReviewGameScreenVC new];
        viewController.levelSelected = @"26";
        viewController.gameType = _gameType;
        viewController.gameTypeColor = _gameTypeColor;
        viewController.levelColor = ((UIButton *)sender).backgroundColor;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    
}

- (IBAction)level27ButtonAction:(id)sender {
    
    NSString *key = [NSString stringWithFormat:@"%@level27locked", _gameType];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:key] == nil) {
        
        _levelUnlocking = 27;
        _colorUnlocking = ((UIButton *)sender).backgroundColor;
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"stars_earned"] intValue] >= 182) {
            [self confirmUnlockWithStars];
        }else {
            [self askToBuyMoreStarsToUnlock];
        }

    }else {
        ReviewGameScreenVC *viewController = [ReviewGameScreenVC new];
        viewController.levelSelected = @"27";
        viewController.gameType = _gameType;
        viewController.gameTypeColor = _gameTypeColor;
        viewController.levelColor = ((UIButton *)sender).backgroundColor;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    
}

- (IBAction)level28ButtonAction:(id)sender {
    
    NSString *key = [NSString stringWithFormat:@"%@level28locked", _gameType];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:key] == nil) {

        _levelUnlocking = 28;
        _colorUnlocking = ((UIButton *)sender).backgroundColor;
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"stars_earned"] intValue] >= 189) {
            [self confirmUnlockWithStars];
        }else {
            [self askToBuyMoreStarsToUnlock];
        }

    }else {
        ReviewGameScreenVC *viewController = [ReviewGameScreenVC new];
        viewController.levelSelected = @"28";
        viewController.gameType = _gameType;
        viewController.gameTypeColor = _gameTypeColor;
        viewController.levelColor = ((UIButton *)sender).backgroundColor;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    
}

- (IBAction)level29ButtonAction:(id)sender {
    
    NSString *key = [NSString stringWithFormat:@"%@level29locked", _gameType];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:key] == nil) {

        _levelUnlocking = 29;
        _colorUnlocking = ((UIButton *)sender).backgroundColor;
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"stars_earned"] intValue] >= 196) {
            [self confirmUnlockWithStars];
        }else {
            [self askToBuyMoreStarsToUnlock];
        }

    }else {
        ReviewGameScreenVC *viewController = [ReviewGameScreenVC new];
        viewController.levelSelected = @"29";
        viewController.gameType = _gameType;
        viewController.gameTypeColor = _gameTypeColor;
        viewController.levelColor = ((UIButton *)sender).backgroundColor;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    
}

- (IBAction)level30ButtonAction:(id)sender {
    
    NSString *key = [NSString stringWithFormat:@"%@level30locked", _gameType];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:key] == nil) {

        _levelUnlocking = 30;
        _colorUnlocking = ((UIButton *)sender).backgroundColor;
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"stars_earned"] intValue] >= 203) {
            [self confirmUnlockWithStars];
        }else {
            [self askToBuyMoreStarsToUnlock];
        }
        
    }else {
        ReviewGameScreenVC *viewController = [ReviewGameScreenVC new];
        viewController.levelSelected = @"30";
        viewController.gameType = _gameType;
        viewController.gameTypeColor = _gameTypeColor;
        viewController.levelColor = ((UIButton *)sender).backgroundColor;
        [self.navigationController pushViewController:viewController animated:YES];
    }

    
}

- (void)confirmUnlockWithStars
{
    
    int number = _levelUnlocking * 7;
    number = number - 7;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Unlock Level" message:[NSString stringWithFormat:@"Use %i stars to unlock level?", number] preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        // Unlock the level. Push the view controller.
        NSString *key = [NSString stringWithFormat:@"%@level%ilocked", _gameType, _levelUnlocking];
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:key];
        
        ReviewGameScreenVC *viewController = [ReviewGameScreenVC new];
        viewController.levelSelected = [NSString stringWithFormat:@"%i", _levelUnlocking];
        viewController.gameType = _gameType;
        viewController.gameTypeColor = _gameTypeColor;
        viewController.levelColor = _colorUnlocking;
        [self.navigationController pushViewController:viewController animated:YES];
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)askToBuyMoreStarsToUnlock
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Need more stars!" message:@"You don't have enough stars to unlock this level. Would you like to purchase more?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self presentViewController:[GetPowerupsVC new] animated:YES completion:nil];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)checkLocks
{
    _lockImageViews = @[_level2LockImage
                        , _level3LockImage
                        , _level4LockImage
                        , _level5LockImage
                        , _level6LockImage
                        , _level7LockImage
                        , _level8LockImage
                        , _level9LockImage
                        , _level10LockImage
                        , _level11LockImage
                        , _level12LockImage
                        , _level13LockImage
                        , _level14LockImage
                        , _level15LockImage
                        , _level16LockImage
                        , _level17LockImage
                        , _level18LockImage
                        , _level19LockImage
                        , _level20LockImage
                        , _level21LockImage
                        , _level22LockImage
                        , _level23LockImage
                        , _level24LockImage
                        , _level25LockImage
                        , _level26LockImage
                        , _level27LockImage
                        , _level28LockImage
                        , _level29LockImage
                        , _level30LockImage];
    
    for (int i = 2; i <= 30; i++) {
        NSString *key = [NSString stringWithFormat:@"%@level%ilocked", _gameType, i];
        if ([[NSUserDefaults standardUserDefaults] valueForKey:key] == nil) {
            ((UIImageView *)[_lockImageViews objectAtIndex:i - 2]).image = [UIImage imageNamed:@"locked"];
        }else {
            ((UIImageView *)[_lockImageViews objectAtIndex:i - 2]).image = [UIImage imageNamed:@"unlocked"];
        }
    }
}



- (void)viewDidAppear:(BOOL)animated
{
    _scrollView.frame = CGRectMake(0.0, _scrollView.frame.origin.y, self.view.bounds.size.width, self.view.bounds.size.height -_scrollView.frame.origin.y);
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 3000.0);
    
    [self checkLocks];
    
    _coverView = [UIView new];
    _coverView.frame = self.view.frame;
    _coverView.backgroundColor = [UIColor colorWithWhite:100.0 / 255.0 alpha:0.8];
    [self.view addSubview:_coverView];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicator.center = self.view.center;
    [_activityIndicator startAnimating];
    [_coverView addSubview:_activityIndicator];
    _coverView.alpha = 0.0;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Choose Level"
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)productPurchased:(NSNotification *)notification {
    
    NSString * productIdentifier = notification.object;
    NSLog(@"%@", productIdentifier);
    
    NSString *key = [NSString stringWithFormat:@"%@level%ilocked", _gameType, _levelUnlocking];
    [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:key];
    
    ReviewGameScreenVC *viewController = [ReviewGameScreenVC new];
    viewController.levelSelected = [NSString stringWithFormat:@"%i", _levelUnlocking];
    viewController.gameType = _gameType;
    viewController.gameTypeColor = _gameTypeColor;
    viewController.levelColor = _colorUnlocking;
    [self.navigationController pushViewController:viewController animated:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 0.0;
    }];
    
}

- (void)didCancelPurchase
{
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 0.0;
    }];
}

@end
