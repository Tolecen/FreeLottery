    //
//  BaseHelpViewController.m
//  RuYiCai
//
//  Created by LiTengjie on 11-10-4.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BaseHelpViewController.h"
#import "Custom_tabbar.h"
#import "NSLog.h"
#import "AdaptationUtils.h"

@implementation BaseHelpViewController

@synthesize htmlFileName = m_htmlFileName;

- (void)dealloc 
{
    m_webView.delegate = nil;
	[m_webView release];
    [super dealloc];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	[AdaptationUtils adaptation:self];
	CGRect webFrame = [[UIScreen mainScreen] bounds];
	m_webView = [[UIWebView alloc] initWithFrame:webFrame];
	m_webView.backgroundColor = [UIColor whiteColor];
	m_webView.scalesPageToFit = NO;
	m_webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	m_webView.delegate = self;
	[self.view addSubview:m_webView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setHidesBottomBarWhenPushed:YES];
    [[Custom_tabbar showTabBar] hideTabBar:YES];
}

- (void)refresh
{
    NSString* path = [[NSBundle mainBundle] pathForResource:self.htmlFileName ofType:@"html"];
    NSData* htmldata = [NSData dataWithContentsOfFile:path];
    NSString* htmlcontent = [[NSString alloc] initWithData:htmldata encoding:NSUTF8StringEncoding];
    NSString *imagePath  = [[NSBundle mainBundle] bundlePath];
    [m_webView loadHTMLString:htmlcontent baseURL:[NSURL fileURLWithPath:imagePath]];
	[htmlcontent release];
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	NSLog(@"web: start load %@", [webView.request description]);
	
	// starting the load, show the activity indicator in the status bar
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	NSLog(@"web: loading failed");
}

- (BOOL)webView:(UIWebView *)webViewLocal shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType 
{
	NSString *myURL = [[request URL] absoluteString];
    if([myURL hasPrefix:@"safari:"]) 
	{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:(NSString *)[myURL substringFromIndex:[@"safari:" length]]]];
        return NO;            
    }
	return YES;
}


@end