//
//  AlipayPayWapView.m
//  RuYiCai
//
//  Created by  on 12-4-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WealthTenpayWapView.h"
#import "RuYiCaiNetworkManager.h"
#import "ActivityView.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"

@implementation WealthTenpayWapView

@synthesize wealthUrl = m_wealthUrl;
- (void)dealloc
{
    [m_wealthUrl release];
    mWebView.delegate = nil;
    [mWebView release];
    self.lotNo = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.lotNo isEqualToString:kLotNoNMK3]) {
        [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back) andAutoPopView:NO normalImage:@"KS_back_normal.png" highlightedImage:@"KS_back_highlighted.png"];
    }else{
        
        [BackBarButtonItemUtils addBackButtonForController:self];
    
    }
    
    [AdaptationUtils adaptation:self];
    
    m_delegate = (RuYiCaiAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [[[[UIApplication sharedApplication] windows] objectAtIndex:0] makeKeyWindow];

    mWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, [UIScreen mainScreen].bounds.size.height - 64)];
    mWebView.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:m_wealthUrl]];
    [mWebView loadRequest:request];
    
    [self.view addSubview:mWebView];
}

#pragma mark webView delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
//    ActivityView * views = [[ActivityView alloc] initWithFrame:CGRectMake(110, 150, 100, 100)];
//    views.tag = 123;
//    [self.view addSubview:views];
    
//    [views release];
    [m_delegate.activityView activityViewShow];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    [[self.view viewWithTag:123] removeFromSuperview];
    [m_delegate.activityView disActivityView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [m_delegate.activityView disActivityView];
    NSLog(@"ghghghgh");
    UIAlertView* alert =[[UIAlertView alloc]initWithTitle: [error localizedDescription]
												  message: [error localizedFailureReason]
												 delegate: nil
										cancelButtonTitle: @"确定" 
										otherButtonTitles: nil];
	[alert show];
	[alert release];
}


-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
