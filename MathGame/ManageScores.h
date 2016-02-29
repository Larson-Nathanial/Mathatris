//
//  ManageScores.h
//  MathGame
//
//  Created by Nathan Larson on 10/20/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ManageScores : NSObject

+ (ManageScores *)scoreManager;

- (void)completedLevel:(NSString *)level forTime:(NSString *)time_amount withScore:(NSString *)score ofGameType:(NSString *)game_type;

- (NSArray *)getScores;

- (BOOL)didMarkAppIdAsActive;
- (BOOL)didMarkAppIdAsInActive;

- (BOOL)didCreateNewApp;

@end
