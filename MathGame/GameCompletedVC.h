//
//  GameCompletedVC.h
//  MathGame
//
//  Created by Nathan Larson on 10/17/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GameCompletedDelegate <NSObject>

@required
- (void)GCPLAYAGAIN;
- (void)GCNEXTLEVEL;
- (void)GCMAINMENU;
- (void)GCGETPOWERUPS;

@end

@interface GameCompletedVC : UIView

@property (nonatomic, assign) id<GameCompletedDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *menuTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *goalLabel;
@property (weak, nonatomic) IBOutlet UILabel *actualLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextLevelButton;

@end
