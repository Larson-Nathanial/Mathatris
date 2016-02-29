//
//  StartScreenVC.h
//  MathGame
//
//  Created by Nathan Larson on 10/15/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartScreenVC : UIViewController
- (IBAction)getPowerupsAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *removeAdsButton;
- (IBAction)removeAdsButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *mOutlet;
@property (weak, nonatomic) IBOutlet UILabel *aOutlet;
@property (weak, nonatomic) IBOutlet UILabel *tOutlet;
@property (weak, nonatomic) IBOutlet UILabel *hOutlet;

@property (weak, nonatomic) IBOutlet UILabel *bOutlet;
@property (weak, nonatomic) IBOutlet UILabel *oOutlet;
@property (weak, nonatomic) IBOutlet UILabel *a2Outlet;
@property (weak, nonatomic) IBOutlet UILabel *rOutlet;
@property (weak, nonatomic) IBOutlet UILabel *dOutlet;


@end
