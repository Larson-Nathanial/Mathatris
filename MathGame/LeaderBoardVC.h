//
//  LeaderBoardVC.h
//  MathGame
//
//  Created by Nathan Larson on 10/21/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaderBoardVC : UIViewController
- (IBAction)doneButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
