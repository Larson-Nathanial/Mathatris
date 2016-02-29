//
//  ChooseTypeScreenVC.m
//  MathGame
//
//  Created by Nathan Larson on 10/15/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import "ChooseTypeScreenVC.h"
#import "ChooseLevelScreenVC.h"
#import <iAd/iAd.h>

#import <StoreKit/StoreKit.h>
#import "IAP.h"

@interface ChooseTypeScreenVC ()<IAPHelperDelegate, ADBannerViewDelegate>

@property (nonatomic) ADBannerView *adBanner;
@property (nonatomic) NSArray *iapProducts;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIView *coverView;

@end

@implementation ChooseTypeScreenVC

- (void)viewDidLoad
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"ads_are_removed"] isEqualToString:@"YES"]) {
        _removeAdsButton.alpha = 0.0;
    }
    
    [[IAP sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            _iapProducts = products;
            NSLog(@"%@", _iapProducts);
        }
    }];
    
    _adBanner = [ADBannerView new];
    _adBanner.delegate = self;

}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated
{
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
//        _alreadyChangedScrollView = 1;
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
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 0.0;
    }];
}

- (IBAction)mainMenuButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)additionTypeAction:(id)sender {
    ChooseLevelScreenVC *viewController = [ChooseLevelScreenVC new];
    viewController.gameType = @"Addition +";
    viewController.gameTypeColor = ((UIButton *)sender).backgroundColor;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didCancelPurchase
{
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 0.0;
    }];
}

- (IBAction)subtractionTypAction:(id)sender {
    ChooseLevelScreenVC *viewController = [ChooseLevelScreenVC new];
    viewController.gameType = @"Subtraction -";
    viewController.gameTypeColor = ((UIButton *)sender).backgroundColor;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)multiplicationTypeAction:(id)sender {
    ChooseLevelScreenVC *viewController = [ChooseLevelScreenVC new];
    viewController.gameType = @"Multiplication x";
    viewController.gameTypeColor = ((UIButton *)sender).backgroundColor;
    [self.navigationController pushViewController:viewController animated:YES];
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
@end
