//
//  HelpViewContollerViewController.m
//  Marketiing
//
//  Created by unibera on 9/3/13.
//  Copyright (c) 2013 Unibera Softwares Solution Pvt Ltd. All rights reserved.
//

#import "HelpViewContollerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PromotionUtils.h"

@interface HelpViewContollerViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation HelpViewContollerViewController

@synthesize images, pageCtrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil helpImages:(NSArray*)array
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.images = [array retain];
//        self.title = NSLocalizedStringFromTable(@"Help", @"AppiraterLocalizable", nil);
        self.title = [PromotionUtils localizedStringWithKey:@"Help"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancel:)] autorelease];
    
    [images release];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"HelpCell"];
    
    self.pageCtrl.numberOfPages = images.count;
    [self.pageCtrl addTarget:self action:@selector(onPageControl:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)onPageControl:(UIPageControl*)pageControl
{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:pageCtrl.currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

-(void)onCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    [pageCtrl release];
    [_collectionView release];
    [super dealloc];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HelpCell" forIndexPath:indexPath];
    UIImage *img = [images objectAtIndex:indexPath.row];
    cell.contentView.layer.contents = (id)img.CGImage;
    [self.pageCtrl setCurrentPage:indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size;
}

- (IBAction)skipButton:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
