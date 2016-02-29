//
//  PauseGameVC.m
//  MathGame
//
//  Created by Nathan Larson on 10/20/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import "PauseGameVC.h"

@implementation PauseGameVC

- (IBAction)mainMenuButtonAction:(id)sender {
    [self.delegate PGMENU];
}

- (IBAction)resumeGameButtonAction:(id)sender {
    [self.delegate PGRESUME];
}

- (IBAction)getPowerupsButtonAction:(id)sender {
    [self.delegate PGPOWERUPS];
}


@end
