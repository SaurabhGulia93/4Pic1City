//
//  forntViewController.m
//  4Pic1City
//
//  Created by unibera1 on 9/3/13.
//  Copyright (c) 2013 unibera. All rights reserved.
//

#import "forntViewController.h"
#import "usersViewController.h"
#import "HelpViewContollerViewController.h"
#import "Users.h"
#import "AppDelegate.h"
#import "playViewController.h"
#import "PromotionUtils.h"
#import "GameCenterManager.h"
#import "AppSpecificValues.h"

@interface forntViewController ()<UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,GameCenterManagerDelegate,GKLeaderboardViewControllerDelegate>

@end

@implementation forntViewController
{
    NSArray *userArray;
    NSUserDefaults *defaults;
    int TAG;
    Users *user;
    int on;
    BOOL soundFlag;
    BOOL infoFlag;
    CGRect frame;
    int originOfInfoView;
    NSMutableArray *helpImages;
    GameCenterManager *gameCenterManager;
    int frameWidth,frameHeight;
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
    infoFlag = YES;
    frameWidth = [UIScreen mainScreen].bounds.size.width;
    frameHeight = [UIScreen mainScreen].bounds.size.height;
    [_currentPlayerLabel setHidden:YES];
    helpImages = [[NSMutableArray alloc]init];
    soundFlag = YES;
    [self soundOnOff];
    [_onOffOutlet setBackgroundImage:[UIImage imageNamed:@"sound_on.png"] forState:UIControlStateNormal];
    frame = _openInfoView.frame;
    
    gameCenterManager = [GameCenterManager getInstanceWithDelegate:self];
    // Do any additional setup after loading the view from its nib.
}

-(BOOL)prefersStatusBarHidden{

    return YES;
}

-(void)viewWillAppear:(BOOL)animated{

    [FlurryAds setAdDelegate:self];
    [FlurryAds fetchAdForSpace:@"INTERSTITIAL_MAIN_VC" frame:self.view.frame size:FULLSCREEN];

    NSUserDefaults *lastPlayed = [NSUserDefaults standardUserDefaults];
    NSString *userName = [lastPlayed objectForKey:@"name"];
    NSLog(@"userName = %@",userName);
    if(userName)
    {
        NSManagedObjectContext *context = [AppDelegate getcontext];
        NSFetchRequest *req = [[NSFetchRequest alloc] init];
        req.entity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:context];
        [req setPredicate: [NSPredicate predicateWithFormat:@"name = %@",userName]];
        
        NSError *err = nil;
        userArray= [context executeFetchRequest:req error:&err];
        [req release];
        
        if (err) {
            
            NSLog(@"error occured : %@", err.description);
        }
        NSLog(@"userArray count = %d",userArray.count);
        user = (Users *)[userArray objectAtIndex:0];
        [_currentPlayerLabel setHidden:NO];
        [_userImage setImage:[UIImage imageWithData:user.image]];
        [_userName setText:[NSString stringWithFormat:@"%@",user.name]];
        [_userScore setText:[NSString stringWithFormat:@"Score %@",user.score]];
        [user retain];
        [userArray retain];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    if(infoFlag)
    {
        originOfInfoView = self.openInfoView.frame.origin.x;
        infoFlag = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)playButton:(UIButton *)sender {
    
//    playViewController *play = [[playViewController alloc]initWithNibName:@"playViewController" bundle:nil];

    NSLog(@"%@,%@",user.score,user.user_id);
    if(userArray.count)
    {
        playViewController *play = [[[playViewController alloc]initWithNibName:@"playViewController" bundle:nil score:user.score user_id:user.user_id]autorelease];
        [self presentViewController:play animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"New User" message:@"Enter Your Name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [alert show];
    }
}

- (IBAction)newUser:(UIButton *)sender {
    
    if ([FlurryAds adReadyForSpace:@"INTERSTITIAL_MAIN_VC"])
        [FlurryAds displayAdForSpace:@"INTERSTITIAL_MAIN_VC" onView:self.view];
    else
        [FlurryAds fetchAdForSpace:@"INTERSTITIAL_MAIN_VC" frame:self.view.frame size:FULLSCREEN];
    usersViewController *userController = [[[usersViewController alloc]initWithNibName:@"usersViewController" bundle:nil]autorelease];
    [self presentViewController:userController animated:YES completion:nil];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex)
    {
        UITextField *text = [alertView textFieldAtIndex:0];
        if([text.text isEqual:@""] || [text.text isEqual:@" "])
        {
            UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Enter your name" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [errorAlert show];
        }
        else
        {
            NSLog(@"Entered name=%@",text.text);
            usersViewController *userController = [[[usersViewController alloc]initWithNibName:@"usersViewController" userName:text.text bundle:nil]autorelease];
            [self presentViewController:userController animated:YES completion:nil];

        }
        
    }
}

-(void)userEntry:(NSString *)str{
    
    NSManagedObjectContext *context = [AppDelegate getcontext];
    Users *user1 = [NSEntityDescription insertNewObjectForEntityForName:@"Users" inManagedObjectContext:context];
    user1.name = str;
    user1.image = UIImagePNGRepresentation([UIImage imageNamed:@"pic.png"]);
    user1.score = [NSString stringWithFormat:@"%d",0];
    user1.user_id = [NSString stringWithFormat:@"%d",userArray.count + 1];
    NSLog(@"uid is = %@",user1.user_id);
    NSError *err = nil;
    [context save:&err];
}

-(void)GetEntries
{
    NSManagedObjectContext *context = [AppDelegate getcontext];
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    req.entity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:context];
    
    NSError *err = nil;
    userArray= [context executeFetchRequest:req error:&err];
    
    if (err) {
        
        NSLog(@"error occured : %@", err.description);
    }
    NSLog(@"userArray count = %d",userArray.count);
    [userArray retain];
    [req release];
}

