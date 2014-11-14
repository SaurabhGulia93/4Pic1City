//
//  playViewController.m
//  4Pic1City
//
//  Created by unibera1 on 9/4/13.
//  Copyright (c) 2013 unibera. All rights reserved.
//

#import "playViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <Social/Social.h>
#import <QuartzCore/QuartzCore.h>
#import "winViewViewController.h"
#include "purchaseViewController.h"
#import "AppDelegate.h"
#import "CityDetails.h"
#import "Users.h"
#import "GameCenterManager.h"
#import "AppSpecificValues.h"
#import "MyCell.h"

@interface playViewController ()<UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UIAlertViewDelegate,purchaseDelegate,GameCenterManagerDelegate>

@end

@implementation playViewController
{
    UIView *labelView;
    UIView *buttonView;
    NSMutableArray *labelArray;
    NSMutableArray *buttonArray;
    NSArray *userArray;
    NSArray *array;
    int flag;
    UIButton *cheat1;
    UIButton *cheat2;
    NSTimer *makeButton;
    int imageChange;
    int m,n;
    int count1;
    int shuffledIndex;
    NSMutableArray *shuffledArray;
    CityDetails *globalCity;
    int viewAppear;
    NSMutableArray *randomNumber;
    NSMutableArray *hintNumber;
    int shuffledLength;
    int increment;
    int numberarr;
    int hint;
    int appearFlag;
    int frameWidth,frameHeight;
    BOOL soundFlag;
    AVAudioPlayer *buttonAudioPlayer;
    AVAudioPlayer *labelAudioPlayer;
    NSUserDefaults *globalDefaults;
    GameCenterManager *gameCenterManagerObject;
    int coins;
}

static int level;
static int uid;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil score:(NSString *)score user_id:(NSString *)u_id
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        level = [score intValue];
        uid = [u_id intValue];
        NSLog(@"level = %d uid is = %d",level,uid);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [FlurryAds setAdDelegate:self];
    [FlurryAds fetchAdForSpace:@"INTERSTITIAL_MAIN_VC" frame:self.view.frame size:FULLSCREEN];
    NSURL *fileURL1 = nil;
    NSURL *fileURL2 = nil;
    NSUserDefaults *sound = [NSUserDefaults standardUserDefaults];
    soundFlag = [sound boolForKey:@"sound"];
    if(soundFlag)
    {
        NSString *soundFilePath1 = [[NSBundle mainBundle] pathForResource:@"two_tone_nav" ofType: @"mp3"];
        fileURL1 = [[NSURL alloc] initFileURLWithPath:soundFilePath1 ];
        labelAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL1 error:nil];
        NSString *soundFilePath2 = [[NSBundle mainBundle] pathForResource:@"pop_up_pirate_game_plastic_sword_remove_from_barrel_version_2" ofType: @"mp3"];
        fileURL2 = [[NSURL alloc] initFileURLWithPath:soundFilePath2 ];
        buttonAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL2 error:nil];
    }
    NSLog(@"%d",soundFlag);
    frameWidth = [UIScreen mainScreen].bounds.size.width;
    frameHeight = [UIScreen mainScreen].bounds.size.height;
    viewAppear = 0;
    appearFlag = 1;
    [fileURL1 release];
    [fileURL2 release];
    gameCenterManagerObject = [GameCenterManager getInstanceWithDelegate:self];
    
}

-(BOOL)prefersStatusBarHidden{
    
    return YES;
}

