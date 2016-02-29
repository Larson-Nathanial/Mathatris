//
//  GameObject.m
//  MathGame
//
//  Created by Nathan Larson on 10/16/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import "GameObject.h"

@implementation GameObject

- (id)initWithBlockTitle:(NSString *)blockTitle blockColor:(UIColor *)blockColor isAnswer:(BOOL)isAnswer answer:(NSString *)answer
{
    self = [super init];
    if (self) {
        self.blockTitle = blockTitle;
        self.blockColor = blockColor;
        self.isAnswer = isAnswer;
        self.answer = answer;
    }
    return self;
}

+ (id)gameObjectWithBlockTitle:(NSString *)blockTitle blockColor:(UIColor *)blockColor isAnswer:(BOOL)isAnswer answer:(NSString *)answer
{
    return [[self alloc] initWithBlockTitle:blockTitle blockColor:blockColor isAnswer:isAnswer answer:answer];
}

- (void)setAsAnswer:(NSString *)answer
{
    self.isAnswer = YES;
    self.answer = answer;
    self.blockTitle = @"";
    self.blockColor = [UIColor clearColor];
}

@end
