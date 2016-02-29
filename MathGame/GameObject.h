//
//  GameObject.h
//  MathGame
//
//  Created by Nathan Larson on 10/16/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameObject : NSObject

@property (nonatomic) NSString *blockTitle;
@property (nonatomic) UIColor *blockColor;
@property (nonatomic) BOOL isAnswer;
@property (nonatomic) NSString *answer;

- (id)initWithBlockTitle:(NSString *)blockTitle blockColor:(UIColor *)blockColor isAnswer:(BOOL)isAnswer answer:(NSString *)answer;

+ (id)gameObjectWithBlockTitle:(NSString *)blockTitle blockColor:(UIColor *)blockColor isAnswer:(BOOL)isAnswer answer:(NSString *)answer;

- (void)setAsAnswer:(NSString *)answer;

@end
