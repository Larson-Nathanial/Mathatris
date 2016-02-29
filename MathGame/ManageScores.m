//
//  ManageScores.m
//  MathGame
//
//  Created by Nathan Larson on 10/20/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import "ManageScores.h"

@interface ManageScores ()

@property (nonatomic) NSString *verification;

@end

@implementation ManageScores

+ (ManageScores *)scoreManager
{
    static ManageScores *scoreManager = nil;
    
    if (!scoreManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            scoreManager = [[self alloc] initPrivate];
        });
    }
    return scoreManager;
}

- (instancetype)initPrivate
{
    self = [super init];
    _verification = @"iefMksUIuchfu2834y823e9hskdfj283r9jhs3dlOIjrhqSDFA4faufDFAfhosdfho48Fdh2j3kfDAGueiwlF32kdjf2";
    return self;
}

- (void)completedLevel:(NSString *)level forTime:(NSString *)time_amount withScore:(NSString *)score ofGameType:(NSString *)game_type
{
    NSArray *storedScores = [[NSUserDefaults standardUserDefaults] objectForKey:@"player_scores"];
    if (storedScores == nil) {
        storedScores = @[@{@"player_name" : [[NSUserDefaults standardUserDefaults] valueForKey:@"user_player_name"]
                           , @"game_type" : game_type
                           , @"level" : level
                           , @"time_amount" : time_amount
                           , @"score" : score}];
        [[NSUserDefaults standardUserDefaults] setObject:storedScores forKey:@"player_scores"];
    }else {
        
        NSMutableArray *mArray = [NSMutableArray arrayWithArray:storedScores];
        for (int i = 0; i < mArray.count; i++) {
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)mArray[i]];
            if ([[dictionary valueForKey:@"game_type"] isEqualToString:game_type] && [[dictionary valueForKey:@"level"] isEqualToString:level] && [[dictionary valueForKey:@"time_amount"] isEqualToString:time_amount]) {
                NSString *prevscore = [dictionary valueForKey:@"score"];
                if (prevscore.intValue < score.intValue) {
                    [dictionary setValue:score forKey:@"score"];
                    NSArray *finalArray = [NSArray arrayWithArray:mArray];
                    [[NSUserDefaults standardUserDefaults] setObject:finalArray forKey:@"player_scores"];
                    break;
                }
            }
        }
        
        
    }
    
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^{
        [self updatePlayerScoreWithGameType:game_type andScore:score andTimeAmount:time_amount andLevel:level];
    });
}

- (void)updatePlayerScoreWithGameType:(NSString *)game_type andScore:(NSString *)score andTimeAmount:(NSString *)time_amount andLevel:(NSString *)level
{
    NSString *player_name = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_player_name"];
    NSString *app_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"app_id"];
    
    NSString *post = [NSString stringWithFormat:@"verify=%@&game_type=%@&score=%@&time_amount=%@&level=%@&player_name=%@&app_id=%@", _verification, game_type, score, time_amount, level, player_name, app_id];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/mathboard/updateScore.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        
    responseData = nil;
}

- (NSArray *)getScores
{
    NSString *post = [NSString stringWithFormat:@"verify=%@", _verification];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/mathboard/getScores.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        return nil;
    }else {
        NSArray *returnData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnData.count > 0) {
                return returnData;
            }else {
                return nil;
            }
        }
    }
    
    return nil;
}

- (BOOL)didMarkAppIdAsActive
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&app_id=%@", _verification, [[NSUserDefaults standardUserDefaults] valueForKey:@"app_id"]];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/mathboard/MarkAsActive.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {

        return NO;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnString.length > 0) {
                if ([returnString isEqualToString:@"YES"]) {
                    return YES;
                }else {
                    return NO;
                }
            }else {
                return NO;
            }
        }
    }
    return NO;

}

- (BOOL)didMarkAppIdAsInActive
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&app_id=%@", _verification, [[NSUserDefaults standardUserDefaults] valueForKey:@"app_id"]];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/mathboard/MarkAsInActive.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {

        return NO;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnString.length > 0) {
                if ([returnString isEqualToString:@"YES"]) {
                    return YES;
                }else {
                    return NO;
                }
            }else {
                return NO;
            }
        }
    }
    return NO;

}

- (BOOL)didCreateNewApp
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&app_id=%@", _verification, [[NSUserDefaults standardUserDefaults] valueForKey:@"app_id"]];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/mathboard/DidCreateNewApp.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        
        return NO;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnString.length > 0) {
                if ([returnString isEqualToString:@"YES"]) {
                    return YES;
                }else {
                    return NO;
                }
            }else {
                return NO;
            }
        }
    }
    return NO;
}

@end
