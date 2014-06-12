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
#import "EditShareContentViewController.h"
#import "InviteRecordViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "TwoDimensionCodeView.h"
#import "BDKNotifyHUD.h"
#import "RuYiCaiNetworkManager.h"
#import "JSON.h"
#import "MetionView.h"
@interface InviteViewController ()<sharePlatformViewDelegate>

@property (nonatomic,retain)NSString * inviteeCnt;
@property (nonatomic,retain)NSString * awardPea;
@property (nonatomic,retain)NSString * bossTaskInviter;
@property (nonatomic,retain)UILabel * inviteCodeL;
@property (nonatomic,retain)UILabel * inviteRecordL;
@property (nonatomic,retain)UILabel * inviteAwardL;
@property (nonatomic,retain)UILabel * invitedAwardL;
@property (nonatomic,retain)UILabel * percentL;
@property (nonatomic,retain)UIImageView * progressImg;
@end

@implementation InviteViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [AdaptationUtils adaptation:self];
    self.navigationItem.title = @"邀请好友";
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    float h = 44;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        h = 64;
    }
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - h)];
    scrollView.backgroundColor =  [UIColor whiteColor];
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 700);
    UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 100, 30)];
    label1.font = [UIFont systemFontOfSize:18];
    label1.text = @"你的邀请码:";
    [scrollView addSubview:label1];
    self.inviteCodeL = [[UILabel alloc]initWithFrame:CGRectMake(150, 10, 100, 30)];
    _inviteCodeL.font = [UIFont systemFontOfSize:18];
    _inviteCodeL.textColor = [UIColor colorWithRed:48.0/255 green:135.0/255 blue:0 alpha:1];
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
    [inviteRecordB addTarget:self action:@selector(inviteRecord) forControlEvents:UIControlEventTouchUpInside];
    
    self.inviteRecordL = [[UILabel alloc]initWithFrame:CGRectMake(10, 65, 200, 20)];
    _inviteRecordL.backgroundColor = [UIColor clearColor];
    _inviteRecordL.textColor = [UIColor grayColor];
    _inviteRecordL.font = [UIFont systemFontOfSize:14];
    [scrollView addSubview:_inviteRecordL];
    
    UIImageView * image1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 110, 18, 18)];
    image1.image = [UIImage imageNamed:@"yaoqingren"];
    [scrollView addSubview:image1];
    
    UILabel* label2 = [[UILabel alloc]initWithFrame:CGRectMake(40, 110, 100,20)];
    [scrollView addSubview:label2];
    label2.text = @"邀请人奖励";
    
    self.inviteAwardL = [[UILabel alloc]initWithFrame:CGRectMake(10, 140, 310,20)];
    [scrollView addSubview:_inviteAwardL];
    _inviteAwardL.textColor = [UIColor grayColor];
    _inviteAwardL.font = [UIFont systemFontOfSize:12];
    
    UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(10, 170, 310,20)];
    [scrollView addSubview:label4];
    label4.textColor = [UIColor grayColor];
    label4.font = [UIFont systemFontOfSize:15];
    label4.text = @"Boss模式奖励";
    
    UIImageView * image2 = [[UIImageView alloc]initWithFrame:CGRectMake(110, 172, 18, 18)];
    image2.image = [UIImage imageNamed:@"BOSS"];
    [scrollView addSubview:image2];
    
    UIButton * bossB = [UIButton buttonWithType:UIButtonTypeCustom];
    bossB.frame = CGRectMake(10, 170, 130, 20);
    [scrollView addSubview:bossB];
    [bossB addTarget:self action:@selector(showBossTaskInviter) forControlEvents:UIControlEventTouchUpInside];
    
    self.progressImg= [[UIImageView alloc]initWithFrame:CGRectMake(10, 200, 293.5, 31)];
    _progressImg.image = [UIImage imageNamed:@"jindudi"];
    [scrollView addSubview:_progressImg];
    
    self.percentL = [[UILabel alloc]initWithFrame:CGRectMake(10, 205, 100,20)];
    [scrollView addSubview:_percentL];
    _percentL.textColor = [UIColor whiteColor];
    _percentL.backgroundColor = [UIColor clearColor];
    _percentL.textAlignment = NSTextAlignmentCenter;
    _percentL.font = [UIFont systemFontOfSize:15];
    _percentL.text = @"未完成";
    
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 240, 20, 20)];
    [scrollView addSubview:label3];
    label3.textColor = [UIColor grayColor];
    label3.font = [UIFont systemFontOfSize:15];
    label3.tag = 10;
    UILabel * label5 = [[UILabel alloc]initWithFrame:CGRectMake(100, 240, 20, 20)];
    [scrollView addSubview:label5];
    label5.textColor = [UIColor grayColor];
    label5.font = [UIFont systemFontOfSize:15];
    label5.tag = 11;
    UILabel * label7 = [[UILabel alloc]initWithFrame:CGRectMake(200, 240, 20, 20)];
    [scrollView addSubview:label7];
    label7.textColor = [UIColor grayColor];
    label7.font = [UIFont systemFontOfSize:15];
    label7.tag = 12;
    
    UIImageView * image4 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 270, 18, 18)];
    image4.image = [UIImage imageNamed:@"shouyaoqing"];
    [scrollView addSubview:image4];
    
    UILabel * label6 = [[UILabel alloc]initWithFrame:CGRectMake(40, 270, 100, 20)];
    [scrollView addSubview:label6];
    label6.text = @"受邀人奖励";
    
    self.invitedAwardL = [[UILabel alloc]initWithFrame:CGRectMake(10, 300, 310,20)];
    [scrollView addSubview:_invitedAwardL];
    _invitedAwardL.textColor = [UIColor grayColor];
    _invitedAwardL.font = [UIFont systemFontOfSize:12];
    
    UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 330, self.view.frame.size.width, 170)];
    view2.backgroundColor = [ColorUtils parseColorFromRGB:@"#efede9"];
    [scrollView addSubview:view2];
    
    UIImageView * image5 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 340, 18, 18)];
    image5.image = [UIImage imageNamed:@"liucheng"];
    [scrollView addSubview:image5];
    
    UILabel * label8 = [[UILabel alloc]initWithFrame:CGRectMake(40, 340, 100, 20)];
    [scrollView addSubview:label8];
    label8.backgroundColor = [UIColor clearColor];
    label8.text = @"推广流程";
    
    UIImageView * image6 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 370, 288, 89)];
    image6.image = [UIImage imageNamed:@"liuchengtu"];
    [scrollView addSubview:image6];
    
    UILabel * label9 = [[UILabel alloc]initWithFrame:CGRectMake(10, 470, 310,20)];
    [scrollView addSubview:label9];
    label9.textColor = [UIColor redColor];
    label9.backgroundColor = [UIColor clearColor];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(promotionInviterOK:) name:@"WXPromotionInviterOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryInviteDescribeOK:) name:@"WXRQueryInviteDescribeOK" object:nil];
    [[RuYiCaiNetworkManager sharedManager] promotionInviter];
}
- (void)showBossTaskInviter
{
    MetionView * shareV = [[MetionView alloc]initWithView:self];
    [shareV showInfoText:_bossTaskInviter];
    [shareV showSharePlatformView];
    [shareV release];
}
- (void)promotionInviterOK:(NSNotification *)noti
{
    self.inviteeCnt = noti.object[@"inviteeCnt"];
    self.awardPea = noti.object[@"awardPea"];
    self.bossTaskInviter = noti.object[@"bossTaskInviter"];
    _inviteCodeL.text = noti.object[@"inviteCode"];
    _inviteRecordL.text = [NSString stringWithFormat:@"邀请好友:%d\t\t奖励彩豆:%d",[noti.object[@"inviteeCnt"] intValue],[noti.object[@"awardPea"] intValue]];
    _inviteAwardL.text = noti.object[@"firstTaskInviter"];
    _invitedAwardL.text = noti.object[@"firstTaskInvitee"];
    NSArray * array = noti.object[@"inviteProgress"];
    for (int i = 0; i<array.count; i++) {
        UILabel * label = (UILabel *)[self.view viewWithTag:i+10];
        label.text = [array[i] objectForKey:@"min"];
        if ([noti.object[@"inviteeCnt"] intValue]>[[array[i] objectForKey:@"min"] intValue]&&[noti.object[@"inviteeCnt"] intValue]<=[[array[i] objectForKey:@"max"] intValue]) {
            _progressImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"jindu%d",i+1]];
            if ([[array[i] objectForKey:@"percent"] intValue]>0) {
                _percentL.text = [NSString stringWithFormat:@"%@%%",[array[i] objectForKey:@"percent"]];
            }
            _percentL.center = CGPointMake(_percentL.center.x+i*100, _percentL.center.y);
        }
    }
}
- (void)inviteRecord
{
    InviteRecordViewController * controller = [[InviteRecordViewController alloc]init];
    controller.inviteeCnt = self.inviteeCnt;
    controller.awardPea = self.awardPea;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}
