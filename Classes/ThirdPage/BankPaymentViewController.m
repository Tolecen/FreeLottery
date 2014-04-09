//
//  BankPaymentViewController.m
//  RuYiCai
//
//  Created by 纳木 那咔 on 13-1-30.
//
//

#import "BankPaymentViewController.h"
#import "RYCImageNamed.h"
#import "AdaptationUtils.h"
#import "RuYiCaiCommon.h"
#import "BackBarButtonItemUtils.h"

@interface BankPaymentViewController ()

@end

@implementation BankPaymentViewController

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
    [AdaptationUtils adaptation:self];
    UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 7, 50, 30)];
    [backButton setBackgroundImage:RYCImageNamed(@"back_triangle_c_normal.png") forState:UIControlStateNormal];
    [backButton setBackgroundImage:RYCImageNamed(@"back_triangle_c_click.png") forState:UIControlStateHighlighted];
	[backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
	[backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    backButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [self.navigationController.navigationBar addSubview:m_backButton];
    
    if ([self.lotNo isEqualToString:kLotNoNMK3]) {
        [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO normalImage:@"KS_back_normal.png" highlightedImage:@"KS_back_highlighted.png"];
    }else{
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    }
    
    [backButton release];
    
    
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"bankPayment" ofType:@"txt"];
    NSData* proData = [NSData dataWithContentsOfFile:path];
    NSString* proContent = [[NSString alloc] initWithData:proData encoding:NSUTF8StringEncoding];
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    textView.text = proContent;
    textView.editable = NO;
    [textView setTextColor:[UIColor darkTextColor]];
    [textView setFont:[UIFont boldSystemFontOfSize:13]];
    [textView setBackgroundColor:[UIColor whiteColor]];
    
    
    [self.view addSubview:textView];
    [textView release];
    [proContent release];

}


- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    
    self.lotNo = nil;
    [super dealloc];
}

@end