-(void)viewWillAppear:(BOOL)animated{

    if(appearFlag)
    {
    m=0,n=0;
    count1 = 0;
    shuffledIndex = 0;
    [_enlargeImageView setHidden:YES];
    [_scoreLabel setText:[NSString stringWithFormat:@"%d",level]];
    if(level!=0 && level%2==0)
    {
        if ([FlurryAds adReadyForSpace:@"INTERSTITIAL_MAIN_VC"])
            [FlurryAds displayAdForSpace:@"INTERSTITIAL_MAIN_VC" onView:self.view];
        else
            [FlurryAds fetchAdForSpace:@"INTERSTITIAL_MAIN_VC" frame:self.view.frame size:FULLSCREEN];
    }
    [self getUser];
    Users *user = (Users *)[userArray objectAtIndex:0];
    if(viewAppear)
    {
        [labelView removeFromSuperview];
        [buttonView removeFromSuperview];
        [_myCollection reloadData];
        _coinsLabel.text = [NSString stringWithFormat:@"%d",_coinsLabel.text.intValue +5];
    }
    else
    {
        _coinsLabel.text  = user.coins;
    }

    labelArray = [[NSMutableArray alloc]init];
    buttonArray = [[NSMutableArray alloc]init];
    labelView = [[UIView alloc]initWithFrame:CGRectMake(0, 310*frameHeight/480, 320*frameWidth/320, 50*frameHeight/480)];
    [self.view addSubview:labelView];
    
    UIImageView *backgroundLabelView = [[UIImageView alloc]init];
    [labelView addSubview:backgroundLabelView];
    [backgroundLabelView setFrame:CGRectMake(0, 0, 320*frameWidth/320, 50*frameHeight/480)];
    [backgroundLabelView setImage:[UIImage imageNamed:@"Word_bg3.png"]];
    buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 365*frameHeight/480, 320*frameWidth/320, 85*frameHeight/480)];
    [self.view addSubview:buttonView];
    [backgroundLabelView release];
    [self GetEntries];
    
    globalCity = (CityDetails *)[array objectAtIndex:level + 1];
    NSUserDefaults *lastPlayed = [NSUserDefaults standardUserDefaults];
    user = (Users *)[userArray objectAtIndex:0];
    NSLog(@"coins = %@",user.coins);
    [lastPlayed setObject:user.name forKey:@"name"];
    [lastPlayed synchronize];
    NSLog(@"User Name = %@",user.name);
    NSLog(@"City Name = %@",[globalCity.city_name uppercaseString]);
    [self.myCollection registerNib:[UINib nibWithNibName:@"MyCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    [self makeLabels:[globalCity.city_name uppercaseString]];
    [self makeShuffle:[globalCity.city_name uppercaseString]];
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkAnswer) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(shakeButton) userInfo:nil repeats:YES];
    makeButton = [NSTimer scheduledTimerWithTimeInterval:.15 target:self selector:@selector(make) userInfo:nil repeats:YES];
    
    [self setScore];
    randomNumber = [[NSMutableArray alloc]init];
    hintNumber = [[NSMutableArray alloc]init];
    shuffledLength = 12;
    flag = 0;
    imageChange = 1;
    increment = 0;
    numberarr = 0;
    hint = 0;
    NSLog(@"outside viewAppear");
    }

}

-(void)getUser{
    
    if(uid)
           {
                NSManagedObjectContext *context = [AppDelegate getcontext];
                NSFetchRequest *req = [[NSFetchRequest alloc] init];
                req.entity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:context];
                [req setPredicate: [NSPredicate predicateWithFormat:@"user_id = %d",uid]];
        
                NSError *err = nil;
                userArray= [context executeFetchRequest:req error:&err];
               [req release];
                if (err) {
        
                    NSLog(@"error occured : %@", err.description);
                }
                NSLog(@"userArray count = %d",userArray.count);

            }

}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *str;
    CityDetails *city = (CityDetails *)[array objectAtIndex:level + 1];
    
    NSLog(@"City Name = %@",[globalCity.city_name uppercaseString]);
    NSLog(@"City Name = %@",[city.city_name uppercaseString]);
    
    switch (indexPath.item) {
        case 0:
            str = city.image_1;
            NSLog(@"str = %@",str);
            break;
        case 1:
            str = city.image_2;
            NSLog(@"str = %@",str);
            
            break;
        case 2:
            str = city.image_3;
            break;
        default:
            str = city.image_4;
            break;
    }
    UIImageView *iView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pic_bg.png"]];
    iView.frame = cell.frame;
    [cell setBackgroundView:iView];
    [cell.cityImage setImage:[UIImage imageNamed:str]];
    [iView release];
    
    return  cell;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 4;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(imageChange)
    {
        MyCell *cell = (MyCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [_enlargeImageView setHidden:NO];
        [self.enlargeImageView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 0.01, 0.01)];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationStopped)];
        [self.enlargeImageView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 1, 1)];
        [UIView commitAnimations];
        [_enlargeImageView setImage:cell.cityImage.image];
        imageChange =0;
    }
    else
    {
        [self.enlargeImageView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 1, 1)];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationStopped)];
        [self.enlargeImageView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 0.0, 0.0)];
        [UIView commitAnimations];
        imageChange = 1;
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = 122*frameWidth/320;
    CGFloat height = 109*frameHeight/480;
    return CGSizeMake(width, height);
}

