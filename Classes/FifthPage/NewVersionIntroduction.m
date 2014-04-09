//
//  NewVersionIntroduction.m
//  RuYiCai
//
//  Created by  on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewVersionIntroduction.h"
#import "RuYiCaiNetworkManager.h"
#import "SBJsonParser.h"
#import "CommonRecordStatus.h"
#import "BackBarButtonItemUtils.h"
#import "ColorUtils.h"
#import "AdaptationUtils.h"

@implementation NewVersionIntroduction

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"newVersionCheckOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"querySampleNetOK" object:nil];
//    [_msgTextView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    self.view.backgroundColor = [ColorUtils parseColorFromRGB:@"#efede9"];

    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    self.navigationItem.title = @"关于我们";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(querySampleNetOK:) name:@"querySampleNetOK" object:nil];
    
//    NSMutableDictionary*  dic = [NSMutableDictionary dictionaryWithCapacity:1];
//    [dic setObject:@"versionIntroduce" forKey:@"newsType"];
//    [dic setObject:@"information" forKey:@"command"];
//    [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_BASE;
//    [[RuYiCaiNetworkManager sharedManager] querySampleLotNetRequest:dic isShowProgress:YES];
    
    
    
//    self.msgTextView = [[[UITextView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height - 64 )]autorelease];
//
//    self.msgTextView.editable = NO;
//    [self.msgTextView setTextColor:[UIColor darkTextColor]];
//    [self.msgTextView setFont:[UIFont boldSystemFontOfSize:13]];
//    [self.msgTextView setBackgroundColor:[UIColor whiteColor]];
//    
//    
//    [self.view addSubview:_msgTextView];
    
//    NSString* path = [[NSBundle mainBundle] pathForResource:@"versionMessage" ofType:@"txt"];
//    NSData* proData = [NSData dataWithContentsOfFile:path];
//    NSString* proContent = [[NSString alloc] initWithData:proData encoding:NSUTF8StringEncoding];
//    self.msgTextView.text = proContent;
//    [proContent release];
    UIImageView *logImageView = [[UIImageView alloc] initWithFrame:CGRectMake(120,[UIScreen mainScreen].bounds.size.height-350-100 , 80, 80)];
    logImageView.image = [UIImage imageNamed:@"icon_retina.png"];
    [self.view addSubview:logImageView];
    [logImageView release];
    
    NSString *logStr = [NSString stringWithFormat:@"全民免费彩票 v%@",kRuYiCaiVersion];
    UILabel *logLable = [[UILabel alloc] initWithFrame:CGRectMake(80, [UIScreen mainScreen].bounds.size.height+151-400-100, 160, 30)];
    logLable.textColor = [ColorUtils parseColorFromRGB:@"#a49d8f"];
    logLable.font = [UIFont boldSystemFontOfSize:16];
    logLable.backgroundColor = [UIColor clearColor];
    [logLable setTextAlignment:NSTextAlignmentCenter];
    logLable.text = logStr;
    [self.view addSubview:logLable];
    [logLable release];
    
    //三条线
//    UIImageView *topLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20,[UIScreen mainScreen].bounds.size.height - 280, 280, 1)];
//    topLineImageView.image = [UIImage imageNamed:@"secion_c_Line.png"];
//    [self.view addSubview:topLineImageView];
//    [topLineImageView release];
    
    UIImageView *topMiddleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20,[UIScreen mainScreen].bounds.size.height - 230 , 280, 1)];
    topMiddleImageView.image = [UIImage imageNamed:@"secion_c_Line.png"];
    [self.view addSubview:topMiddleImageView];
    [topMiddleImageView release];
    
    UIImageView *topBottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20,[UIScreen mainScreen].bounds.size.height - 180 , 280, 1)];
    topBottomImageView.image = [UIImage imageNamed:@"secion_c_Line.png"];
    [self.view addSubview:topBottomImageView];
    [topBottomImageView release];
    
    
