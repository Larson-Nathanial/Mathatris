//
//  PauseGameVC.h
//  MathGame
//
//  Created by Nathan Larson on 10/20/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PauseGameDelegate <NSObject>

@required
- (void)PGMENU;
- (void)PGRESUME;
- (void)PGPOWERUPS;

@end

@interface PauseGameVC : UIView

@property (nonatomic, assign) id<PauseGameDelegate>delegate;

@end
