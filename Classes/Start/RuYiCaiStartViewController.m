//
//  RuYiCaiStartViewController.m
//  RuYiCai
//
//  Created by LiTengjie on 11-8-3.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
/*
 开机加载页面 用于显示 loading 图片 以及 启动 新功能介绍页面
 */
#import "RuYiCaiStartViewController.h"
#import "RuYiCaiStartView.h"
#import "RuYiCaiCommon.h"
#import "NewFuctionIntroductionView.h"
#import "CommonRecordStatus.h"
#import "AdaptationUtils.h"
#import <AdSupport/AdSupport.h>

@implementation RuYiCaiStartViewController
#define kStartViewShowTime  (5.0f) //开机页面 显示时长
- (void)viewDidLoad 
{
    [super viewDidLoad];
	[AdaptationUtils adaptation:self];
	self.view.backgroundColor = [UIColor clearColor];
	m_startView = [[RuYiCaiStartView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	m_startView.hidden = NO;
	[self.view insertSubview:m_startView atIndex:0];
    
    m_delegate = (RuYiCaiAppDelegate*)[[UIApplication sharedApplication] delegate];
    [self performSelector:@selector(showLoading:) withObject:nil afterDelay:kStartViewShowTime];
    
}

- (void)showLoading:(id)sender
{
    [m_startView removeFromSuperview];
    
    //卸载重装 去除闹钟
    if(![[NSUserDefaults standardUserDefaults] objectForKey:kLotteryBetWarnKey])
    {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
    
    //读取文件中的字段
    [m_delegate readUserPlist];
    //安装后 首次进入 才有 
    if ([m_delegate isShowNewFuctionInfo])
    {
        [m_delegate showLoading:nil];
    }
    else
    {
        //调用 新功能介绍页面
        NewFuctionIntroductionView* m_newFuctionInfoView = [[NewFuctionIntroductionView alloc] initWithFrame:[[UIScreen mainScreen] bounds] FirstTime:YES];
        m_newFuctionInfoView.hidden = NO;
        m_newFuctionInfoView.delegate = m_delegate;
        [self.view addSubview:m_newFuctionInfoView];
        [m_newFuctionInfoView release];
        if([appStoreORnormal isEqualToString: @"appStore"])
        {
            NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
            NSLog(@" --------------adIdadId =%@",adId);
            UIAlertView*  alter = [[UIAlertView alloc] 
                                   initWithTitle:@"尊敬的用户" 
                                   message:@"博雅彩客户端将访问您的设备识别符" 
                                   delegate:self 
                                   cancelButtonTitle:@"确定" 
                                   otherButtonTitles:nil];
            [alter show];
            [alter release];
        }
        
        //初始化彩种显示数组
        [[CommonRecordStatus commonRecordStatusManager] setLotShowArray];
        [[CommonRecordStatus commonRecordStatusManager] setLotteryShowArray];
        [[CommonRecordStatus commonRecordStatusManager] defaultOrderLottery];
        [[CommonRecordStatus commonRecordStatusManager] setPayStationArray];

        //初始化 广告图片
        [[CommonRecordStatus commonRecordStatusManager] initADimage];
        //初始化购买彩种提醒状态字典，增加新彩种时的需要
//        [[CommonRecordStatus commonRecordStatusManager] setLottoryBetWarnDic];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
}

- (void)dealloc 
{
	[m_startView release];
	[super dealloc];
}
@end