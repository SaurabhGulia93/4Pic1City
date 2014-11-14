//
//  forntViewController.h
//  4Pic1City
//
//  Created by unibera1 on 9/3/13.
//  Copyright (c) 2013 unibera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlurryAds.h"
#include <GameKit/GameKit.h>


@interface forntViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIButton *openInfoOtlet;
@property (retain, nonatomic) IBOutlet UIButton *open;
@property (retain, nonatomic) IBOutlet UIView *openInfoView;
- (IBAction)openInfo:(UIButton *)sender;
- (IBAction)onOffButton:(UIButton *)sender;
@property (retain, nonatomic) IBOutlet UIButton *onOffOutlet;
//- (IBAction)soundButton:(UISwitch *)sender;
@property (retain, nonatomic) IBOutlet UILabel *currentPlayerLabel;
@property (retain, nonatomic) IBOutlet UILabel *userScore;
@property (retain, nonatomic) IBOutlet UILabel *userName;
- (IBAction)marketTool:(UIButton *)sender;
@property (retain, nonatomic) IBOutlet UIImageView *userImage;
- (IBAction)playButton:(UIButton *)sender;
- (IBAction)newUser:(UIButton *)sender;
-(void)soundOnOff;
@end
