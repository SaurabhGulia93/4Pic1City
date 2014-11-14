//
//  HelpViewContollerViewController.h
//  Marketiing
//
//  Created by unibera on 9/3/13.
//  Copyright (c) 2013 Unibera Softwares Solution Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpViewContollerViewController : UIViewController
- (IBAction)skipButton:(UIButton *)sender;

@property (retain, nonatomic) NSArray *images;
@property (retain, nonatomic) IBOutlet UIPageControl *pageCtrl;
@property (retain, nonatomic) IBOutlet UICollectionView *collectionView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil helpImages:(NSArray*)array;

@end
