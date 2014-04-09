//
//  InLetterContentViewController.m
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 12-12-19.
//
//

#import "InLetterContentViewController.h"
#import "RYCImageNamed.h"
#import "AdaptationUtils.h"

@interface InLetterContentViewController ()

- (void)setMainView;

@end

@implementation InLetterContentViewController

@synthesize inTitle = m_inTitle;
@synthesize content = m_content;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    self.view.backgroundColor = [UIColor colorWithPatternImage:RYCImageNamed(@"table_beijing.png")];
    
    self.title = @"站内信";
    [self setMainView];
}

- (void)setMainView
{
    UIImageView *image_topbg = [[UIImageView alloc] initWithFrame:CGRectMake(9, 10, 302, 12)];
    image_topbg.image = RYCImageNamed(@"croner_top.png");
    [self.view addSubview:image_topbg];
    [image_topbg release];
    
    UIImageView *image_middlebg = [[UIImageView alloc] init];
    image_middlebg.image = RYCImageNamed(@"croner_middle.png");
    [self.view addSubview:image_middlebg];
    
    CGSize titleSize = [self.inTitle sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(280, 200) lineBreakMode:UILineBreakModeTailTruncation];
    
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 280, titleSize.height)];
    myLabel.textAlignment = UITextAlignmentCenter;
    myLabel.lineBreakMode = UILineBreakModeTailTruncation;
    myLabel.numberOfLines = titleSize.height/19;
    myLabel.text = self.inTitle;
    [myLabel setTextColor:[UIColor colorWithRed:108.0/255.0 green:59.0/255.0 blue:59.0/255.0 alpha:1.0]];
    myLabel.backgroundColor = [UIColor clearColor];
    myLabel.font = [UIFont systemFontOfSize:15];
    [image_middlebg addSubview:myLabel];
    
    image_middlebg.frame = CGRectMake(9, 20, 302, myLabel.frame.origin.y + myLabel.frame.size.height + 5);
    
    [myLabel release];
    
    UIImageView *image_bottombg = [[UIImageView alloc] initWithFrame:CGRectMake(9, image_middlebg.frame.origin.y + image_middlebg.frame.size.height, 302, [UIScreen mainScreen].bounds.size.height - 74 - image_middlebg.frame.origin.y - image_middlebg.frame.size.height)];
    image_bottombg.image = RYCImageNamed(@"reply_bottom.png");
    [self.view addSubview:image_bottombg];
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(10, image_bottombg.frame.origin.y + 2, 300, image_bottombg.frame.size.height - 5)];
    webView.layer.cornerRadius = 8;
    webView.layer.masksToBounds = YES;
    UIScrollView *scroller = [webView.subviews objectAtIndex:0];//去掉阴影
    if (scroller) {
        for (UIView *v in [scroller subviews]) {
            if ([v isKindOfClass:[UIImageView class]]) {
                [v removeFromSuperview];
            }
        }
    }
    webView.delegate = self;
    webView.backgroundColor = [UIColor clearColor];
    [webView loadHTMLString:self.content baseURL:nil];
    [self.view addSubview:webView];
    [webView release];
    
    [image_middlebg release];
    [image_bottombg release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
