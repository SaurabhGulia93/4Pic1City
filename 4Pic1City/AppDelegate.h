//
//  AppDelegate.h
//  4Pic1City
//
//  Created by unibera1 on 8/5/13.
//  Copyright (c) 2013 unibera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Flurry.h"
#import "FlurryAds.h"
#import "Appirater.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;
+(NSManagedObjectContext *)getcontext;
+ (void) populateDrugsInManagedObjectContext:(NSManagedObjectContext *)context;

@end
