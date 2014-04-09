//
//  RYCProcessView.m
//  RuYiCai
//
//  Created by LiTengjie on 11-8-7.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RYCProcessView.h"

@interface RYCProcessView (Internal)
- (CGFloat)estimatedAlertViewHeight;
@end

@implementation RYCProcessView
@synthesize request = m_request;

- (void)layoutSubviews 
{
	[super layoutSubviews];
	
	CGFloat offsetY = 0.0f;
	for (UIView* view in self.subviews) 
	{
		if (![view isKindOfClass:[UIControl class]]) 
		{
			if (CGRectGetMinY(view.frame) > offsetY) 
				offsetY = CGRectGetMaxY(view.frame);
		}
	}
	
	offsetY += 20.0f;
    
	for (UIView* view in self.subviews) 
    {
		if ([view isKindOfClass:[UIControl class]]) 
        {
			CGRect viewRect = view.frame;
			viewRect.origin.y = offsetY;
			view.frame = viewRect;
		}
	}
}

- (void)show 
{
	self.transform = CGAffineTransformTranslate(self.transform, 0.0f, 0.0f);
	[super show];
}

- (void)cancel
{
	[m_request cancel];
	[self dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)setFrame:(CGRect)frame 
{
    CGFloat estimatedHeight = [self estimatedAlertViewHeight];
    if (estimatedHeight > frame.size.height)
        frame.size.height = estimatedHeight;
    
    [self layoutSubviews];
	[super setFrame:frame];
}

- (CGFloat)estimatedAlertViewHeight 
{
	CGFloat titleHeight = [self.title sizeWithFont:[UIFont boldSystemFontOfSize:17.0f] constrainedToSize:CGSizeMake(260.0f, CGFLOAT_MAX)].height;
	CGFloat messageHeight = [self.message sizeWithFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:CGSizeMake(260.0f, CGFLOAT_MAX)].height;
	
	if (titleHeight > 0)
		titleHeight += 10.0f;
	
	if (messageHeight > 0)
		messageHeight += 10.0f;
    
    return (titleHeight + messageHeight + 150.f);
}

- (void)dealloc 
{
	[m_request release];
    [super dealloc];
}

@end