-(void)GetEntries
{
    NSManagedObjectContext *context = [AppDelegate getcontext];
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    req.entity = [NSEntityDescription entityForName:@"CityDetails" inManagedObjectContext:context];
    
    NSError *err = nil;
    array= [context executeFetchRequest:req error:&err];
    [req release];
    if (err) {
        
        NSLog(@"error occured : %@", err.description);
    }
    [array retain];
    
}

-(void)makeLabels:(NSString *)cityName{
    
    int j;
    NSLog(@"lenght = %d",cityName.length);
    switch (cityName.length) {
        case 3:
            j=25 * 4.2;
            break;
        case 4:
            j=25 * 4;
            break;
        case 5:
            j = 25 * 3.6;
            break;
        case 6:
            j = 25 * 3.2;
            break;
        case 7:
            j=25 * 2.7;
            break;
        case 8:
            j= 25 * 2.2;
            break;
        case 9:
            j= 25 * 1.8;
            break;
        case 10:
            j = 25 * 1.3;
            break;
        default:
            j=  25 * 0.3;
            break;
    }
    
    NSLog(@"j=%d",j);
    
    int i;
    for(i=0;i<cityName.length;i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [labelView addSubview:button];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        button.tag = i;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(labelClicked:) forControlEvents:UIControlEventTouchDown];
        [button setTitle:@" " forState:UIControlStateNormal];
        [button setFrame:CGRectMake(((j + i*23))*frameWidth/320, 10*frameHeight/480, 20*frameWidth/320, 27*frameHeight/480)];
        [button setBackgroundImage:[UIImage imageNamed:@"Word_bg2.png"] forState:UIControlStateNormal];
        [labelArray addObject:button];
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [labelView addSubview:button];
    [button setImage:[UIImage imageNamed:@"Facebook.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(shareFB) forControlEvents:UIControlEventTouchDown];
    [button setFrame:CGRectMake((j + i*23.3)*frameWidth/320, 7*frameHeight/480, 30*frameWidth/320, 30*frameHeight/480)];
    
}

-(void)buttonClicked:(UIButton *)sender
{
    if(soundFlag)
    {
        [buttonAudioPlayer play];
    }
    if([self setLabel:sender.titleLabel.text button:sender])
    {
        [sender setHidden:YES];
    }
    
}

-(BOOL)setLabel:(NSString *)str button:(UIButton *)button{
    
    for(UIButton *button in labelArray)
    {
        if([button.titleLabel.text isEqual:@" "])
        {
            [button setTitle:str forState:UIControlStateNormal];
            return YES;
        }
    }
    return NO;
}

-(void)labelClicked:(UIButton *)sender{
    
    if(soundFlag)
    {
        [labelAudioPlayer play];
    }
    for(UIButton *button in buttonArray)
    {
        if([sender.titleLabel.text isEqual:button.titleLabel.text])
        {
            if(button.isHidden)
            {
                [button setHidden:NO];
                [sender setTitle:@" " forState:UIControlStateNormal];
                break;
            }
            else
            {
                continue;
            }
            
        }
    }
}

-(void)checkAnswer{
    
    int count;
    count = 0;
    NSString *str = [[NSString alloc]init];
    for(UIButton *button in labelArray)
    {
        if(![button.titleLabel.text isEqual:@" "])
        {
            count++;
            str = [str stringByAppendingString:button.titleLabel.text];
            
        }
    }
    if(count == globalCity.city_name.length)
    {
        if([[globalCity.city_name uppercaseString] isEqualToString:str])
        {
            level++;
            viewAppear = 1;
            appearFlag = 1;
            for(UIButton *button in labelArray)
            {
                [button setTitle:@" " forState:UIControlStateNormal];
            }
            
            [self submitScore];
            winViewViewController *win = [[[winViewViewController alloc]initWithNibName:@"winViewViewController" bundle:nil]autorelease];
            self.modalPresentationStyle = UIModalPresentationCurrentContext;
            [self presentViewController:win animated:YES completion:nil];
            
        }
        else
        {
            if(!flag)
            {
                for(int j=0;j<5;j++)
                {
                    for(UIButton *button in labelArray)
                    {
                        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                    }
                }
                flag = 1;
            }
            else
            {
                for(int j=0;j<5;j++)
                {
                    for(UIButton *button in labelArray)
                    {
                        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    }
                }
                flag = 0;
            }
        }
        
    }
    else
    {
        for(int j=0;j<5;j++)
        {
            for(UIButton *button in labelArray)
            {
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
    }
}

-(void)shareFB{
    
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:@"Can You Solve this"];
        [controller addURL:[NSURL URLWithString:@"http://www.uniberasoftwaresolutions.com"]];
        [controller addImage:img];
        
        [self presentViewController:controller animated:YES completion:Nil];
        
    }
}

-(void)setScore{
    
        NSError *err = nil;
        NSManagedObjectContext *context = [AppDelegate getcontext];
        NSLog(@"userArray count = %d",userArray.count);
        Users *user = (Users *)[userArray objectAtIndex:0];
        user.score = [NSString stringWithFormat:@"%d",level];
        user.coins = _coinsLabel.text;
        [context save:&err];
        [userArray retain];
}

-(void)shakeButton{
    
    int labelNoText = 0;
    for(UIButton *button in labelArray)
    {
        if(([button.titleLabel.text isEqual:@""] || [button.titleLabel.text isEqual:@" "]))
        {
            labelNoText++;
        }
    }
    if(labelNoText == globalCity.city_name.length)
    {
    [UIView beginAnimations:@"Zoom" context:NULL];
    
    [UIView setAnimationDuration:0.05];
    [cheat2 setFrame:CGRectMake((7*37 +10)*frameWidth/320, 5*frameHeight/480, 48*frameWidth/320, 48*frameHeight/480)];
    [UIView commitAnimations];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setDuration:0.02];
    [animation setRepeatCount:4];
    [animation setAutoreverses:YES];
    [animation setFromValue:[NSValue valueWithCGPoint:
                             CGPointMake([cheat2 center].x - 5.0f, [cheat2 center].y)]];
    [animation setToValue:[NSValue valueWithCGPoint:
                           CGPointMake([cheat2 center].x + 5.0f, [cheat2 center].y)]];
    [[cheat2 layer] addAnimation:animation forKey:@"position"];
    [UIView setAnimationDuration:0.05];
    [cheat2 setFrame:CGRectMake((7*37 +10)*frameWidth/320, 5*frameHeight/480, 35*frameWidth/320, 35*frameHeight/480)];
    [UIView commitAnimations];
    
    [UIView setAnimationDuration:0.05];
    [cheat1 setFrame:CGRectMake((7*37 +10)*frameWidth/320, 45*frameHeight/480, 40*frameWidth/320, 45*frameHeight/480)];
    [UIView commitAnimations];
    
    [animation setDuration:0.02];
    [animation setRepeatCount:4];
    [animation setAutoreverses:YES];
    [animation setFromValue:[NSValue valueWithCGPoint:
                             CGPointMake([cheat1 center].x - 4.0f, [cheat1 center].y )]];
    [animation setToValue:[NSValue valueWithCGPoint:
                           CGPointMake([cheat1 center].x + 4.0f, [cheat1 center].y + 4.0f)]];
    [[cheat1 layer] addAnimation:animation forKey:@"position"];
    
    [UIView setAnimationDuration:0.05];
    [cheat1 setFrame:CGRectMake((7*37 +10)*frameWidth/320, 45*frameHeight/480, 35*frameWidth/320, 35*frameHeight/480)];
    [UIView commitAnimations];
    }
    
}

-(void)make{
    
    if(count1 < 6)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [buttonView addSubview:button];
        [button setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"Word_bg.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
        [button setTitle:[shuffledArray objectAtIndex:shuffledIndex] forState:UIControlStateNormal];
        [button setFrame:CGRectMake((((m+1)*37 + 35/2))*frameWidth/320, ((5 + 35/2))*frameHeight/480, 1*frameWidth/320, 1*frameHeight/480)];

        button.tag = count1;
        
        [buttonArray addObject:button];
        
        [UIView animateWithDuration:0.1 animations:^{
            [button setFrame:CGRectMake(((m+1)*37-25)*frameWidth/320, -20*frameHeight/480, 80*frameWidth/320, 800*frameHeight/480)];

        }completion:^(BOOL finished){
            [UIView animateWithDuration:0.1 animations:^{
                [button setFrame:CGRectMake(((m+1)*37)*frameWidth/320, 5*frameHeight/480, 35*frameWidth/320, 35*frameHeight/480)];
            }];
            m++;
        }];
        count1++;
        shuffledIndex++;
    }
    else
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [buttonView addSubview:button];
        [button setBackgroundImage:[UIImage imageNamed:@"Word_bg.png"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];

        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
        [button setTitle:[shuffledArray objectAtIndex:shuffledIndex] forState:UIControlStateNormal];
        button.tag = count1;
        [buttonArray addObject:button];
        [button setFrame:CGRectMake(((n*37 + 35/2))*frameWidth/320, ((45 + 35/2))*frameHeight/480, 1*frameWidth/320, 1*frameHeight/480)];
        [UIView animateWithDuration:0.09 animations:^{
            
            [button setFrame:CGRectMake(((n+1)*36)*frameWidth/320, 20*frameHeight/480 , 80*frameWidth/320, 800*frameHeight/480)];
            
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.09 animations:^{
                [button setFrame:CGRectMake(((n+1)*37)*frameWidth/320, 45*frameHeight/480, 35*frameWidth/320, 35*frameHeight/480)];
                n++;
            }];
        }];
        
        count1++;
        shuffledIndex++;
    }
    
    if(count1 == 12)
    {
        cheat1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [buttonView addSubview:cheat1];
        [cheat1 addTarget:self action:@selector(hintClicked) forControlEvents:UIControlEventTouchDown];
        [cheat1 setBackgroundImage:[UIImage imageNamed:@"Hint.png"] forState:UIControlStateNormal];
        [cheat1 setFrame:CGRectMake((7*37 +10)*frameWidth/320, 45*frameHeight/480, 35*frameWidth/320, 35*frameHeight/480)];
        cheat1.tag = 13;
        
        cheat2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [buttonView addSubview:cheat2];
        [cheat2 addTarget:self action:@selector(cheatClicked) forControlEvents:UIControlEventTouchDown];
        [cheat2 setBackgroundImage:[UIImage imageNamed:@"Delete.png"] forState:UIControlStateNormal];
        [cheat2 setFrame:CGRectMake(((7*37 +10))*frameWidth/320, 5*frameHeight/480, 35*frameWidth/320, 35*frameHeight/480)];
        cheat2.tag = 14;
        [makeButton invalidate];
    }
    
}

