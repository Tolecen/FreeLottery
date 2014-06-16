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
@synthesize nameStr,timeStr,awardStr,desStr,actType,status;
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
    [nameL setText:self.nameStr];
    
    UIView * lineV = [[UIView alloc] initWithFrame:CGRectMake(10, 60, 300, 1)];
    [lineV setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:lineV];
    [lineV release];
    
    timeL = [[UILabel alloc] initWithFrame:CGRectMake(20, 71, 240, 20)];
    [timeL setBackgroundColor:[UIColor clearColor]];
    [timeL setFont:[UIFont systemFontOfSize:15]];
    [timeL setTextColor:[UIColor grayColor]];
    [self.view addSubview:timeL];
    [timeL setText:self.timeStr];
    
    UILabel * awardL = [[UILabel alloc] initWithFrame:CGRectMake(20, 96, 280, 20)];
    [awardL setBackgroundColor:[UIColor clearColor]];
    [awardL setFont:[UIFont systemFontOfSize:16]];
    [awardL setTextColor:[UIColor redColor]];
    [self.view addSubview:awardL];
    [awardL setText:self.awardStr];
    
    NSString * myStatus;
    if ([self.actType isEqualToString:@"5"]) {
        if ([self.status isEqualToString:@"1"]) {
            myStatus = [NSString stringWithFormat:@"正在进行，已完成%@",self.awardStr];
        }
        else if ([self.status isEqualToString:@"2"]){
            myStatus = @"已完成";
        }
        else if ([self.status isEqualToString:@"4"]){
            myStatus = @"已过期";
        }
        else {
            myStatus = @"正在处理";
        }
        [awardL setText:myStatus];
    }
    
    float h = 44;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        h = 64;
    }
    NSLog(@"sreenH:%f",[UIScreen mainScreen].bounds.size.height);
    UITextView * dsTV = [[UITextView alloc] initWithFrame:CGRectMake(10, 126, 300, [UIScreen mainScreen].bounds.size.height-136-64)];
    dsTV.editable = NO;
    dsTV.scrollEnabled = YES;
    dsTV.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    dsTV.showsVerticalScrollIndicator = NO;
    dsTV.text = self.desStr;
    [dsTV setFont:[UIFont boldSystemFontOfSize:15]];
    [dsTV setTextColor:[UIColor blackColor]];
    [self.view addSubview:dsTV];

    
    
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
