//
//  Users.h
//  4Pic1City
//
//  Created by unibera1 on 9/28/13.
//  Copyright (c) 2013 unibera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Users : NSManagedObject

@property (nonatomic, retain) id image;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * score;
@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSString * coins;

@end
