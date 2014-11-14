//
//  MyCell.m
//  4Pic1City
//
//  Created by unibera1 on 9/4/13.
//  Copyright (c) 2013 unibera. All rights reserved.
//

#import "MyCell.h"

@implementation MyCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc {
    [_cityImage release];
    [super dealloc];
}
@end
