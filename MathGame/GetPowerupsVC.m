//
//  GetPowerupsVC.m
//  MathGame
//
//  Created by Nathan Larson on 10/20/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import "GetPowerupsVC.h"

#import <StoreKit/StoreKit.h>
#import "IAP.h"

@interface GetPowerupsVC ()<IAPHelperDelegate>

@property (nonatomic) NSArray *iapProducts;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIView *coverView;

@end

@implementation GetPowerupsVC

- (void)viewDidLoad
{
    [IAP sharedInstance].delegate = self;
    [[IAP sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            _iapProducts = products;
            NSLog(@"%@", _iapProducts);
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width, 1150.0);
    
    _coverView = [UIView new];
    _coverView.frame = self.view.frame;
    _coverView.backgroundColor = [UIColor colorWithWhite:100.0 / 255.0 alpha:0.8];
    [self.view addSubview:_coverView];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicator.center = self.view.center;
    [_activityIndicator startAnimating];
    [_coverView addSubview:_activityIndicator];
    _coverView.alpha = 0.0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
}



- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)productPurchased:(NSNotification *)notification {
    
    NSString * productIdentifier = notification.object;
    NSLog(@"%@", productIdentifier);
    
    if ([productIdentifier isEqualToString:@"A84TG2YU"]) {
        NSString *num = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_num_equation_solvers"];
        if (num == nil) {
            num = @"1";
            [[NSUserDefaults standardUserDefaults] setValue:num forKey:@"user_num_equation_solvers"];
        }else {
            int val = num.intValue;
            val++;
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%i", val] forKey:@"user_num_equation_solvers"];
        }
    }else if ([productIdentifier isEqualToString:@"A27JUH3"]) {
        NSString *num = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_num_thirty_second_boosters"];
        if (num == nil) {
            num = @"1";
            [[NSUserDefaults standardUserDefaults] setValue:num forKey:@"user_num_thirty_second_boosters"];
        }else {
            int val = num.intValue;
            val++;
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%i", val] forKey:@"user_num_thirty_second_boosters"];
        }
    }else if ([productIdentifier isEqualToString:@"A24RET5YH"]) {
        NSString *num = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_num_equation_solvers"];
        if (num == nil) {
            num = @"5";
            [[NSUserDefaults standardUserDefaults] setValue:num forKey:@"user_num_equation_solvers"];
        }else {
            int val = num.intValue;
            val = val + 5;
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%i", val] forKey:@"user_num_equation_solvers"];
        }
    }else if ([productIdentifier isEqualToString:@"A64JE2H"]) {
        NSString *num = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_num_thirty_second_boosters"];
        if (num == nil) {
            num = @"5";
            [[NSUserDefaults standardUserDefaults] setValue:num forKey:@"user_num_thirty_second_boosters"];
        }else {
            int val = num.intValue;
            val = val + 5;
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%i", val] forKey:@"user_num_thirty_second_boosters"];
        }
    }else if ([productIdentifier isEqualToString:@"A3TY23F"]) { //Ultimate unlock.
        
        NSArray *gameTypes = @[@"Addition +", @"Subtraction -", @"Multiplication x"];
        
        for (int i = 0; i < (int)gameTypes.count; i++) {
            for (int j = 2; j <= 30; j++) {
                [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:[NSString stringWithFormat:@"%@level%ilocked", gameTypes[i], j]];
            }
        }
    }else if ([productIdentifier isEqualToString:@"A3F345GH"]) { // 5 pk stars
        NSString *num = [[NSUserDefaults standardUserDefaults] valueForKey:@"stars_earned"];
        if (num == nil) {
            num = @"5";
            [[NSUserDefaults standardUserDefaults] setValue:num forKey:@"stars_earned"];
        }else {
            int val = num.intValue;
            val = val + 5;
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%i", val] forKey:@"stars_earned"];
        }
    }else if ([productIdentifier isEqualToString:@"A94FG2K"]) { // 15 pk stars
        NSString *num = [[NSUserDefaults standardUserDefaults] valueForKey:@"stars_earned"];
        if (num == nil) {
            num = @"15";
            [[NSUserDefaults standardUserDefaults] setValue:num forKey:@"stars_earned"];
        }else {
            int val = num.intValue;
            val = val + 15;
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%i", val] forKey:@"stars_earned"];
        }
    }else if ([productIdentifier isEqualToString:@"A13RGU3H"]) { // 30 pk stars
        NSString *num = [[NSUserDefaults standardUserDefaults] valueForKey:@"stars_earned"];
        if (num == nil) {
            num = @"30";
            [[NSUserDefaults standardUserDefaults] setValue:num forKey:@"stars_earned"];
        }else {
            int val = num.intValue;
            val = val + 30;
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%i", val] forKey:@"stars_earned"];
        }
    }else if ([productIdentifier isEqualToString:@"A4G5WE2"]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"ads_are_removed"];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 0.0;
    }];
    
}

