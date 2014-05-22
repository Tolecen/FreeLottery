//
//  AgreementViewController.m
//  Boyacai
//
//  Created by qiushi on 13-11-11.
//
//

#import "AgreementViewController.h"
#import "AdaptationUtils.h"
#import "RuYiCaiCommon.h"

@interface AgreementViewController ()

@end

@implementation AgreementViewController

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
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        UIImageView  *navImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
        navImageView.image = [UIImage imageNamed:@"title_bg.png"];
        [self.view insertSubview:navImageView atIndex:100];
        [navImageView release];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 320, 30)];
        titleLabel.text = @"用户服务协议";
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
        titleLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:titleLabel];
        [titleLabel release];
        
        UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        registerButton.frame = CGRectMake(10, 26, 52, 30);
        
        [registerButton setBackgroundImage:[UIImage imageNamed:@"back_triangle_c_normal.png"] forState:UIControlStateNormal];
        [registerButton setBackgroundImage:[UIImage imageNamed:@"back_triangle_c_click.png"] forState:UIControlStateHighlighted];
        [registerButton setTitle:@"返回" forState:UIControlStateNormal];
        registerButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [registerButton addTarget:self action: @selector(cancelLoginClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:registerButton];
        agreeWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, 320.0f, [UIScreen mainScreen].bounds.size.height - 64)];
        agreeWebView.delegate = self;
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kRuYiCaiUserProtocol]];
        [agreeWebView loadRequest:request];
        
        [self.view addSubview:agreeWebView];
    }
    else
    {
        UIImageView  *navImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        navImageView.image = [UIImage imageNamed:@"title_bg.png"];
        [self.view insertSubview:navImageView atIndex:100];
        [navImageView release];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 320, 30)];
        titleLabel.text = @"用户服务协议";
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
        titleLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:titleLabel];
        [titleLabel release];
        
        UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        registerButton.frame = CGRectMake(10, 6, 52, 30);
        
        [registerButton setBackgroundImage:[UIImage imageNamed:@"back_triangle_c_normal.png"] forState:UIControlStateNormal];
        [registerButton setBackgroundImage:[UIImage imageNamed:@"back_triangle_c_click.png"] forState:UIControlStateHighlighted];
        [registerButton setTitle:@"返回" forState:UIControlStateNormal];
        registerButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [registerButton addTarget:self action: @selector(cancelLoginClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:registerButton];
        agreeWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, 320.0f, [UIScreen mainScreen].bounds.size.height - 64)];
        agreeWebView.delegate = self;
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kRuYiCaiUserProtocol]];
        [agreeWebView loadRequest:request];
        
        [self.view addSubview:agreeWebView];
    }
   
}

-(void)dealloc
{
    [agreeWebView release];
    [super dealloc];
}
- (void)cancelLoginClick:(id)sender
{
    [agreeWebView stopLoading];
    [self dismissModalViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
