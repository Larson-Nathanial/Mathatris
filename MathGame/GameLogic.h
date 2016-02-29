//
//  GameLogic.h
//  MathGame
//
//  Created by Nathan Larson on 10/16/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameObject.h"

@interface GameLogic : NSObject

+ (GameLogic *)functions;

- (NSArray *)equationsBasedOnType:(NSString *)game_type withCombo:(NSArray *)combo level:(NSString *)level timer:(BOOL)timer;
- (NSArray *)loadTwoMoreEquationsForType:(NSString *)game_type withCombo:(NSArray *)combo level:(NSString *)level;
- (NSArray *)loadEquationForType:(NSString *)game_type withCombo:(NSArray *)combo level:(NSString *)level;

- (NSArray *)generatePossibleAnswersForLevel:(NSString *)level andAnswer:(GameObject *)answer;

@end
