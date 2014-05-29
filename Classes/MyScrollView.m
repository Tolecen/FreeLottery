//
//  MyScrollView.m
//  TouchScrollView
//
//  Created by gil on 4/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyScrollView.h"


@implementation UIScrollView (my)

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!self.dragging)
    {
        [[self nextResponder] touchesBegan:touches withEvent:event];
    }
    [super touchesBegan:touches withEvent:event];
    //NSLog(@"MyScrollView touch Began");
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!self.dragging)
    {
        [[self nextResponder] touchesMoved:touches withEvent:event];
    }
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!self.dragging)
    {
        [[self nextResponder] touchesEnded:touches withEvent:event];
    }
    [super touchesEnded:touches withEvent:event];
}

@end
