//
//  IAP.m
//  MathGame
//
//  Created by Nathan Larson on 10/30/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import "IAP.h"

@implementation IAP

+ (IAP *)sharedInstance {
    static dispatch_once_t once;
    static IAP * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"A4G5WE2", // Remove Ads - screenshot - Taken
                                      @"A84TG2YU", // One time equation solver - screenshot
                                      @"A24RET5YH", // 5 Pack Equation Solver - screenshot
                                      @"A27JUH3", // 30 Seconds More - screenshot
                                      @"A64JE2H", // 30 Seconds  more 5 Pack - screenshot
                                      @"A3F345GH", // stars 5 pk - screenshot
                                      @"A94FG2K", // stars 15 pk - screenshot
                                      @"A13RGU3H", // stars 30 pk - screenshot
                                      @"A3TY23F", // Ultimate Unlock - screenshot
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end
