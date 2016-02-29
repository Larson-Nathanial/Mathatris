//
//  LeaderBoardVC.m
//  MathGame
//
//  Created by Nathan Larson on 10/21/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import "LeaderBoardVC.h"
#import "LeaderBoardCell.h"
#import "ManageScores.h"

@interface LeaderBoardVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSArray *scores;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIView *coverView;

@end

@implementation LeaderBoardVC

- (void)viewDidLoad
{
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LeaderBoardCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LeaderBoardCell class])];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
}

- (IBAction)doneButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    _coverView = [UIView new];
    _coverView.frame = self.view.frame;
    _coverView.backgroundColor = [UIColor colorWithWhite:100.0 / 255.0 alpha:0.8];
    [self.view addSubview:_coverView];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicator.center = self.view.center;
    [_activityIndicator startAnimating];
    [_coverView addSubview:_activityIndicator];
    _coverView.alpha = 0.0;
    
    [self loadstuff];
}

- (void)loadstuff
{
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^{
        
        _scores = [[ManageScores scoreManager] getScores];
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [UIView animateWithDuration:0.5 animations:^{
                _coverView.alpha = 0.0;
            }];
        });
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _scores.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeaderBoardCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LeaderBoardCell class]) forIndexPath:indexPath];
    
    
    cell.playerName.text = [NSString stringWithFormat:@"%@", [_scores[indexPath.row] valueForKey:@"user_name"]];
    cell.score.text = [NSString stringWithFormat:@"%@", [_scores[indexPath.row] valueForKey:@"score"]];
    
    return cell;
}

@end
