//
//  StartScreenVC.m
//  MathGame
//
//  Created by Nathan Larson on 10/15/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import "StartScreenVC.h"
#import "GetPowerupsVC.h"
#import <iAd/iAd.h>
#import "LeaderBoardVC.h"
#import "SettingsVC.h"

#import <StoreKit/StoreKit.h>
#import "IAP.h"

@interface StartScreenVC ()<IAPHelperDelegate, ADBannerViewDelegate>

@property (nonatomic) ADBannerView *adBanner;
@property (nonatomic) int alreadyChangedScrollView;
@property (nonatomic) NSArray *iapProducts;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIView *coverView;

@end

@implementation StartScreenVC

- (void)viewDidLoad
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"ads_are_removed"] isEqualToString:@"YES"]) {
        _removeAdsButton.alpha = 0.0;
    }
    [IAP sharedInstance].delegate = self;
    [[IAP sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            _iapProducts = products;
            NSLog(@"%@", _iapProducts);
        }
    }];
    
    _adBanner = [ADBannerView new];
    _adBanner.delegate = self;
    
}



-(void)viewDidAppear:(BOOL)animated
{
    _mOutlet.layer.cornerRadius = 3.0;
    _mOutlet.layer.masksToBounds = YES;
    _aOutlet.layer.cornerRadius = 3.0;
    _aOutlet.layer.masksToBounds = YES;
    _tOutlet.layer.cornerRadius = 3.0;
    _tOutlet.layer.masksToBounds = YES;
    _hOutlet.layer.cornerRadius = 3.0;
    _hOutlet.layer.masksToBounds = YES;
    
    _bOutlet.layer.cornerRadius = 3.0;
    _bOutlet.layer.masksToBounds = YES;
    _oOutlet.layer.cornerRadius = 3.0;
    _oOutlet.layer.masksToBounds = YES;
    _a2Outlet.layer.cornerRadius = 3.0;
    _a2Outlet.layer.masksToBounds = YES;
    _rOutlet.layer.cornerRadius = 3.0;
    _rOutlet.layer.masksToBounds = YES;
    _dOutlet.layer.cornerRadius = 3.0;
    _dOutlet.layer.masksToBounds = YES;
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, 480.0);
    [_scrollView setShowsVerticalScrollIndicator:NO];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"ads_are_removed"] isEqualToString:@"NO"]) {
        [_adBanner removeFromSuperview];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            _adBanner.frame = CGRectMake(0.0, self.view.bounds.size.height - 66.0, self.view.bounds.size.width, 66.0);
        }else {
            _adBanner.frame = CGRectMake(0.0, self.view.bounds.size.height - 50.0, self.view.bounds.size.width, 50.0);
        }
        [self.view addSubview:_adBanner];
    }else {
//        if (_alreadyChangedScrollView != 1) {
            _scrollView.frame = CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y, _scrollView.frame.size.width, self.view.bounds.size.height - 148.0);
            _removeAdsButton.alpha = 0.0;
            _adBanner.alpha = 0.0;
            _alreadyChangedScrollView = 1;
//        }
        
    }
    
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

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    _removeAdsButton.alpha = 0.0;
    _adBanner.alpha = 0.0;
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    _removeAdsButton.alpha = 1.0;
    _adBanner.alpha = 1.0;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    
}



- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)productPurchased:(NSNotification *)notification {
    
    NSString * productIdentifier = notification.object;
    NSLog(@"%@", productIdentifier);
    [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"ads_are_removed"];
    _scrollView.frame = CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y, _scrollView.frame.size.width, self.view.bounds.size.height - 148.0);
    _removeAdsButton.alpha = 0.0;
    [_adBanner removeFromSuperview];
    _alreadyChangedScrollView = 1;
    
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

- (IBAction)getPowerupsAction:(id)sender {
    [self presentViewController:[GetPowerupsVC new] animated:YES completion:nil];
}
- (IBAction)removeAdsButtonAction:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    
    SKProduct *product;
    for (int i = 0; i < (int)_iapProducts.count; i++) {
        SKProduct *p = _iapProducts[i];
        if ([p.productIdentifier isEqualToString:@"A4G5WE2"]) {
            product = p;
        }
    }

    NSLog(@"Buying %@...", product.productIdentifier);
    [[IAP sharedInstance] buyProduct:product];
    
}
- (IBAction)leaderBoardAction:(id)sender {
    [self presentViewController:[LeaderBoardVC new] animated:YES completion:nil];
}
- (IBAction)settingsButtonAction:(id)sender {
    [self presentViewController:[SettingsVC new] animated:YES completion:nil];
}
@end
