//
//  RuYiCaiStartView.m
//  RuYiCai
//
//  Created by LiTengjie on 11-8-3.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RuYiCaiStartView.h"
#import "RYCImageNamed.h"
#import "CommonRecordStatus.h"
#import "RuYiCaiNetworkManager.h"

@implementation RuYiCaiStartView


- (id)initWithFrame:(CGRect)frame 
{    
    self = [super initWithFrame:frame];
    if (self) 
	{
		self.backgroundColor = [UIColor clearColor];
		self.hidden = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect 
{
	[super drawRect:rect];
    [[RuYiCaiNetworkManager sharedManager] readStartImgRecordPath];
    UIImage *image;
//#ifndef isBOYA
//    if([CommonRecordStatus commonRecordStatusManager].useStartImage)
//    {
//        [[RuYiCaiNetworkManager sharedManager] readStartImagePath];
//        image = [UIImage imageWithData:[CommonRecordStatus commonRecordStatusManager].startImage];
//        NSLog(@"---------img%@",image);
//    }
//	else
//    {
//	    image = RYCImageNamed(@"Default@2x.png");
//    }
//#else
    image = RYCImageNamed(@"Defaul2x.png");
//#endif
	[image drawInRect:rect];
}

- (void)dealloc 
{
    [super dealloc];
}


@end
