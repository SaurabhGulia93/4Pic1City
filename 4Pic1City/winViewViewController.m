//
//  winViewViewController.m
//  4Pic1City
//
//  Created by unibera1 on 8/7/13.
//  Copyright (c) 2013 unibera. All rights reserved.
//

#import "winViewViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface winViewViewController ()

@end

@implementation winViewViewController
{
    int count;
    NSTimer *moveTimer;
    AVAudioPlayer *player;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
} 

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURL *fileURL1 = nil;
    NSUserDefaults *sound = [NSUserDefaults standardUserDefaults];
    BOOL soundFlag = [sound boolForKey:@"sound"];
    if(soundFlag)
    {
        NSString *soundFilePath1 = [[NSBundle mainBundle] pathForResource:@"small_group_of_american_children_cheer_and_clap" ofType: @"mp3"];
        fileURL1 = [[NSURL alloc] initFileURLWithPath:soundFilePath1 ];
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL1 error:nil];
        [player play];
        
    }
    [fileURL1 release];
    [_home setHidden:YES];
    [_next setHidden:YES];
    [self.view setBackgroundColor:[UIColor colorWithRed:00 green:00 blue:00 alpha:0.7]];
    count = 0;
    
    [self.yippeeImageView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 0.01, 0.01)];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationStopped)];
    [self.yippeeImageView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 1, 1)];
    [UIView commitAnimations];
    
//    moveTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(move) userInfo:nil repeats:YES];
    
//    self.view.alpha = 0.5;
    // Do any additional setup after loading the view from its nib.
}

-(BOOL)prefersStatusBarHidden{
    
    return YES;
}

-(void)animationStopped{

    NSLog(@"animationStopped");
   
    [_home setHidden:NO];
    [_next setHidden:NO];
}
-(void)move{
    static int i;
    static int timer;
    UIImageView * imageView1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"coin.png"]];
    imageView1.frame= CGRectMake((i+1)*55, 300, 1, 1);
    [self.view addSubview:imageView1];
    [UIView animateWithDuration:0.3 animations:^{
    
        imageView1.frame = CGRectMake((i+1)*55 , 300, 40, 40);
        
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.2 animations:^{
            
            imageView1.frame = CGRectMake(300, 0, 0, 0);
        }];
        
        i++;
    }];
    
    timer ++;
    if(timer ==4)
    {
        [moveTimer invalidate];
    }
    
}
- (void)viewDidUnload {
   
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [_yippeeImageView release];
    [player release];
    [_home release];
    [_next release];
    [super dealloc];
}

- (IBAction)tryNext:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)homeButton:(UIButton *)sender {

    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