- (void)shareInviteCode
{
    sharePlatformView * shareV = [[sharePlatformView alloc]initWithView:self];
    shareV.delegate = self;
    [shareV showSharePlatformView];
    [shareV release];
}
-(void)sharePlatformView:(sharePlatformView*)shareView PressButtonWithIntage:(NSInteger)integer
{
    NSString* editString = [NSString stringWithFormat:@"每天都有5次免费中千万大奖的机会,真的不花一分钱哦！赶紧加入，土豪请绕行~~~"];
    NSString* urlString = [NSString stringWithFormat:@"http://220.231.48.232:4231/freelot/invite.jsp?ic=%@",_inviteCodeL.text];
    id<ISSContent> content = [ShareSDK content:editString
                                defaultContent:nil
                                         image:[ShareSDK jpegImageWithImage:[UIImage imageNamed:@"icon-144"] quality:1]
                                         title:@"向你推荐全民免费彩票"
                                           url:urlString
                                   description:nil
                                     mediaType:SSPublishContentMediaTypeNews];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];

    switch (integer) {
        case 1:{
            NSLog(@"新浪");
            EditShareContentViewController* editVC = [[EditShareContentViewController alloc]init];
            editVC.shareStyle = shareStyleSineWeiBo;
            editVC.contentString = [editString stringByAppendingString:urlString];;
            editVC.delegate = shareView;
            UINavigationController * controller = [[UINavigationController alloc]initWithRootViewController:editVC];
            [self presentViewController:controller animated:YES completion:nil];
            [editVC release];
            [controller release];
        }break;
        case 2:{
            NSLog(@"腾讯");
            EditShareContentViewController* editVC = [[EditShareContentViewController alloc]init];
            editVC.shareStyle = shareStyleTencentWeiBo;
            editVC.contentString = [editString stringByAppendingString:urlString];
            editVC.delegate = shareView;
            UINavigationController * controller = [[UINavigationController alloc]initWithRootViewController:editVC];
            [self presentViewController:controller animated:YES completion:nil];
            [editVC release];
            [controller release];
        }break;
        case 3:{
            NSLog(@"微信");
            [ShareSDK shareContent:content
                              type:ShareTypeWeixiSession
                       authOptions:authOptions
                     statusBarTips:YES
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSPublishContentStateSuccess)
                                {
                                    [shareView canclesharePlatformView];
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                        message:[NSString stringWithFormat:@"发送失败!%@", [error errorDescription]]
                                                                                       delegate:nil
                                                                              cancelButtonTitle:@"知道了"
                                                                              otherButtonTitles:nil];
                                    [alertView show];
                                    [alertView release];
                                }
                            }];
        }break;
        case 4:{
            NSLog(@"朋友圈");
            [ShareSDK shareContent:content
                              type:ShareTypeWeixiTimeline
                       authOptions:authOptions
                     statusBarTips:YES
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSPublishContentStateSuccess)
                                {
                                    [shareView canclesharePlatformView];
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                        message:[NSString stringWithFormat:@"发送失败!%@", [error errorDescription]]
                                                                                       delegate:nil
                                                                              cancelButtonTitle:@"知道了"
                                                                              otherButtonTitles:nil];
                                    [alertView show];
                                    [alertView release];
                                }
                            }];
        }break;
        case 5:{
            NSLog(@"qq空间");
            [ShareSDK shareContent:content
                              type:ShareTypeQQ
                       authOptions:authOptions
                     statusBarTips:YES
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSPublishContentStateSuccess)
                                {
                                    [shareView canclesharePlatformView];
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                        message:[NSString stringWithFormat:@"发送失败!%@", [error errorDescription]]
                                                                                       delegate:nil
                                                                              cancelButtonTitle:@"知道了"
                                                                              otherButtonTitles:nil];
                                    [alertView show];
                                    [alertView release];
                                }
                            }];
        }break;
        case 6:{
            NSLog(@"人人");
            EditShareContentViewController* editVC = [[EditShareContentViewController alloc]init];
            editVC.shareStyle = shareStylerenren;
            editVC.contentString = [editString stringByAppendingString:urlString];
            editVC.delegate = shareView;
            editVC.url = urlString;
            UINavigationController * controller = [[UINavigationController alloc]initWithRootViewController:editVC];
            [self presentViewController:controller animated:YES completion:nil];
            [editVC release];
            [controller release];
        }break;
        default:
            break;
    }
}
- (void)copyDownLoadAddress
{
    [UIPasteboard generalPasteboard].string = @"https://itunes.apple.com/cn/app/quan-min-mian-fei-cai-piao/id830055983?mt=8";
    BDKNotifyHUD* bdkHUD = [BDKNotifyHUD notifyHUDWithImage:[UIImage imageNamed:@"Checkmark.png"] text:@"已复制到剪切板"];
    
    bdkHUD.center = CGPointMake([UIApplication sharedApplication].keyWindow.center.x, [UIApplication sharedApplication].keyWindow.center.y - 20);
    [[UIApplication sharedApplication].keyWindow addSubview:bdkHUD];
    [bdkHUD presentWithDuration:1.5f speed:0.5f inView:nil completion:^{
        [bdkHUD removeFromSuperview];
    }];
}
- (void)twoDimensionCode
{
    TwoDimensionCodeView * view = [[TwoDimensionCodeView alloc]initWithView:self];
    [view showSharePlatformView];
    [view release];
}
- (void)copyInviteCode
{
    if (_inviteCodeL.text.length>0) {
        [UIPasteboard generalPasteboard].string = _inviteCodeL.text;
        BDKNotifyHUD* bdkHUD = [BDKNotifyHUD notifyHUDWithImage:[UIImage imageNamed:@"Checkmark.png"] text:@"已复制到剪切板"];
        
        bdkHUD.center = CGPointMake([UIApplication sharedApplication].keyWindow.center.x, [UIApplication sharedApplication].keyWindow.center.y - 20);
        [[UIApplication sharedApplication].keyWindow addSubview:bdkHUD];
        [bdkHUD presentWithDuration:1.5f speed:0.5f inView:nil completion:^{
            [bdkHUD removeFromSuperview];
        }];
    }
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
