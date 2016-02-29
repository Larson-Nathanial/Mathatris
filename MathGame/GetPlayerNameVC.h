//
//  GetPlayerNameVC.h
//  MathGame
//
//  Created by Nathan Larson on 10/20/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GetPlayerNameDelegate <NSObject>

@required
- (void)savedPlayerName;

@end

@interface GetPlayerNameVC : UIView

@property (nonatomic, assign) id<GetPlayerNameDelegate>delegate;

@property (weak, nonatomic) IBOutlet UITextField *playNameTextField;

@end