- (void)dealloc {
    [_userImage release];
    [_userName release];
    [_userScore release];
    [_currentPlayerLabel release];
    [_onOffOutlet release];
    [_open release];
    [_openInfoView release];
    [_openInfoOtlet release];
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


-(void)soundOnOff{

    NSUserDefaults *sound = [NSUserDefaults standardUserDefaults];
    [sound setBool:soundFlag forKey:@"sound"];
    [sound synchronize];
}

- (IBAction)openInfo:(UIButton *)sender {
    UIView *view = [sender superview];
    [UIView animateWithDuration:0.5 animations:^{
        if (sender.tag == 0) {
            [view setFrame:CGRectMake(0, view.frame.origin.y, view.frame.size.width, view.frame.size.height)];
            sender.tag = 1;
            sender.transform = CGAffineTransformConcat(sender.transform,CGAffineTransformMakeRotation(M_PI));
        } else {
            [view setFrame:CGRectMake(originOfInfoView, view.frame.origin.y, view.frame.size.width, view.frame.size.height)];
            sender.tag = 0;
            sender.transform = CGAffineTransformConcat(sender.transform,CGAffineTransformMakeRotation(M_PI));
        }
    }];
}

- (IBAction)onOffButton:(UIButton *)sender {
    
     NSUserDefaults *sound = [NSUserDefaults standardUserDefaults];
    if([sound boolForKey:@"sound"])
    {
        [_onOffOutlet setBackgroundImage:[UIImage imageNamed:@"mute.png"] forState:UIControlStateNormal];
        soundFlag = NO;
    }
    else
    {
        [_onOffOutlet setBackgroundImage:[UIImage imageNamed:@"sound_on.png"] forState:UIControlStateNormal];
        soundFlag = YES;
    }
    [self soundOnOff];
    
    if ([FlurryAds adReadyForSpace:@"INTERSTITIAL_MAIN_VC"])
        [FlurryAds displayAdForSpace:@"INTERSTITIAL_MAIN_VC" onView:self.view];
    else
        [FlurryAds fetchAdForSpace:@"INTERSTITIAL_MAIN_VC" frame:self.view.frame size:FULLSCREEN];
}

- (IBAction)marketTool:(UIButton *)sender {
    
    UIImage *image1 = [UIImage imageNamed:@"HGFHG.jpg"];
    UIImage *image2 = [UIImage imageNamed:@"iOS Simulator Screen shot Sep 5, 2013 4.50.10 PM.jpg"];
    UIImage *image3 = [UIImage imageNamed:@"iOS Simulator Screen shot Sep 5, 2013 4.51.12 PM.jpg"];
    UIImage *image4 = [UIImage imageNamed:@"iOS Simulator Screen shot SHJJep 5, 2013 4.51.12 PM.jpg"];
    
    switch (sender.tag) {
        case 0:
            [PromotionUtils rateApp];
            break;
        case 1:
            [PromotionUtils openLinkInBrowser:FB_LINK];
            break;
        case 2:
            if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
            {
                [PromotionUtils tellAFriendWithMessage:@"Hey, this is really great.\n Try this." fromRect:sender.frame inView:sender];
            }
            else
                [PromotionUtils tellAFriendWithMessage:@"Hey, this is really great.\n Try this. " fromController:self];
            break;
        case 3:
            [PromotionUtils takeFeedbackFromController:self subject:@"Did you like this app?" body:@"I am loving it..!!"];
            break;
        case 4:
            [PromotionUtils aboutUS];
            break;
        case 5:
            [helpImages addObject:image1];
            [helpImages addObject:image2];
            [helpImages addObject:image3];
            [helpImages addObject:image4];
            HelpViewContollerViewController *help = [[[HelpViewContollerViewController alloc]initWithNibName:@"HelpViewContollerViewController" bundle:Nil helpImages:helpImages]autorelease];
            [self presentViewController:help animated:YES completion:nil];
            break;
    default:
            break;
    }
}

#pragma mark gameCenterDelegate
- (IBAction) showLeaderboard
{
    GKLeaderboardViewController *leaderboardController = [[[GKLeaderboardViewController alloc] init] autorelease];
    if (leaderboardController != NULL)
    {
        leaderboardController.category = kLeaderboardID;
        leaderboardController.timeScope = GKLeaderboardTimeScopeWeek;
        leaderboardController.leaderboardDelegate = self;
        //        [self presentModalViewController: leaderboardController animated: YES];
        [self presentViewController:leaderboardController animated:YES completion:nil];
    }
}
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
    //    [self dismissModalViewControllerAnimated:YES];
    //    [viewController release];
}

@end
