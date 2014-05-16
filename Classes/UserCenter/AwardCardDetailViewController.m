//
//  AwardCardDetailViewController.m
//  Boyacai
//
//  Created by Tolecen on 14-5-15.
//
//

#import "AwardCardDetailViewController.h"

@interface AwardCardDetailViewController ()

@end

@implementation AwardCardDetailViewController

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
    [timeL release];
    [nameL release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    
    
    nameL = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 20)];
    [nameL setBackgroundColor:[UIColor clearColor]];
    [nameL setTextAlignment:NSTextAlignmentCenter];
    [nameL setFont:[UIFont systemFontOfSize:20]];
    [self.view addSubview:nameL];
    [nameL setText:@"摇一摇获得18彩豆"];
    
    UIView * lineV = [[UIView alloc] initWithFrame:CGRectMake(10, 60, 300, 1)];
    [lineV setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:lineV];
    [lineV release];
    
    timeL = [[UILabel alloc] initWithFrame:CGRectMake(40, 71, 240, 20)];
    [timeL setBackgroundColor:[UIColor clearColor]];
    [timeL setFont:[UIFont systemFontOfSize:15]];
    [timeL setTextColor:[UIColor grayColor]];
    [self.view addSubview:timeL];
    [timeL setText:@"2014-5-17 摇一摇签到获得"];
    
	// Do any additional setup after loading the view.
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

@end
