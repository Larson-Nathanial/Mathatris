//
//  AppDelegate.h
//  MathGame
//
//  Created by Nathan Larson on 10/15/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

/*
 There are two values saved in NSUserDefaults - which may be saved on server later.
 key: user_num_equation_solvers
 key: user_num_thirty_second_boosters
 key: hasBeenLoadedBefore
 key: user_player_name
 
 key: player_scores
 key: ads_are_removed
 key: stars_earned // For IAP. Need stars to unlock levels.
 
 */

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

