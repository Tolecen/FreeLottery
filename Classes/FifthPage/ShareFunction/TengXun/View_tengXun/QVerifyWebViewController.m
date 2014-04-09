//
//  QVerifyWebViewController.m
//  QWeiboSDK4iOSDemo
//
//  Created   on 11-1-14.
//   
//

#import "QVerifyWebViewController.h"
#import "RuYiCaiAppDelegate.h"
#import "QWeiboSyncApi.h"
#import "RuYiCaiNetworkManager.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"

#define kQWBSDKAppKey   @"801390953"
#define kQWBSDKAppSecret   @"4eea35f2b342fd0bd7c2bac4c513c2e8"

#define VERIFY_URL @"http://open.t.qq.com/cgi-bin/authorize?oauth_token="

@implementation QVerifyWebViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self];
    
    
    [[[[UIApplication sharedApplication] windows] objectAtIndex:0] makeKeyWindow];

	mWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)];
	mWebView.delegate = self;
	[self.view addSubview:mWebView];
    
	RuYiCaiAppDelegate *appDelegate = 
		(RuYiCaiAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSString *url = [NSString stringWithFormat:@"%@%@", VERIFY_URL, appDelegate.tokenKey];
	NSURL *requestUrl = [NSURL URLWithString:url];
	NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
	[mWebView loadRequest:request];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [mWebView release];
    mWebView = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark private methods

-(NSString*) valueForKey:(NSString *)key ofQuery:(NSString*)query
{
	NSArray *pairs = [query componentsSeparatedByString:@"&"];
	for(NSString *aPair in pairs){
		NSArray *keyAndValue = [aPair componentsSeparatedByString:@"="];
		if([keyAndValue count] != 2) continue;
		if([[keyAndValue objectAtIndex:0] isEqualToString:key]){
			return [keyAndValue objectAtIndex:1];
		}
	}
	return nil;
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
	
	NSString *query = [[request URL] query];
	NSString *verifier = [self valueForKey:@"oauth_verifier" ofQuery:query];
	NSLog(@"verifier:%@", verifier);
    
    RuYiCaiAppDelegate *appDelegate = 
    (RuYiCaiAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	if (verifier && ![verifier isEqualToString:@""]) //授权成功
    {
        QWeiboSyncApi *api = [[[QWeiboSyncApi alloc] init] autorelease];
		NSString *retString = [api getAccessTokenWithConsumerKey:kQWBSDKAppKey								 consumerSecret:kQWBSDKAppSecret
												 requestTokenKey:appDelegate.tokenKey 
											  requestTokenSecret:appDelegate.tokenSecret 
														  verify:verifier];
		NSLog(@"\nget access token:%@", retString);
		[appDelegate parseTokenKeyWithResponse:retString];
		[appDelegate saveDefaultKey];
		
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"登录成功！" withTitle:@"提示" buttonTitle:@"确定"];
		[self.navigationController popViewControllerAnimated:YES];
		return NO;
	}
    return YES;
}

@end
