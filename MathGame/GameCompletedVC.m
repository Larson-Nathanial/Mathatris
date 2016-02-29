//
//  GameCompletedVC.m
//  MathGame
//
//  Created by Nathan Larson on 10/17/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import "GameCompletedVC.h"

@implementation GameCompletedVC

- (IBAction)playAgainAction:(id)sender {
    [self.delegate GCPLAYAGAIN];
}

- (IBAction)nextLevelAction:(id)sender {
    [self.delegate GCNEXTLEVEL];
}

- (IBAction)mainMenuAction:(id)sender {
    [self.delegate GCMAINMENU];
}

- (IBAction)getPowerupsAction:(id)sender {
    [self.delegate GCGETPOWERUPS];
}

@end
