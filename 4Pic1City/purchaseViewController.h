//
//  purchaseViewController.h
//  4Pic1City
//
//  Created by unibera1 on 9/27/13.
//  Copyright (c) 2013 unibera. All rights reserved.
//

#import <UIKit/UIKit.h>

@class purchaseViewController;

@protocol purchaseDelegate <NSObject>

-(void)increaseCoins:(NSString*)boughtCoins;

@end

@interface purchaseViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIButton *cancel;
@property (assign,nonatomic) id<purchaseDelegate> delegate;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)cancelButton:(UIButton *)sender;

@end
