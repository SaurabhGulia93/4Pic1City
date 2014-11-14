//
//  usersViewController.h
//  4Pic1City
//
//  Created by unibera1 on 9/3/13.
//  Copyright (c) 2013 unibera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "purchaseViewController.h"
#import "FlurryAds.h"

@interface usersViewController : UIViewController
- (IBAction)backButton:(UIButton *)sender;
- (IBAction)addNewUser:(UIButton *)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil userName:(NSString *)str bundle:(NSBundle *)nibBundleOrNil;

@property (retain, nonatomic) IBOutlet UITableView *userTable;
@property (retain, nonatomic) IBOutlet UIImageView *backgroungImageView;
-(void)userEntry:(NSString *)str;
-(void)GetEntries;

@end
