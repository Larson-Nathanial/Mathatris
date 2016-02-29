//
//  AppDelegate.m
//  MathGame
//
//  Created by Nathan Larson on 10/15/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import "AppDelegate.h"
#import "IAP.h"
#import "ManageScores.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [IAP sharedInstance];
    //test
//    [[NSUserDefaults standardUserDefaults] setValue:@50 forKey:@"stars_earned"];
    
    NSString *hasBeen = [[NSUserDefaults standardUserDefaults] valueForKey:@"hasBeenLoadedBefore"];
    if (hasBeen == nil) {
        [[NSUserDefaults standardUserDefaults] setValue:@"3" forKey:@"user_num_equation_solvers"];
        [[NSUserDefaults standardUserDefaults] setValue:@"3" forKey:@"user_num_thirty_second_boosters"];
        [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"hasBeenLoadedBefore"];
        [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:@"ads_are_removed"];
        
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"is_sound_effects_on"];
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"is_background_music_on"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"app_id"] == nil) {
        
        [[NSUserDefaults standardUserDefaults] setValue:[[NSUUID UUID] UUIDString] forKey:@"app_id"];
        
        dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(aQueue, ^{
            [[ManageScores scoreManager] didCreateNewApp];
        });
        
    }
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"app_id"] != nil) {
        dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(aQueue, ^{
            [[ManageScores scoreManager] didMarkAppIdAsActive];
        });
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"app_id"] != nil) {
        dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(aQueue, ^{
            [[ManageScores scoreManager] didMarkAppIdAsInActive];
        });
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"app_id"] != nil) {
        dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(aQueue, ^{
            [[ManageScores scoreManager] didMarkAppIdAsInActive];
        });
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"app_id"] != nil) {
        dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(aQueue, ^{
            [[ManageScores scoreManager] didMarkAppIdAsActive];
        });
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"app_id"] != nil) {
        dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(aQueue, ^{
            [[ManageScores scoreManager] didMarkAppIdAsActive];
        });
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"app_id"] != nil) {
        dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(aQueue, ^{
            [[ManageScores scoreManager] didMarkAppIdAsInActive];
        });
    }
}

@end
