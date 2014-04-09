//
//  PullUpRefreshView.m
//  RuYiCai
//
//  Created by  on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "PullUpRefreshView.h"
#import "NSLog.h"

@implementation PullUpRefreshView

@synthesize myScrollView, textPull, textRelease, textLoading, refreshLabel, refreshDate, refreshArrow, refreshSpinner, viewMaxY;

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self)
    {
        isStart = YES;
        
//        self.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:241.0/255.0 blue:245.0/255.0 alpha:1.0];
        
        textPull = [[NSString alloc] initWithString:@"上拉加载⋯⋯"];
        textRelease = [[NSString alloc] initWithString:@"松手开始加载⋯⋯"];
        textLoading = [[NSString alloc] initWithString:@"正在加载⋯⋯"];
        
        refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 320, 20)];
        refreshLabel.backgroundColor = [UIColor clearColor];
        refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
        refreshLabel.textColor = [UIColor blackColor];
        refreshLabel.textAlignment = UITextAlignmentCenter;
        
        refreshDate = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 320, 20)];
        refreshDate.backgroundColor = [UIColor clearColor];
        refreshDate.font = [UIFont boldSystemFontOfSize:12.0];
        refreshDate.textColor = [UIColor blackColor];
        refreshDate.textAlignment = UITextAlignmentCenter;
        
        refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow2.png"]];
        refreshArrow.frame = CGRectMake((REFRESH_HEADER_HEIGHT - 27) / 2,
                                        (REFRESH_HEADER_HEIGHT - 44) / 2,
                                        27, 44);
        
        refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        refreshSpinner.frame = CGRectMake((REFRESH_HEADER_HEIGHT - 20) / 2, (REFRESH_HEADER_HEIGHT - 20) / 2, 20, 20);
        refreshSpinner.hidesWhenStopped = YES;
        
        [self addSubview:refreshLabel];
        [self addSubview:refreshDate];
        [self addSubview:refreshArrow];
        [self addSubview:refreshSpinner];
    }
    return self;
}

- (void)viewWillBeginDragging:(UIScrollView *)scrollView
{
    if (isLoading) return;
    isDragging = YES;
}

- (void)viewdidScroll:(UIScrollView *)scrollView 
{
//    NSLog(@"viewMaxY: %d", self.viewMaxY);
    if (isDragging && scrollView.contentOffset.y  > self.viewMaxY) 
	{
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        if (scrollView.contentOffset.y > self.viewMaxY + REFRESH_HEADER_HEIGHT)
		{
            // User is scrolling above the header
            self.refreshLabel.text = self.textRelease;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        }
		else 
		{ // User is scrolling somewhere within the header
            self.refreshLabel.text = self.textPull;
            
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        }
        [UIView commitAnimations];
    }
}

- (void)didEndDragging:(UIScrollView *)scrollView
{
    if (isLoading) return;
    isDragging = NO;
    
//    NSLog(@"end viewMaxY: %d", self.viewMaxY);

    if (scrollView.contentOffset.y  >= self.viewMaxY + REFRESH_HEADER_HEIGHT) 
	{
        // Released above the header
        if(isStart)
           [self startLoading];
    }
}

- (void)startLoading
{
    isLoading = YES;
    
    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.myScrollView.contentInset = UIEdgeInsetsMake(0, 0, REFRESH_HEADER_HEIGHT, 0);
    refreshLabel.text = self.textLoading;
    refreshArrow.hidden = YES;
    [refreshSpinner startAnimating];
    [UIView commitAnimations];
    
    // Refresh action!
    [[NSNotificationCenter defaultCenter]postNotificationName:@"startRefresh" object:nil];
}

- (void)stopLoading:(BOOL)isHidden
{
    isLoading = NO;
    
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    self.myScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);;
    [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    [UIView commitAnimations];
	
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *now = [dateFormatter stringFromDate:[NSDate date]];
	refreshDate.text = [NSString stringWithFormat:@"最后更新时间：%@", now];
    
    if(isHidden)
    {
        self.hidden = YES;
        isStart = !isHidden;
    }
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    // Reset the header
    refreshLabel.text = self.textPull;
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
}

- (void)refresh 
{
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:5.0];
}

- (void)setRefreshViewFrame
{
    if( myScrollView.contentSize.height > myScrollView.frame.size.height)
    {
        self.frame = CGRectMake(0, myScrollView.contentSize.height , 320, REFRESH_HEADER_HEIGHT);
    }
    else
    {
        self.frame = CGRectMake(0, myScrollView.frame.size.height , 320, REFRESH_HEADER_HEIGHT);
    }
}

- (void)dealloc 
{
    [refreshLabel release];
	[refreshDate release];
    [refreshArrow release];
    [refreshSpinner release];
    [textPull release];
    [textRelease release];
    [textLoading release];
    
	[super dealloc];
}


@end