- (void)didCancelPurchase
{
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 0.0;
    }];
}

- (IBAction)doneButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buyOneEquationSolver:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    
    SKProduct *product;
    for (int i = 0; i < (int)_iapProducts.count; i++) {
        SKProduct *p = _iapProducts[i];
        if ([p.productIdentifier isEqualToString:@"A84TG2YU"]) {
            product = p;
        }
    }
    
    NSLog(@"Buying %@...", product.productIdentifier);
    [[IAP sharedInstance] buyProduct:product];
    
}

- (IBAction)buyOneTimeExtender:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    
    SKProduct *product;
    for (int i = 0; i < (int)_iapProducts.count; i++) {
        SKProduct *p = _iapProducts[i];
        if ([p.productIdentifier isEqualToString:@"A27JUH3"]) {
            product = p;
        }
    }
    
    NSLog(@"Buying %@...", product.productIdentifier);
    [[IAP sharedInstance] buyProduct:product];
    
    
    
}

- (IBAction)buyFiveEquationSolvers:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    
    SKProduct *product;
    for (int i = 0; i < (int)_iapProducts.count; i++) {
        SKProduct *p = _iapProducts[i];
        if ([p.productIdentifier isEqualToString:@"A24RET5YH"]) {
            product = p;
        }
    }
    
    NSLog(@"Buying %@...", product.productIdentifier);
    [[IAP sharedInstance] buyProduct:product];
    
    
    
}

- (IBAction)buyFiveTimeExtenders:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    
    SKProduct *product;
    for (int i = 0; i < (int)_iapProducts.count; i++) {
        SKProduct *p = _iapProducts[i];
        if ([p.productIdentifier isEqualToString:@"A64JE2H"]) {
            product = p;
        }
    }
    
    NSLog(@"Buying %@...", product.productIdentifier);
    [[IAP sharedInstance] buyProduct:product];
    
    
    
}

- (IBAction)buyUltimateUnlock:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    
    SKProduct *product;
    for (int i = 0; i < (int)_iapProducts.count; i++) {
        SKProduct *p = _iapProducts[i];
        if ([p.productIdentifier isEqualToString:@"A3TY23F"]) {
            product = p;
        }
    }
    
    NSLog(@"Buying %@...", product.productIdentifier);
    [[IAP sharedInstance] buyProduct:product];
    
}

- (IBAction)buyFivePackStars:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    
    SKProduct *product;
    for (int i = 0; i < (int)_iapProducts.count; i++) {
        SKProduct *p = _iapProducts[i];
        if ([p.productIdentifier isEqualToString:@"A3F345GH"]) {
            product = p;
        }
    }
    
    NSLog(@"Buying %@...", product.productIdentifier);
    [[IAP sharedInstance] buyProduct:product];
    
}

- (IBAction)buyFifteenPackStars:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    
    SKProduct *product;
    for (int i = 0; i < (int)_iapProducts.count; i++) {
        SKProduct *p = _iapProducts[i];
        if ([p.productIdentifier isEqualToString:@"A94FG2K"]) {
            product = p;
        }
    }
    
    NSLog(@"Buying %@...", product.productIdentifier);
    [[IAP sharedInstance] buyProduct:product];
    
}

- (IBAction)buyThirtyPackStars:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    
    SKProduct *product;
    for (int i = 0; i < (int)_iapProducts.count; i++) {
        SKProduct *p = _iapProducts[i];
        if ([p.productIdentifier isEqualToString:@"A13RGU3H"]) {
            product = p;
        }
    }
    
    NSLog(@"Buying %@...", product.productIdentifier);
    [[IAP sharedInstance] buyProduct:product];
    
}

- (IBAction)restorePurchases:(id)sender {
    
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    
}




@end
