//
//  CityDetails.h
//  4Pic1City
//
//  Created by unibera1 on 8/12/13.
//  Copyright (c) 2013 unibera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CityDetails : NSManagedObject

@property (nonatomic, retain) NSString * city_id;
@property (nonatomic, retain) NSString * city_name;
@property (nonatomic, retain) NSString * image_1;
@property (nonatomic, retain) NSString * image_2;
@property (nonatomic, retain) NSString * image_3;
@property (nonatomic, retain) NSString * image_4;

@end
