//
//  AlipayPayWapView.m
//  RuYiCai
//
//  Created by  on 12-4-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AlipayPayWapView.h"
#import "RuYiCaiNetworkManager.h"
#import "ActivityView.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"

@implementation AlipayPayWapView

- (void)dealloc
{
    mWebView.delegate = nil;
    [mWebView release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self];
    
    m_delegate = (RuYiCaiAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [[[[UIApplication sharedApplication] windows] objectAtIndex:0] makeKeyWindow];

    mWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, [UIScreen mainScreen].bounds.size.height - 64)];
    mWebView.delegate = self;
    NSLog(@"%@", [RuYiCaiNetworkManager sharedManager].responseText);
    
    NSURL *requestUrl = [NSURL URLWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
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

@end
