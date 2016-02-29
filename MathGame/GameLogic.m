//
//  GameLogic.m
//  MathGame
//
//  Created by Nathan Larson on 10/16/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import "GameLogic.h"

@interface GameLogic ()

@property (nonatomic) int numCombos;

@end

@implementation GameLogic

+ (GameLogic *)functions
{
    static GameLogic *functions = nil;
    
    if (!functions) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            functions = [[self alloc] initPrivate];
        });
    }
    return functions;
}

- (instancetype)initPrivate
{
    self = [super init];
    return self;
}

- (NSArray *)equationsBasedOnType:(NSString *)game_type withCombo:(NSArray *)combo level:(NSString *)level timer:(BOOL)timer
{
    NSMutableArray *equations = [NSMutableArray new];
    int randomNumberIdentifier = [self numberOfDigitsForLevel:level];
    int totalEquations = 3;
    _numCombos = (int)combo.count;
    
    if (!timer) {
        totalEquations = [self getNumberOfEquationsForLevel:level];
    }
    
    for (int i = 0; i < totalEquations; i++) {
        
        // first num
        GameObject *firstNumber = [self gameObjectForNumber:randomNumberIdentifier];
        // operand
        GameObject *operand = [self operandForGameType:game_type withCombo:combo];
        // second num
        GameObject *secondNumber = [self gameObjectForNumber:randomNumberIdentifier];
        // equal sign
        GameObject *equalSign = [self equalSign];
        // result
        GameObject *result = [self resultForFirstNumber:firstNumber operand:operand secondNumber:secondNumber];
        
        int direction = arc4random_uniform(2);
        if (direction == 1) {
            [equations addObject:@[firstNumber, operand, secondNumber, equalSign, result]];
        }else {
            [equations addObject:@[result, equalSign, secondNumber, operand, firstNumber]];
        }
    }
    return [self determineAnswersForEquations:equations];
}

- (NSArray *)loadTwoMoreEquationsForType:(NSString *)game_type withCombo:(NSArray *)combo level:(NSString *)level
{
    NSMutableArray *equations = [NSMutableArray new];
    int randomNumberIdentifier = [self numberOfDigitsForLevel:level];
    int totalEquations = 2;
    _numCombos = (int)combo.count;
    
    for (int i = 0; i < totalEquations; i++) {
        
        // first num
        GameObject *firstNumber = [self gameObjectForNumber:randomNumberIdentifier];
        // operand
        GameObject *operand = [self operandForGameType:game_type withCombo:combo];
        // second num
        GameObject *secondNumber = [self gameObjectForNumber:randomNumberIdentifier];
        // equal sign
        GameObject *equalSign = [self equalSign];
        // result
        GameObject *result = [self resultForFirstNumber:firstNumber operand:operand secondNumber:secondNumber];
        
        int direction = arc4random_uniform(2);
        if (direction == 1) {
            [equations addObject:@[firstNumber, operand, secondNumber, equalSign, result]];
        }else {
            [equations addObject:@[result, equalSign, secondNumber, operand, firstNumber]];
        }
    }
    return [self determineAnswersForEquations:equations];
}

- (NSArray *)loadEquationForType:(NSString *)game_type withCombo:(NSArray *)combo level:(NSString *)level
{
    NSMutableArray *equations = [NSMutableArray new];
    int randomNumberIdentifier = [self numberOfDigitsForLevel:level];
    int totalEquations = 1;
    _numCombos = (int)combo.count;
    
    for (int i = 0; i < totalEquations; i++) {
        
        // first num
        GameObject *firstNumber = [self gameObjectForNumber:randomNumberIdentifier];
        // operand
        GameObject *operand = [self operandForGameType:game_type withCombo:combo];
        // second num
        GameObject *secondNumber = [self gameObjectForNumber:randomNumberIdentifier];
        // equal sign
        GameObject *equalSign = [self equalSign];
        // result
        GameObject *result = [self resultForFirstNumber:firstNumber operand:operand secondNumber:secondNumber];
        
        int direction = arc4random_uniform(2);
        if (direction == 1) {
            [equations addObject:@[firstNumber, operand, secondNumber, equalSign, result]];
        }else {
            [equations addObject:@[result, equalSign, secondNumber, operand, firstNumber]];
        }
    }
    return [self determineAnswersForEquations:equations];
}

