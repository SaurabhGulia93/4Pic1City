//
//  PromotionUtils.m
//  Marketiing
//
//  Created by unibera on 9/3/13.
//  Copyright (c) 2013 Unibera Softwares Solution Pvt Ltd. All rights reserved.
//

#import "PromotionUtils.h"
#import "Appirater.h"
#import <MessageUI/MessageUI.h>

@interface PromotionUtils ()<UIAlertViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>
{
    CGRect presentingRect;
    UIView *presentingView;
    int type;
    UIViewController *presentingCtr;
}
@end


@implementation PromotionUtils

+ (PromotionUtils*)sharedInstance {
	static PromotionUtils *utils = nil;
	if (utils == nil)
	{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            utils = [[PromotionUtils alloc] init];
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive) name:
//             UIApplicationWillResignActiveNotification object:nil];
        });
	}
	return utils;
}

//+(void)askForMailIDWithType:(int)type
//{
//    NSString *title = (type == TYPE_SUBSCRIBE_FOR_OFFER) ? @"" : @"";
//    NSString *msg = (type == TYPE_SUBSCRIBE_FOR_OFFER) ? @"" : @"";
//    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:title message:msg delegate:[PromotionUtils sharedInstance] cancelButtonTitle:@"Not Now" otherButtonTitles:@"Subscribe", nil] autorelease];
//    [PromotionUtils sharedInstance]->type = type;
//    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//    [alert show];
//}

+(void)openStorePage
{
    [PromotionUtils openLinkInBrowser:ITUNES_VENDOR_LINK];
}

+(void)rateApp
{
    [Appirater rateApp];
}

+(void)aboutUS
{
    [PromotionUtils openLinkInBrowser:WEBSITE_LINK];
}

+(void)openLinkInBrowser:(NSString*)link
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
}

//pass controller for Iphone and should be nil for Ipad
+(void)askForAllFromRect:(CGRect)rect inView:(UIView*)view fromController:(UIViewController*)ctrl
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Marketting" delegate:[PromotionUtils sharedInstance] cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Rate the App", @"Our Facebook Page", @"Our Twitter Page", @"Tell a Friend",  @"About us",nil];
    [PromotionUtils sharedInstance]->presentingRect = rect;
    [PromotionUtils sharedInstance]->presentingView = [view retain];
    [PromotionUtils sharedInstance]->presentingCtr = [ctrl retain];
    [sheet showFromRect:rect inView:view animated:YES];
    [sheet release];
}

- (void)dealloc
{
    [presentingView release];
    [super dealloc];
}

+(void)tellAFriendWithMessage:(id)message fromController:(UIViewController*)ctrlr
{
    UIActivityViewController *aVC = [[UIActivityViewController alloc] initWithActivityItems:[NSArray arrayWithObject:message] applicationActivities: nil];
    aVC.excludedActivityTypes = [NSArray arrayWithObjects:UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypePrint, nil];
    [ctrlr presentModalViewController:aVC animated:YES];
    [aVC release];
}

+(void)tellAFriendWithMessage:(id)message fromRect:(CGRect)rect inView:(UIView*)view
{
    UIActivityViewController *aVC = [[UIActivityViewController alloc] initWithActivityItems:[NSArray arrayWithObject:message] applicationActivities:nil];
    aVC.excludedActivityTypes = [NSArray arrayWithObjects:UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypePrint,  nil];
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:aVC];
    [popover presentPopoverFromRect:rect inView:view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    [aVC release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"button index: %d", buttonIndex);
    switch (buttonIndex) {
        case 0:
            [PromotionUtils rateApp];
            break;
        case 1:
            [PromotionUtils openLinkInBrowser:FB_LINK];
            break;
        case 2:
            [PromotionUtils openLinkInBrowser:TWITTER_LINK];
            break;
        case 3:
            if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
                [PromotionUtils tellAFriendWithMessage:TELL_A_FRIEND_MSG fromController:[PromotionUtils sharedInstance]->presentingCtr];
            }else{
                [PromotionUtils tellAFriendWithMessage:TELL_A_FRIEND_MSG fromRect:[PromotionUtils sharedInstance]->presentingRect inView:[PromotionUtils sharedInstance]->presentingView];
            }
            break;
        case 4:
            [PromotionUtils aboutUS];
            break;
    }
}

//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 1) {
//        NSString *mailID = [alertView textFieldAtIndex:0].text;
//        NSRange range = [mailID rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"@"]];
//        if ([[mailID stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] || (range.location == NSNotFound && range.length == 0)) {
//            [alertView dismissWithClickedButtonIndex:1 animated:YES];
//            [PromotionUtils askForMailIDWithType:[PromotionUtils sharedInstance]->type];
//        }
//    }
//}


+(void)takeFeedbackFromController:(UIViewController*)controller subject:(NSString*)sub body:(NSString*)body
{
    if([MFMailComposeViewController canSendMail])
    {
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = [PromotionUtils sharedInstance];
    [mailComposer setToRecipients:[NSArray arrayWithObjects:FEEDBACK_ID, nil]];
    if (sub) {
        [mailComposer setSubject:sub];
    }else{
        [mailComposer setSubject:[NSString stringWithFormat:@"Feedback for %@", APP_NAME]];
    }
    [mailComposer setMessageBody:body isHTML:NO];
    [controller presentViewController:mailComposer animated:YES completion:nil];
    }
    else{
        
        UIAlertView *mailAlert = [[[UIAlertView alloc]initWithTitle:@"" message:@"Add Mailing Account" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]autorelease];
        [mailAlert show];
        
    }
}

+(NSString*)localizedStringWithKey:(NSString*)key
{
    return NSLocalizedString(key, nil);
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0)
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
