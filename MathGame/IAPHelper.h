//
//  IAPHelper.h
//  MathGame
//
//  Created by Nathan Larson on 10/30/15.
//  Copyright © 2015 nathanlarson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

@protocol IAPHelperDelegate <NSObject>

- (void)didCancelPurchase;

@end

@interface IAPHelper : NSObject

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;
- (void)buyProduct:(SKProduct *)product;
- (BOOL)productPurchased:(NSString *)productIdentifier;

@property (nonatomic, assign) id<IAPHelperDelegate>delegate;

@end
