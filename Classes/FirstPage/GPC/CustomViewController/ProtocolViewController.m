//
//  ProtocolViewController.m
//  Boyacai
//
//  Created by fengyuting on 13-11-26.
//
//

#import "protocolViewController.h"
#import "AdaptationUtils.h"
#import "BackBarButtonItemUtils.h"
#import "ColorUtils.h"
#import "TitleViewButtonItemUtils.h"

@interface ProtocolViewController (){
    
    UIActivityIndicatorView * indicatorView;
}

@end

@implementation ProtocolViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [AdaptationUtils adaptation:self];

    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(goToBack) andAutoPopView:NO normalImage:@"KS_back_normal.png" highlightedImage:@"KS_back_highlighted.png"];
    
//    self.view.backgroundColor = [ColorUtils parseColorFromRGB:@"#004b47"];
    
    [TitleViewButtonItemUtils addTitleViewForController:self title:@"委托投注规则" font:[UIFont boldSystemFontOfSize:20.f] textColor:[ColorUtils parseColorFromRGB:@"#fcdcdc"]];

    [self addWebView];
}


-(void)addWebView{
    
    UIWebView * webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height - 64)];
    
    webView.delegate = self;
    
//    webView.backgroundColor = [UIColor clearColor];
    
//    [webView setOpaque:NO];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://test3g.boyacai.com/w3g/html/protocol.html"]]];
    
    [self.view addSubview:webView];
    
    [webView release];
}


-(void)webViewDidStartLoad:(UIWebView *)webView{
    
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    indicatorView.center = self.view.center;
    
    [self.view addSubview:indicatorView];
    
    [indicatorView startAnimating];
    
    [indicatorView release];
    
}


-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [indicatorView stopAnimating];
    
    [indicatorView removeFromSuperview];
}


- (void)goToBack
{

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