- (int)getNumberOfEquationsForLevel:(NSString *)level
{
    return (3 * [level intValue]);
}

- (int)numberOfDigitsForLevel:(NSString *)level
{
    if ([level intValue] <= 10) {
        return 9;
    }else if ([level intValue] > 10 && [level intValue] <= 20) {
        return 99;
    }else {
        return 999;
    }
}

- (GameObject *)gameObjectForNumber:(int)randomIdentifier
{
    int number = arc4random_uniform(randomIdentifier);
    return [GameObject gameObjectWithBlockTitle:[NSString stringWithFormat:@"%i", number] blockColor:[self colorForObjectWithNumber:number] isAnswer:NO answer:nil];
}

- (UIColor *)colorForObjectWithNumber:(int)block_object
{
    // look at the last number.
    int lastDigit = block_object % 10;
    
    if (lastDigit == 0) {
        return [UIColor colorWithRed:199.0 / 255.0 green:199.0 / 255.0 blue:204.0 / 255.0 alpha:1.0];
    }else if (lastDigit == 1) {
        return [UIColor colorWithRed:76.0 / 255.0 green:217.0 / 255.0 blue:100.0 / 255.0 alpha:1.0];
    }else if (lastDigit == 2) {
        return [UIColor colorWithRed:255.0 / 255.0 green:59.0 / 255.0 blue:48.0 / 255.0 alpha:1.0];
    }else if (lastDigit == 3) {
        return [UIColor colorWithRed:255.0 / 255.0 green:149.0 / 255.0 blue:0.0 / 255.0 alpha:1.0];
    }else if (lastDigit == 4) {
        return [UIColor colorWithRed:255.0 / 255.0 green:204.0 / 255.0 blue:0.0 / 255.0 alpha:1.0];
    }else if (lastDigit == 5) {
        return [UIColor colorWithRed:52.0 / 255.0 green:170.0 / 255.0 blue:220.0 / 255.0 alpha:1.0];
    }else if (lastDigit == 6) {
        return [UIColor colorWithRed:0.0 / 255.0 green:122.0 / 255.0 blue:255.0 / 255.0 alpha:1.0];
    }else if (lastDigit == 7) {
        return [UIColor colorWithRed:88.0 / 255.0 green:86.0 / 255.0 blue:214.0 / 255.0 alpha:1.0];
    }else if (lastDigit == 8) {
        return [UIColor colorWithRed:255.0 / 255.0 green:45.0 / 255.0 blue:85.0 / 255.0 alpha:1.0];
    }else {
        return [UIColor colorWithRed:142.0 / 255.0 green:142.0 / 255.0 blue:147.0 / 255.0 alpha:1.0];
    }
}

