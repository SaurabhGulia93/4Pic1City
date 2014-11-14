//
//  playViewController.h
//  4Pic1City
//
//  Created by unibera1 on 9/4/13.
//  Copyright (c) 2013 unibera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "purchaseViewController.h"
#import "FlurryAds.h"

@interface playViewController : UIViewController
@property (retain, nonatomic) IBOutlet UILabel *scoreLabel;
@property (retain, nonatomic) IBOutlet UIImageView *enlargeImageView;
@property (retain, nonatomic) IBOutlet UIImageView *backgroundView;
@property (retain, nonatomic) IBOutlet UILabel *coinsLabel;
@property (retain, nonatomic) IBOutlet UICollectionView *myCollection;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil score:(NSString *)score user_id:(NSString *)u_id;
- (IBAction)backButton:(UIButton *)sender;
-(void)makeLabels:(NSString *)cityName;
-(BOOL)setLabel:(NSString *)str button:(UIButton *)button;
-(void)GetEntries;
-(void) makeShuffle:(NSString *)cityName;
-(void)setScore;
-(void)getUser;
-(void) hint;
-(void)cheat;
@end
