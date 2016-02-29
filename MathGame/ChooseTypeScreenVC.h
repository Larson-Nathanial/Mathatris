//
//  ChooseTypeScreenVC.h
//  MathGame
//
//  Created by Nathan Larson on 10/15/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseTypeScreenVC : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *removeAdsButton;
- (IBAction)removeAdsButtonAction:(id)sender;


@end
