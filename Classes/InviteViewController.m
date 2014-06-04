//
//  InviteViewController.m
//  Boyacai
//
//  Created by wangxr on 14-6-3.
//
//

#import "InviteViewController.h"
#import "ActivitiesViewController.h"
#import "ColorUtils.h"
#import "RuYiCaiAppDelegate.h"
//#import <>
@interface InviteViewController ()
@property (nonatomic,retain)UILabel *inviteCodeL;

@end

@implementation InviteViewController
- (void)dealloc
{
    [super dealloc];
}
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
    self.navigationItem.title = @"邀请好友";
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    self.view = [[UIScrollView alloc]initWithFrame:self.view.frame];
    self.view.backgroundColor =  [UIColor whiteColor];//[ColorUtils parseColorFromRGB:@"#efede9"];
    ((UIScrollView*)self.view).contentSize = CGSizeMake(self.view.frame.size.width, 1000);
    UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 100, 30)];
    label1.font = [UIFont systemFontOfSize:18];
    label1.text = @"你的邀请码:";
    [self.view addSubview:label1];
    self.inviteCodeL = [[UILabel alloc]initWithFrame:CGRectMake(150, 10, 100, 30)];
    _inviteCodeL.font = [UIFont systemFontOfSize:18];
    _inviteCodeL.textColor = [UIColor colorWithRed:48.0/255 green:135.0/255 blue:0 alpha:1];
    _inviteCodeL.text = @"74823";
    [self.view addSubview:_inviteCodeL];
    
    UIButton * copyB = [UIButton buttonWithType:UIButtonTypeCustom];
    copyB.frame = CGRectMake(220, 10, 50, 30);
    [copyB setTitle:@"复制" forState:UIControlStateNormal];
    [copyB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [copyB setBackgroundColor:[ColorUtils parseColorFromRGB:@"#efede9"]];
    copyB.layer.cornerRadius = 5;
    [self.view addSubview:copyB];
    [copyB addTarget:self action:@selector(copyInviteCode) forControlEvents:UIControlEventTouchUpInside];
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 50)];
    view1.backgroundColor = [ColorUtils parseColorFromRGB:@"#efede9"];
    [self.view addSubview:view1];
    
    UIButton * inviteRecordB = [UIButton buttonWithType:UIButtonTypeCustom];
    [inviteRecordB setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    inviteRecordB.frame = CGRectMake(230, 60, 80, 30);
    [self.view addSubview:inviteRecordB];
    inviteRecordB.titleLabel.font = [UIFont systemFontOfSize:16];
    [inviteRecordB setTitle:@"邀请记录" forState:UIButtonTypeCustom];
    
}
- (void)inviteRecord
{
    
}
- (void)copyInviteCode
{
    [UIPasteboard generalPasteboard].string = _inviteCodeL.text;
}
- (void)back:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
