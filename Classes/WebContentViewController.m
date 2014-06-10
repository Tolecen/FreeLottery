//
//  WebContentViewController.m
//  Boyacai
//
//  Created by Tolecen on 14-6-9.
//
//

#import "WebContentViewController.h"

@interface WebContentViewController ()

@end

@implementation WebContentViewController
@synthesize webType;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc
{
    [agreeWebView release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [ColorUtils parseColorFromRGB:@"#efede9"];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    if (webType==1) {
        self.navigationItem.title = @"赚豆秘籍";
    }
    else
        self.navigationItem.title = @"网页内容";
    
    float h = 0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        h = 64;
    }
    else
        h = 44;
    agreeWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, [UIScreen mainScreen].bounds.size.height - h)];
    agreeWebView.delegate = self;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:GetBeanURL]];
    [agreeWebView loadRequest:request];
    
    [self.view addSubview:agreeWebView];
	// Do any additional setup after loading the view.
}
-(void)back:(UIButton *)sender
{
    [agreeWebView stopLoading];
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