//    UILabel *qqLable = [[UILabel alloc] initWithFrame:CGRectMake(30, [UIScreen mainScreen].bounds.size.height - 270, 100, 30)];
//    qqLable.textColor = [ColorUtils parseColorFromRGB:@"#3c3c3c"];
//    qqLable.font = [UIFont systemFontOfSize:16];
//    qqLable.backgroundColor = [UIColor clearColor];
//    qqLable.text = @"官方QQ群";
//    [self.view addSubview:qqLable];
//    [qqLable release];
//    
//    UILabel *qqNumLable = [[UILabel alloc] initWithFrame:CGRectMake(200, [UIScreen mainScreen].bounds.size.height - 270, 100, 30)];
//    qqNumLable.textColor = [ColorUtils parseColorFromRGB:@"#3c3c3c"];
//    qqNumLable.font = [UIFont systemFontOfSize:16];
//    qqNumLable.backgroundColor = [UIColor clearColor];
//    qqNumLable.text = KQQNumber;
//    [self.view addSubview:qqNumLable];
//    [qqNumLable release];
    
    UIButton * updateButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    updateButton.frame=CGRectMake(20, [UIScreen mainScreen].bounds.size.height - 290, 280, 40);
    
    [updateButton setTitle:@"检查新版本" forState:UIControlStateNormal];
    updateButton.titleLabel.textColor=[UIColor grayColor];
    //    [updateButton setBackgroundImage:[UIImage imageNamed:@"常态.png"] forState:UIControlStateNormal];
    //    [updateButton setBackgroundImage:[UIImage imageNamed:@"按下.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:updateButton];
    [updateButton addTarget:self action:@selector(checkNewVersion) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UILabel *phoneLable = [[UILabel alloc] initWithFrame:CGRectMake(30, [UIScreen mainScreen].bounds.size.height - 220, 100, 30)];
    phoneLable.textColor = [ColorUtils parseColorFromRGB:@"#3c3c3c"];
    phoneLable.font = [UIFont systemFontOfSize:16];
    phoneLable.backgroundColor = [UIColor clearColor];
    phoneLable.text = @"客服热线";
    [self.view addSubview:phoneLable];
    [phoneLable release];
    
    
    UIButton *phoneNumBtn = [[UIButton alloc] initWithFrame:CGRectMake(163, [UIScreen mainScreen].bounds.size.height - 220, 150, 30)];
    [phoneNumBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    phoneNumBtn.titleLabel.font= [UIFont systemFontOfSize:16];
    [phoneNumBtn setTitle:KCustomerServiceNum forState:UIControlStateNormal];
    [phoneNumBtn addTarget:self action:@selector(phoneClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:phoneNumBtn];
    [phoneNumBtn release];
    
    
    UILabel *bottomLable = [[UILabel alloc] initWithFrame:CGRectMake(30, [UIScreen mainScreen].bounds.size.height - 150, 260, 30)];
    bottomLable.textColor = [ColorUtils parseColorFromRGB:@"#a49d8f"];
    bottomLable.font = [UIFont systemFontOfSize:14];
    bottomLable.backgroundColor = [UIColor clearColor];
    bottomLable.textAlignment = NSTextAlignmentCenter;
    bottomLable.text = @"本软件彩票运营由博雅彩票提供支持";
    [self.view addSubview:bottomLable];
    [bottomLable release];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newVersionCheckOK:) name:@"newVersionCheckOK" object:nil];
//
//    
//    
//    UILabel *websiteLable = [[UILabel alloc] initWithFrame:CGRectMake(110, [UIScreen mainScreen].bounds.size.height - 120, 105, 20)];
//    websiteLable.textColor = [ColorUtils parseColorFromRGB:@"#a49d8f"];
//    websiteLable.font = [UIFont boldSystemFontOfSize:11];
//    websiteLable.backgroundColor = [UIColor clearColor];
//    websiteLable.text = @"www.boyacai.com";
//    [self.view addSubview:websiteLable];
//    [websiteLable release];
    
}
-(void)checkNewVersion
{
    [[RuYiCaiNetworkManager sharedManager] checkNewVersion];
}
- (void)phoneClick
{
    UIDevice* device = [UIDevice currentDevice];
    NSString* deviceName = [device model];
    if([deviceName isEqualToString:@"iPad"] || [deviceName isEqualToString:@"iPod touch"])
    {
        [[RuYiCaiNetworkManager sharedManager]showMessage:@"当前设备没有打电话功能！" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    NSURL *phoneNumberURL = [NSURL URLWithString:@"telprompt://4008561000"];
    
    [[UIApplication sharedApplication] openURL:phoneNumberURL];
}
- (void)querySampleNetOK:(NSNotification*)notification
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[CommonRecordStatus commonRecordStatusManager].sampleNetStr];
    [jsonParser release];
    
//    UITextView*  contentView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 64)];
//    contentView.backgroundColor = [UIColor clearColor];
//    contentView.textColor = [UIColor blackColor];
//    contentView.font = [UIFont systemFontOfSize:15];
//    contentView.text = [parserDict objectForKey:@"introduce"];
//    contentView.editable = NO;
//    [self.view addSubview:contentView];
//    [contentView release];
    NSLog(@"－－－－－－－－%@",[parserDict objectForKey:@"introduce"]);
    self.msgTextView.text = [parserDict objectForKey:@"introduce"];
}
-(void)newVersionCheckOK:(NSNotification *)notification
{
    NSDictionary * message = notification.object;
    NSString * isUpgrade = [message objectForKey:@"isUpgrade"];
    if ([isUpgrade isEqualToString:@"1"]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"检测到有新版本\n%@",[message objectForKey:@"description"]] delegate:self cancelButtonTitle:@"暂不升级" otherButtonTitles:@"立刻升级", nil];
        alert.tag = kNewVersionAlertViewTag;
        [alert show];
        [alert release];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==kNewVersionAlertViewTag) {
        if (buttonIndex==1) {
            [self gotoUpgrade];
        }
    }
}
-(void)gotoUpgrade
{
    NSURL *url = [NSURL URLWithString:kAppStorPingFen];
    if([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)back:(id)sender
{
        [self.navigationController popViewControllerAnimated:YES];
}
    
@end
