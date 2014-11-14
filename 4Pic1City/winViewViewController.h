//
//  winViewViewController.h
//  4Pic1City
//
//  Created by unibera1 on 8/7/13.
//  Copyright (c) 2013 unibera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface winViewViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIButton *next;
@property (retain, nonatomic) IBOutlet UIButton *home;
@property (retain, nonatomic) IBOutlet UIImageView *yippeeImageView;
- (IBAction)tryNext:(UIButton *)sender;
- (IBAction)homeButton:(UIButton *)sender;

@end