- (GameObject *)operandForGameType:(NSString *)gameType withCombo:(NSArray *)combo
{
    if ([gameType isEqualToString:@"Addition +"]) {
        return [GameObject gameObjectWithBlockTitle:@"+" blockColor:[self colorForOperand] isAnswer:NO answer:nil];
    }else if ([gameType isEqualToString:@"Subtraction -"]) {
        return [GameObject gameObjectWithBlockTitle:@"-" blockColor:[self colorForOperand] isAnswer:NO answer:nil];
    }else if ([gameType isEqualToString:@"Multiplication x"]) {
        return [GameObject gameObjectWithBlockTitle:@"x" blockColor:[self colorForOperand] isAnswer:NO answer:nil];
    }else {
        if (_numCombos > 1) {
            int nextCombo = arc4random_uniform(_numCombos - 1);
            NSString *comboType = [combo objectAtIndex:nextCombo];
            if ([comboType isEqualToString:@"Addition +"]) {
                return [GameObject gameObjectWithBlockTitle:@"+" blockColor:[self colorForOperand] isAnswer:NO answer:nil];
            }else if ([comboType isEqualToString:@"Subtraction -"]) {
                return [GameObject gameObjectWithBlockTitle:@"-" blockColor:[self colorForOperand] isAnswer:NO answer:nil];
            }else {
                return [GameObject gameObjectWithBlockTitle:@"x" blockColor:[self colorForOperand] isAnswer:NO answer:nil];
            }
        }else {
            NSString *comboType = [combo objectAtIndex:0];
            if ([comboType isEqualToString:@"Addition +"]) {
                return [GameObject gameObjectWithBlockTitle:@"+" blockColor:[self colorForOperand] isAnswer:NO answer:nil];
            }else if ([comboType isEqualToString:@"Subtraction -"]) {
                return [GameObject gameObjectWithBlockTitle:@"-" blockColor:[self colorForOperand] isAnswer:NO answer:nil];
            }else {
                return [GameObject gameObjectWithBlockTitle:@"x" blockColor:[self colorForOperand] isAnswer:NO answer:nil];
            }
        }
    }
}

- (GameObject *)equalSign
{
    return [GameObject gameObjectWithBlockTitle:@"=" blockColor:[self colorForOperand] isAnswer:NO answer:nil];
}

- (GameObject *)resultForFirstNumber:(GameObject *)first_number operand:(GameObject *)operand secondNumber:(GameObject *)second_number
{
    int num1 = first_number.blockTitle.intValue;
    int num2 = second_number.blockTitle.intValue;
    int result = 0;
    
    if ([operand.blockTitle isEqualToString:@"+"]) {
        result = num1 + num2;
    }else if ([operand.blockTitle isEqualToString:@"-"]) {
        result = num1 - num2;
    }else {
        result = num1 * num2;
    }
    
    return [GameObject gameObjectWithBlockTitle:[NSString stringWithFormat:@"%i", result] blockColor:[self colorForObjectWithNumber:result] isAnswer:NO answer:nil];
}

- (UIColor *)colorForOperand
{
    return [UIColor colorWithWhite:45.0 / 255.0 alpha:1.0];
}

- (NSArray *)determineAnswersForEquations:(NSArray *)equations
{
    NSArray *numberToTake = @[@"0", @"2", @"4"];
    for (int i = 0; i < equations.count; i++) {
        int num = arc4random_uniform((int)numberToTake.count - 1);
        NSString *value = [numberToTake objectAtIndex:num];
        GameObject *object = (GameObject *)[[equations objectAtIndex:i] objectAtIndex:value.intValue];
        [object setAsAnswer:object.blockTitle];
    }
    
    return equations;
}

- (NSArray *)generatePossibleAnswersForLevel:(NSString *)level andAnswer:(GameObject *)answer
{
    int numberDigits = [self numberOfDigitsForLevel:level];
    NSMutableArray *possibleAnswers = [NSMutableArray new];
    
    for (int i = 0; i < 3; i++) {
        
        GameObject *object = nil;
        
        BOOL canAdd = NO;
        
        while (!canAdd) {
            object = [self gameObjectForNumber:numberDigits];
            BOOL foundMatch = NO;
            for (GameObject *gObject in possibleAnswers) {
                if (gObject.blockTitle.intValue == object.blockTitle.intValue) {
                    foundMatch = YES;
                }
            }
            if (!foundMatch) {
                canAdd = YES;
            }
        }
        [possibleAnswers addObject:object];
    }
    
    answer.blockTitle = answer.answer;
    answer.blockColor = [self colorForObjectWithNumber:answer.answer.intValue];
    
    [possibleAnswers insertObject:answer atIndex:arc4random_uniform(3)];
    
    return possibleAnswers;
}

@end