-(void)hintClicked{

    UIAlertView *hintAlert = [[UIAlertView alloc]initWithTitle:@"" message:@"Show a correct letter(60 coins)" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    hintAlert.tag = 1;
    [hintAlert show];
}

-(void)cheatClicked{
    
    UIAlertView *cheatAlert = [[UIAlertView alloc]initWithTitle:@"" message:@"Delete Some Letters(80 coins)" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    cheatAlert.tag = 2;
    [cheatAlert show];

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (buttonIndex) {
        
        if(alertView.tag ==1)
        {
            if([_coinsLabel.text intValue] > 60)
            {
                [self hint];
                _coinsLabel.text = [NSString stringWithFormat:@"%d",_coinsLabel.text.intValue - 60];
                [self setScore];
            }
            else
            {
                appearFlag =0;
                UIAlertView *notEnoughCoins = [[UIAlertView alloc]initWithTitle:@"" @"" message:@"You don't have enough coins" delegate:nil cancelButtonTitle:@"Ok"otherButtonTitles:nil];
                [notEnoughCoins show];
                purchaseViewController *purchase = [[[purchaseViewController alloc]initWithNibName:@"purchaseViewController" bundle:nil]autorelease];
                purchase.delegate = self;
                self.modalPresentationStyle = UIModalPresentationCurrentContext;
                [self presentViewController:purchase animated:YES completion:nil];
                
            }
        }
        else
        {
            if([_coinsLabel.text intValue] > 80)
            {
                NSLog(@"shuffledLength = %d",shuffledLength);
                if((shuffledLength - globalCity.city_name.length)/3)
                {
                [self cheat];
                _coinsLabel.text = [NSString stringWithFormat:@"%d",_coinsLabel.text.intValue - 80];
                [self setScore];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Limit Exceeded" message:@"You cant delete more!!!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alert show];
                }
            }
            else
            {
                appearFlag = 0;
                UIAlertView *notEnoughCoins = [[UIAlertView alloc]initWithTitle:@"" @"" message:@"You don't have enough coins" delegate:nil cancelButtonTitle:@"Ok"otherButtonTitles:nil];
                [notEnoughCoins show];
                purchaseViewController *purchase = [[[purchaseViewController alloc]initWithNibName:@"purchaseViewController" bundle:nil]autorelease];
                purchase.delegate = self;
                self.modalPresentationStyle = UIModalPresentationCurrentContext;
                [self presentViewController:purchase animated:YES completion:nil];
            }

        }
    }
}

-(void) hint{
    
    NSMutableArray *name = [[NSMutableArray alloc]init];
    int random;
    int count =1;
    int same = 0;
    int same1 = 0;
    for(int k=0;k<globalCity.city_name.length;k++)
    {
        unichar c= [[globalCity.city_name uppercaseString] characterAtIndex:k];
        NSLog(@"char is = %c",c);
        NSString *charString = [NSString stringWithFormat:@"%c",c];
        [name addObject:charString];
    }
    while(count == 1)
    {
        NSLog(@"In While");
        random = arc4random() % globalCity.city_name.length;
        NSLog(@"Random Selected = %d",random);
        if(hint!=0)
        {
            NSLog(@"in hint");
            NSLog(@"count = %d",hintNumber.count);
            for(int k=0;k<hintNumber.count;k++)
            {
                NSNumber *num = [hintNumber objectAtIndex:k];
                int check = [num intValue];
                NSLog(@"check = %d",check);
                if(check==random)
                {
                    same = 1;
                    break;
                }
            }
            
        }
        
        if(same)
        {
            NSLog(@"in Continue1");
            same = 0;
            continue;
        }
        
        NSString *str = [name objectAtIndex:random];
        str = [str uppercaseString];
        NSLog(@"str = %@",str);
        NSLog(@"random = %d",random);
        for(UIButton *button in labelArray)
        {
            if(button.tag == random)
            {
                if([button.titleLabel.text isEqual:str])
                {
                    same1 = 1;
                    break;
                }
                else
                {
                    count++;
                    hint++;
                    NSNumber *num = [NSNumber numberWithInt:random];
                    [hintNumber addObject:num];
                    
                    [button setTitle:str forState:UIControlStateNormal];
                    [button setUserInteractionEnabled:NO];
                }
            }
        }
        
        if(same1)
        {
            NSLog(@"In Same1");
            continue;
        }
        for(UIButton *button in buttonArray)
        {
            if([str isEqual:button.titleLabel.text])
            {
                [button setHidden:YES];
                break;
            }
        }
        
        
    }
    [name release];
}

-(void)cheat{
    
    NSMutableArray *name = [[NSMutableArray alloc]init];
    int del;
    int same = 0;
    int twice = 0;
    int namepresent = 0;
    int random;
    int count = 0;
    if((del = (shuffledLength - globalCity.city_name.length)/3))
    {
        shuffledLength = shuffledLength - del;
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Limit Exceeded" message:@"You cant delete more!!!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }
    for(int k=0;k<globalCity.city_name.length;k++)
    {
        unichar c= [[globalCity.city_name uppercaseString] characterAtIndex:k];
        NSString *charString = [NSString stringWithFormat:@"%c",c];
        [name addObject:charString];
    }
    NSLog(@"name  =%@",name);
    NSLog(@"shuffledArray = %@",shuffledArray);
    while(count!=del)
    {
        random = arc4random() % 12;
        NSLog(@"random = %d",random);
        NSLog(@"random char = %@",shuffledArray[random]);
        if(numberarr!=0)
        {
            for(int k=0;k<randomNumber.count;k++)
            {
                NSNumber *num = [randomNumber objectAtIndex:k];
                int check = [num intValue];
                if(check==random)
                {
                    same = 1;
                    break;
                }
            }
        }
        
        if(same)
        {
            same = 0;
            continue;
        }
        
        for(int k = 0;k < 12;k++)
        {
            if([[shuffledArray objectAtIndex:random] isEqual: [shuffledArray objectAtIndex:k]])
            {
                twice++;
            }
        }
        NSLog(@"twice = %d",twice);
        
        for(int k = 0;k < globalCity.city_name.length;k++)
        {
            if([[shuffledArray objectAtIndex:random] isEqual: [name objectAtIndex:k]])
            {
                namepresent++;
            }
        }
         NSLog(@"namepresent = %d",namepresent);
        if(namepresent < twice)
        {
            NSNumber *num = [NSNumber numberWithInt:random];
            [randomNumber addObject:num];
            twice = 0;
            namepresent = 0;
            numberarr=1;
            count++;
        }
        else
        {
            continue;
            
        }
    }
    NSLog(@"randomArray = %@",randomNumber);
    for(;increment<randomNumber.count;increment++)
    {
        for(UIButton *button in buttonArray)
        {
            int tag = [[randomNumber objectAtIndex:increment] intValue];
            if(button.tag == tag)
            {
                [button setHidden:YES];
            }
        }
    }
    [name release];
}

-(void)makeShuffle:(NSString *)cityName{
    
    shuffledArray = [[NSMutableArray alloc]init];
    for(int k=0 ; k < cityName.length; k++)
    {
        unichar c= [cityName characterAtIndex:k];
        NSString *charString = [NSString stringWithFormat:@"%c",c];
        [shuffledArray addObject:charString];
    }
    for(int k=cityName.length ; k<12; k++)
    {
        unichar c = 65 + arc4random_uniform(26);
        NSString *charString = [NSString stringWithFormat:@"%c",c];
        [shuffledArray addObject:charString];
    }
    NSLog(@"shuffled = %@",shuffledArray);
    
    NSUInteger count = [shuffledArray count];
    for (NSUInteger i = 0; i < count; ++i) {
        int nElements = count - i;
        int nn = (arc4random() % nElements) + i;
        [shuffledArray exchangeObjectAtIndex:i withObjectAtIndex:nn];
    }
    
    
}

//----Delegate Methods

-(void)increaseCoins:(NSString *)boughtCoins{

    _coinsLabel.text = [NSString stringWithFormat:@"%d",_coinsLabel.text.intValue + boughtCoins.intValue];
    [self setScore];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [_coinsLabel release];
    [_myCollection release];
    [_backgroundView release];
    [_enlargeImageView release];
    [_scoreLabel release];
    [buttonAudioPlayer release];
    [labelAudioPlayer release];
    [userArray release];
    [array release];
    [labelArray release];
    [labelView release];
    [buttonArray release];
    [buttonView release];
    [super dealloc];
}
- (void)viewDidUnload {
    
    [self setCoinsLabel:nil];
    [self setMyCollection:nil];
    [self setBackgroundView:nil];
    [super viewDidUnload];
}
- (IBAction)backButton:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)submitScore {
    if(level > 0)
    {
        [gameCenterManagerObject reportScore:level forCategory:kLeaderboardID];
    }
}

@end
