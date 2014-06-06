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
#import "sharePlatformView.h"
@interface InviteViewController ()<sharePlatformViewDelegate>
@property (nonatomic,retain)UILabel * inviteCodeL;
@property (nonatomic,retain)UILabel * inviteRecordL;
@property (nonatomic,retain)UILabel * inviteAwardL;
@property (nonatomic,retain)UILabel * invitedAwardL;
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
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    scrollView.backgroundColor =  [UIColor whiteColor];//[ColorUtils parseColorFromRGB:@"#efede9"];
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 700);
    UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 100, 30)];
    label1.font = [UIFont systemFontOfSize:18];
    label1.text = @"你的邀请码:";
    [scrollView addSubview:label1];
    self.inviteCodeL = [[UILabel alloc]initWithFrame:CGRectMake(150, 10, 100, 30)];
    _inviteCodeL.font = [UIFont systemFontOfSize:18];
    _inviteCodeL.textColor = [UIColor colorWithRed:48.0/255 green:135.0/255 blue:0 alpha:1];
    _inviteCodeL.text = @"74823";
    [scrollView addSubview:_inviteCodeL];
    
    UIButton * copyB = [UIButton buttonWithType:UIButtonTypeCustom];
    copyB.frame = CGRectMake(220, 10, 66, 27.5);
    [copyB setTitle:@"复制" forState:UIControlStateNormal];
    [copyB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [copyB setBackgroundImage:[UIImage imageNamed:@"fuzhi"] forState:UIControlStateNormal];
    [copyB addTarget:self action:@selector(copyInviteCode) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:copyB];
    
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 50)];
    view1.backgroundColor = [ColorUtils parseColorFromRGB:@"#efede9"];
    [scrollView addSubview:view1];
    
    UIButton * inviteRecordB = [UIButton buttonWithType:UIButtonTypeCustom];
    [inviteRecordB setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    inviteRecordB.frame = CGRectMake(230, 60, 80, 30);
    [scrollView addSubview:inviteRecordB];
    inviteRecordB.titleLabel.font = [UIFont systemFontOfSize:16];
    [inviteRecordB setTitle:@"邀请记录" forState:UIButtonTypeCustom];
    
    self.inviteRecordL = [[UILabel alloc]initWithFrame:CGRectMake(10, 65, 200, 20)];
    _inviteRecordL.backgroundColor = [UIColor clearColor];
    _inviteRecordL.textColor = [UIColor grayColor];
    _inviteRecordL.font = [UIFont systemFontOfSize:14];
    _inviteRecordL.text = @"邀请好友:5\t\t奖励彩豆:500";
    [scrollView addSubview:_inviteRecordL];
    
    UIImageView * image1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 110, 18, 18)];
    image1.image = [UIImage imageNamed:@"yaoqingren"];
    [scrollView addSubview:image1];
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(40, 110, 100, 20)];
    [scrollView addSubview:label2];
    label2.text = @"邀请人奖励";
    
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 140, 310,20)];
    [scrollView addSubview:label3];
    label3.textColor = [UIColor grayColor];
    label3.font = [UIFont systemFontOfSize:12];
    label3.text = @"首次任务奖励:受邀人初测并完成下载任务获赠\t\t彩豆";
    
    self.inviteAwardL = [[UILabel alloc]initWithFrame:CGRectMake(260, 140, 40, 20)];
    [scrollView addSubview:_inviteAwardL];
    _inviteAwardL.textColor = [UIColor redColor];
    _inviteAwardL.font = [UIFont systemFontOfSize:12];
    _inviteAwardL.text = @"200";
    
    UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(10, 170, 310,20)];
    [scrollView addSubview:label4];
    label4.textColor = [UIColor grayColor];
    label4.font = [UIFont systemFontOfSize:15];
    label4.text = @"Boss模式奖励";
    
    UIImageView * image2 = [[UIImageView alloc]initWithFrame:CGRectMake(110, 172, 18, 18)];
    image2.image = [UIImage imageNamed:@"BOSS"];
    [scrollView addSubview:image2];
    
    UIImageView * image3 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 200, 293.5, 31)];
    image3.image = [UIImage imageNamed:@"jindudi"];
    [scrollView addSubview:image3];
    
    UILabel * label5 = [[UILabel alloc]initWithFrame:CGRectMake(10, 240, 300, 20)];
    [scrollView addSubview:label5];
    label5.textColor = [UIColor grayColor];
    label5.font = [UIFont systemFontOfSize:15];
    label5.text = @"0  \t\t\t  4  \t\t\t  10";
    
    UIImageView * image4 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 270, 18, 18)];
    image4.image = [UIImage imageNamed:@"shouyaoqing"];
    [scrollView addSubview:image4];
    
    UILabel * label6 = [[UILabel alloc]initWithFrame:CGRectMake(40, 270, 100, 20)];
    [scrollView addSubview:label6];
    label6.text = @"受邀人奖励";
    
    UILabel * label7 = [[UILabel alloc]initWithFrame:CGRectMake(10, 300, 310,20)];
    [scrollView addSubview:label7];
    label7.textColor = [UIColor grayColor];
    label7.font = [UIFont systemFontOfSize:12];
    label7.text = @"填写邀请码注册并完成下载任务获得\t\t彩豆奖励";
    
    self.invitedAwardL = [[UILabel alloc]initWithFrame:CGRectMake(210, 300, 40, 20)];
    [scrollView addSubview:_invitedAwardL];
    _invitedAwardL.textColor = [UIColor grayColor];
    _invitedAwardL.font = [UIFont systemFontOfSize:12];
    _invitedAwardL.text = @"200";
    
    UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 330, self.view.frame.size.width, 170)];
    view2.backgroundColor = [ColorUtils parseColorFromRGB:@"#efede9"];
    [scrollView addSubview:view2];
    
    UIImageView * image5 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 340, 18, 18)];
    image5.image = [UIImage imageNamed:@"liucheng"];
    [scrollView addSubview:image5];
    
    UILabel * label8 = [[UILabel alloc]initWithFrame:CGRectMake(40, 340, 100, 20)];
    [scrollView addSubview:label8];
    label8.text = @"推广流程";
    
    UIImageView * image6 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 370, 288, 89)];
    image6.image = [UIImage imageNamed:@"liuchengtu"];
    [scrollView addSubview:image6];
    
    UILabel * label9 = [[UILabel alloc]initWithFrame:CGRectMake(10, 470, 310,20)];
    [scrollView addSubview:label9];
    label9.textColor = [UIColor redColor];
    label9.font = [UIFont systemFontOfSize:12];
    label9.text = @"温馨提示:一定让好友在注册时填入你的邀请码";
    
    UIImageView * image7 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 510, 18, 18)];
    image7.image = [UIImage imageNamed:@"tuguang"];
    [scrollView addSubview:image7];
    
    UILabel * label10 = [[UILabel alloc]initWithFrame:CGRectMake(40, 510, 100, 20)];
    [scrollView addSubview:label10];
    label10.text = @"推广方式";
    
    UIButton * shareB = [UIButton buttonWithType:UIButtonTypeCustom];
    shareB.frame = CGRectMake(15, 540, 291, 38);
    [shareB setBackgroundImage:[UIImage imageNamed:@"huisebtn"] forState:UIControlStateNormal];
    [shareB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [shareB setTitle:@"分享" forState:UIControlStateNormal];
    [scrollView addSubview:shareB];
    [shareB addTarget:self action:@selector(shareInviteCode) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * addressB = [UIButton buttonWithType:UIButtonTypeCustom];
    addressB.frame = CGRectMake(15, 590, 291, 38);
    [addressB setBackgroundImage:[UIImage imageNamed:@"huisebtn"] forState:UIControlStateNormal];
    [addressB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [addressB setTitle:@"一键安装地址获取" forState:UIControlStateNormal];
    [scrollView addSubview:addressB];
    [addressB addTarget:self action:@selector(copyDownLoadAddress) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * twoDimensionB = [UIButton buttonWithType:UIButtonTypeCustom];
    twoDimensionB.frame = CGRectMake(15, 640, 291, 38);
    [twoDimensionB setBackgroundImage:[UIImage imageNamed:@"huisebtn"] forState:UIControlStateNormal];
    [twoDimensionB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [twoDimensionB setTitle:@"二维码扫描安装" forState:UIControlStateNormal];
    [scrollView addSubview:twoDimensionB];
    [twoDimensionB addTarget:self action:@selector(twoDimensionCode) forControlEvents:UIControlEventTouchUpInside];
}
- (void)inviteRecord
{
    
}
- (void)shareInviteCode
{
    sharePlatformView * shareV = [[sharePlatformView alloc]initWithView:self];
    shareV.delegate = self;
    [shareV showSharePlatformView];
    [shareV release];
}
-(void)sharePlatformViewPressButtonWithIntage:(NSInteger)integer
{
    
}
- (void)copyDownLoadAddress
{
    [UIPasteboard generalPasteboard].string = @"https://itunes.apple.com/cn/app/quan-min-mian-fei-cai-piao/id830055983?mt=8";
}
- (void)twoDimensionCode
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
