//
//  usersViewController.m
//  4Pic1City
//
//  Created by unibera1 on 9/3/13.
//  Copyright (c) 2013 unibera. All rights reserved.
//

#import "usersViewController.h"
#import "AppDelegate.h"
#import "Users.h"
#import "playViewController.h"

@interface usersViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation usersViewController
{
    NSArray *userArray;
    NSUserDefaults *defaults;
    int TAG;
    int frameWidth,frameHeight;
    UIPopoverController *pop;
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
    frameWidth = [UIScreen mainScreen].bounds.size.width;
    frameHeight = [UIScreen mainScreen].bounds.size.height;
    [self GetEntries];
    // Do any additional setup after loading the view from its nib.
}

-(BOOL)prefersStatusBarHidden{
    
    return YES;
}

- (IBAction)backButton:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (IBAction)addNewUser:(UIButton *)sender {
    
    if ([FlurryAds adReadyForSpace:@"INTERSTITIAL_MAIN_VC"])
        [FlurryAds displayAdForSpace:@"INTERSTITIAL_MAIN_VC" onView:self.view];
    else
        [FlurryAds fetchAdForSpace:@"INTERSTITIAL_MAIN_VC" frame:self.view.frame size:FULLSCREEN];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"New User" message:@"Enter Your Name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    int flag = 1;
    NSLog(@"userArray count = %d",userArray.count);
    if(buttonIndex)
    {
        UITextField *text = [alertView textFieldAtIndex:0];
        if([text.text isEqual:@""] || [text.text isEqual:@" "])
        {
                UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Enter your name" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [errorAlert show];
                flag = 0;
        }
        else
        {
            for(int i=0;i<userArray.count;i++)
            {
                Users *user = (Users *)[userArray objectAtIndex:i];
                NSLog(@"username = %@",user.name);
                if([user.name isEqual:text.text])
                {
                    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Player with same name already present" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [errorAlert show];
                    flag = 0;
                    break;
                }
            }
        }
        if(flag)
        {
            NSLog(@"Entered name=%@",text.text);
            [self userEntry:text.text];
            [self GetEntries];
            [_userTable reloadData];
        }
    }
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil userName:(NSString *)str bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [self userEntry:str];
        // Custom initialization
    }
    return self;
}



-(void)viewWillAppear:(BOOL)animated{
    
    [_userTable reloadData];
}

-(void)userEntry:(NSString *)str{
    
    NSManagedObjectContext *context = [AppDelegate getcontext];
    Users *user = [NSEntityDescription insertNewObjectForEntityForName:@"Users" inManagedObjectContext:context];
    user.name = str;
    user.image = UIImagePNGRepresentation([UIImage imageNamed:@"User_profilePic.png"]);
    user.score = [NSString stringWithFormat:@"%d",0];
    user.user_id = [NSString stringWithFormat:@"%d",(userArray.count + 1)];
    user.coins = [NSString stringWithFormat:@"%d",250];
    NSLog(@"uid is = %@",user.user_id);
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell%d",indexPath.row]];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[NSString stringWithFormat:@"Cell%d",indexPath.row]]autorelease];
    }
    NSLog(@"IndexPath = %d",indexPath.row);
    if(userArray.count)
    {
        UIImageView *backgroundView = [[UIImageView alloc]initWithFrame:cell.frame];
        backgroundView.image = [UIImage imageNamed:@"List_field.png"];
        [cell setBackgroundView:backgroundView];
        Users *user = (Users *)[userArray objectAtIndex:indexPath.row];
        UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect ];
        [button addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:button];
        button.tag = indexPath.row + 1;
        [button setFrame:CGRectMake(250*frameWidth/320, 3*frameHeight/480, 60*frameWidth/320, 60*frameHeight/480)];
        [button setBackgroundImage:[UIImage imageWithData:user.image] forState:UIControlStateNormal];
        cell.textLabel.text = user.name;
        cell.detailTextLabel.text = @"Score  ";
        cell.detailTextLabel.text = [cell.detailTextLabel.text stringByAppendingString:user.score];
        cell.textLabel.font = [UIFont systemFontOfSize:28.0];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0];
        [backgroundView release];
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(userArray.count <= 4)
    {
        [_userTable setFrame:CGRectMake(0, 100*frameHeight/480, 320*frameWidth/320, (70 + (70 * (userArray.count - 1)))*frameHeight/480)];
    }
    else
    {
        [_userTable setFrame:CGRectMake(0, 100*frameHeight/480, 320*frameWidth/320, (70 + (70 * (4 - 1)))*frameHeight/480)];
    }
    NSLog(@"Array count = %d",userArray.count);
    return userArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([FlurryAds adReadyForSpace:@"INTERSTITIAL_MAIN_VC"])
        [FlurryAds displayAdForSpace:@"INTERSTITIAL_MAIN_VC" onView:self.view];
    else
        [FlurryAds fetchAdForSpace:@"INTERSTITIAL_MAIN_VC" frame:self.view.frame size:FULLSCREEN];
    Users *user = [userArray objectAtIndex:indexPath.row];
    NSLog(@"%@ %@ %@",user.score,user.user_id,user.name);
    playViewController *view = [[[playViewController alloc]initWithNibName:@"playViewController" bundle:nil score:user.score user_id:user.user_id]autorelease];
    [self presentViewController:view animated:YES completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  70.0f*frameHeight/480;
}

-(void)clicked:(UIButton *)sender{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    CGRect popFrame;
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    TAG = sender.tag;
    if(TAG <=4)
    {
        popFrame = CGRectMake(sender.frame.origin.x, sender.frame.origin.y + TAG*(80.0f*frameHeight/480), sender.frame.size.width, sender.frame.size.height);
    }
    else
    {
        popFrame = CGRectMake(sender.frame.origin.x, sender.frame.origin.y + 4*(80.0f*frameHeight/480), sender.frame.size.width, sender.frame.size.height);
    }
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        pop = [[UIPopoverController alloc]initWithContentViewController:picker];
//        [pop presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        [pop presentPopoverFromRect:popFrame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

    }
    else
        [self presentViewController:picker animated:YES completion:NULL];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSArray *arr;
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    NSData *imageData = UIImagePNGRepresentation(chosenImage);
    
    NSManagedObjectContext *context = [AppDelegate getcontext];
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    req.entity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:context];
    [req setPredicate: [NSPredicate predicateWithFormat:@"user_id = %d",TAG]];
    NSError *err = nil;
    arr= [context executeFetchRequest:req error:&err];
    NSLog(@"image Count = %d",arr.count);
    if (err) {
        
        NSLog(@"error occured : %@", err.description);
    }
    Users *user = (Users *)[arr objectAtIndex:0];
    user.image = imageData;
    [context save:&err];
    [_userTable reloadData];
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        [pop dismissPopoverAnimated:NO];
        [pop release];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [req release];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_backgroungImageView release];
    [_userTable release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setBackgroungImageView:nil];
    [self setUserTable:nil];
    [super viewDidUnload];
}

@end
