//
//  HistoryLotDetailViewController.m
//  RuYiCai
//
//  Created by  on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HistoryLotDetailViewController.h"
#import "RuYiCaiNetworkManager.h"
#import "LotteryDetailBigView.h"
#import "ShareSendViewController.h"
#import "TengXunSendViewController.h"
#import "NSLog.h"

#import "SSQ_PickNumberViewController.h"
#import "FC3D_PickNumberViewController.h"
#import "DLT_PickNumberViewController.h"
#import "QLC_PickNumberViewController.h"
#import "PLS_PickNumberViewController.h"
#import "PLW_PickNumberViewController.h"
#import "QXC_PickNumberViewController.h"
#import "X22_5PickNumberViewController.h"
#import "ZC_pickNumberViewController.h"
#import "ColorUtils.h"
#import "BackBarButtonItemUtils.h"
#import "ShareRightBarButtonItemUtils.h"
#import "BlockActionSheet.h"
#import "AdaptationUtils.h"

@implementation HistoryLotDetailViewController

@synthesize lotTitle = m_lotTitle;
@synthesize lotNo = m_lotNo;
@synthesize batchCode = m_batchCode;
@synthesize delegate = _delegate;
@synthesize nsLastText = m_nsLastText;
- (void)dealloc
{
    
    [m_shareButton release];
    [m_nsLastText release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self];
//    [ShareRightBarButtonItemUtils addShareRightButtonForController:self addTarget:self action:@selector(shareButtonClick:) andTitle:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetLotteryDetailOK:) name:@"GetLotteryDetailOK" object:nil];
    
    [[RuYiCaiNetworkManager sharedManager] getLotteryDetailInfo:self.lotNo batchCode:self.batchCode];//获得开奖详情
    
    [self setGoToLotteryView];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetLotteryDetailOK" object:nil];
}
- (void)GetLotteryDetailOK:(NSNotification*)notification
{
    
    NSLog(@"historyLotDetailView  GetLotteryDetailOK");
    LotteryDetailBigView*  detailView = [[LotteryDetailBigView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 75 - 45)];
    detailView.caizhongLable.text = @"足彩";
    NSLog(@"GetLotteryDetailOK self.lotTitle:%@",self.lotTitle);
    detailView.winLotTitle = self.lotTitle;
    [detailView setDetailView];
    //    [detailView setNewFrame];
    [self.view addSubview:detailView];
    
    [detailView release];
    
    //    [self setShareButton];
}

- (void)setGoToLotteryView
{
    UIView *imageBg = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 120-8-6, 480, 76)];
    imageBg.backgroundColor = [ColorUtils parseColorFromRGB:@"#F5F5F5"];
    [self.view addSubview:imageBg];
    [imageBg release];
    
    UIButton* goLotteryButton = [[UIButton alloc] initWithFrame:CGRectMake(60, [UIScreen mainScreen].bounds.size.height - 134+20, 200, 35)];
    [goLotteryButton setBackgroundImage:RYCImageNamed(@"qtz_btn.png") forState:UIControlStateNormal];
    [goLotteryButton setBackgroundImage:RYCImageNamed(@"qtz_hover_btn.png") forState:UIControlStateHighlighted];
    
    [goLotteryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    goLotteryButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    if([self.lotNo isEqualToString:kLotNoSFC] || [self.lotNo isEqualToString:kLotNoRX9] || [self.lotNo isEqualToString:kLotNoJQC] || [self.lotNo isEqualToString:kLotNoLCB])
        [goLotteryButton setTitle:@"去足彩投注" forState:UIControlStateNormal];
    else
        [goLotteryButton setTitle:[NSString stringWithFormat:@"去%@投注", [[CommonRecordStatus commonRecordStatusManager] lotNameWithLotNo:self.lotNo]]  forState:UIControlStateNormal];
    [goLotteryButton addTarget:self action:@selector(goLotteryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    goLotteryButton.enabled = YES;
    [self.view addSubview:goLotteryButton];
    [goLotteryButton release];
}

#pragma mark 跳转到选球页面
- (void)goLotteryButtonClick:(id)sender
{
    //    [MobClick event:@"openPage_go_bet"];
    [self setHidesBottomBarWhenPushed:YES];
    
    if([self.lotNo isEqualToString:kLotNoSSQ])
    {
        SSQ_PickNumberViewController *pickNumberView = [[SSQ_PickNumberViewController alloc] init];
        pickNumberView.navigationItem.title = @"双色球";
        pickNumberView.isHidePush = YES;
        [self.navigationController pushViewController:pickNumberView animated:YES];
        [pickNumberView release];
    }
    else if([self.lotNo isEqualToString:kLotNoFC3D])
    {
        FC3D_PickNumberViewController *pickNumberView = [[FC3D_PickNumberViewController alloc] init];
        pickNumberView.navigationItem.title = @"福彩3D";
        pickNumberView.isHidePush = YES;
        [self.navigationController pushViewController:pickNumberView animated:YES];
        [pickNumberView release];
    }
    else if([self.lotNo isEqualToString:kLotNoDLT])
    {
        DLT_PickNumberViewController *pickNumberView = [[DLT_PickNumberViewController alloc] init];
        pickNumberView.navigationItem.title = @"大乐透";
        pickNumberView.isHidePush = YES;
        [self.navigationController pushViewController:pickNumberView animated:YES];
        [pickNumberView release];
    }
    else if([self.lotNo isEqualToString:kLotNoQLC])
    {
        QLC_PickNumberViewController *pickNumberView = [[QLC_PickNumberViewController alloc] init];
        pickNumberView.navigationItem.title = @"七乐彩";
        pickNumberView.isHidePush = YES;
        [self.navigationController pushViewController:pickNumberView animated:YES];
        [pickNumberView release];
    }
    else if([self.lotNo isEqualToString:kLotNoPLS])
    {
        PLS_PickNumberViewController *pickNumberView = [[PLS_PickNumberViewController alloc] init];
        pickNumberView.navigationItem.title = @"排列三";
        pickNumberView.isHidePush = YES;
        [self.navigationController pushViewController:pickNumberView animated:YES];
        [pickNumberView release];
    }
    else if([self.lotNo isEqualToString:kLotNoPL5])
    {
        PLW_PickNumberViewController *pickNumberView = [[PLW_PickNumberViewController alloc] init];
        pickNumberView.navigationItem.title = @"排列五";
        pickNumberView.isHidePush = YES;
        [self.navigationController pushViewController:pickNumberView animated:YES];
        [pickNumberView release];
    }
    else if([self.lotNo isEqualToString:kLotNoQXC])
    {
        QXC_PickNumberViewController *pickNumberView = [[QXC_PickNumberViewController alloc] init];
        pickNumberView.navigationItem.title = @"七星彩";
        pickNumberView.isHidePush = YES;
        [self.navigationController pushViewController:pickNumberView animated:YES];
        [pickNumberView release];
    }
    else if([self.lotNo isEqualToString:kLotNo22_5])
    {
        X22_5PickNumberViewController *pickNumberView = [[X22_5PickNumberViewController alloc] init];
        pickNumberView.navigationItem.title = @"22选5";
        [self.navigationController pushViewController:pickNumberView animated:YES];
        [pickNumberView release];
    }
    else if([self.lotNo isEqualToString:kLotNoSFC] || [self.lotNo isEqualToString:kLotNoRX9] || [self.lotNo isEqualToString:kLotNoJQC] || [self.lotNo isEqualToString:kLotNoLCB])
    {
        ZC_pickNumberViewController *pickNumberView = [[ZC_pickNumberViewController alloc] init];
        pickNumberView.navigationItem.title = @"足彩";
        pickNumberView.isHidePush = YES;
        [self.navigationController pushViewController:pickNumberView animated:YES];
        [pickNumberView release];
    }
}

#pragma mark 分享
- (void)setShareButton
{
    m_shareButton = [[UIButton alloc] initWithFrame:CGRectMake(320-37, 345, 37, 32)];
    [m_shareButton setBackgroundImage:RYCImageNamed(@"share_c_nomal.png") forState:UIControlStateNormal];
    [m_shareButton setBackgroundImage:RYCImageNamed(@"share_c_click.png") forState:UIControlStateHighlighted];
    [m_shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //    m_shareButton.center = CGPointMake(163 + 270, [UIScreen mainScreen].bounds.size.height - 113);
    [self.view addSubview:m_shareButton];
    
    UIButton*  xinLang = [[UIButton alloc] initWithFrame:CGRectMake(58, 7, 118, 30)];
    [xinLang setBackgroundImage:RYCImageNamed(@"sina.png") forState:UIControlStateNormal];
    [xinLang addTarget:self action:@selector(sinaButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [m_shareButton addSubview:xinLang];
    [xinLang release];
    
    UIButton*  tengXun = [[UIButton alloc] initWithFrame:CGRectMake(186, 7, 118, 30)];
    [tengXun setBackgroundImage:RYCImageNamed(@"tengxun.png") forState:UIControlStateNormal];
    [tengXun addTarget:self action:@selector(tengXunButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [m_shareButton addSubview:tengXun];
    [tengXun release];
}

- (void)shareButtonClick:(id)sender
{
    BlockActionSheet *sheet = [BlockActionSheet sheetWithTitle:@"分享"];
    
    [sheet addButtonWithTitle:@"分享到新浪微博" block:^{
        [self sinaButtonClick:nil];
    }];
    [sheet addButtonWithTitle:@"分享到腾讯微博" block:^{
        [self tengXunButtonClick:nil];
    }];
//    [sheet addButtonWithTitle:@"分享到微信" block:^{
//        [self weiXinButtonClick:nil];
//    }];
//    [sheet addButtonWithTitle:@"分享到朋友圈" block:^{
//        [self weiXinFriendButtonClick:nil];
//    }];
    [sheet addButtonWithTitle:@"短信分享" block:^{
        [self phoneMessage:nil];
    }];
    [sheet setDestructiveButtonWithTitle:@"取消" block:nil];
    [sheet showInView:self.view];
    
    //    //163 + 270
    //    [UIView beginAnimations:@"movement" context:nil];
    //	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    //	[UIView setAnimationDuration:0.5f];
    //	[UIView setAnimationRepeatCount:1];
    //	[UIView setAnimationRepeatAutoreverses:NO];
    //    CGPoint buttonCenter = m_shareButton.center;
    //    if(buttonCenter.x != 163 && buttonCenter.x != 323)
    //    {
    ////        [MobClick event:@"openPage_share_button"];
    //        buttonCenter.x -= 270;
    //    }
    //    else
    //    {
    //        buttonCenter.x += 270;
    //    }
    //    m_shareButton.center = buttonCenter;
    //    [UIView commitAnimations];
}
- (void)weiXinFriendButtonClick:(id)sender
{
    //    [MobClick event:@"openPage_share_tengxun"];
    
    [self setHidesBottomBarWhenPushed:YES];
    
    [_delegate changeScene:WXSceneTimeline];
    
    TextViewController* viewController = [[TextViewController alloc] init];
    viewController.m_delegate = self;
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:
                                               [RuYiCaiNetworkManager sharedManager].responseText];
    
    if(kLotTitleSSQ == self.lotTitle || kLotTitleDLT == self.lotTitle || kLotTitleFC3D == self.lotTitle || kLotTitleQLC == self.lotTitle || kLotTitleQXC == self.lotTitle || kLotTitle22_5 == self.lotTitle)
    {
        viewController.m_nsLastText = [NSString stringWithFormat:@"#博雅彩客户端#，%@第%@期，开奖时间：%@，开奖号码：%@，本期销量：%llu元,奖池滚存：%llu元,博雅彩下载地址：%@", [[CommonRecordStatus commonRecordStatusManager] lotNameWithLotNo:self.lotNo], [parserDict objectForKey:@"batchCode"], [parserDict objectForKey:@"openTime"], [parserDict objectForKey:@"winNo"], [[parserDict objectForKey:@"sellTotalAmount"] longLongValue]/100, [[parserDict objectForKey:@"prizePoolTotalAmount"] longLongValue]/100,KAppWapDoload];
    }
    else
    {
        viewController.m_nsLastText = [NSString stringWithFormat:@"#博雅彩客户端#，%@第%@期，开奖时间：%@，开奖号码：%@，本期销量：%llu元,博雅彩下载地址：%@", [[CommonRecordStatus commonRecordStatusManager] lotNameWithLotNo:self.lotNo], [parserDict objectForKey:@"batchCode"], [parserDict objectForKey:@"openTime"], [parserDict objectForKey:@"winNo"], [[parserDict objectForKey:@"sellTotalAmount"] longLongValue]/100,KAppWapDoload];
    }
    viewController.titleStr = @"分享到朋友圈";
    //    viewController.TengXun_shareType = TX_LOTTERY_OPEN;
    [self  presentModalViewController:viewController animated:YES];
    [viewController release];
    [jsonParser release];
}

- (void)weiXinButtonClick:(id)sender
{
    //    [MobClick event:@"openPage_share_tengxun"];
    
    [self setHidesBottomBarWhenPushed:YES];
    
    [_delegate changeScene:WXSceneSession];
    
    TextViewController* viewController = [[TextViewController alloc] init];
    viewController.m_delegate = self;
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:
                                               [RuYiCaiNetworkManager sharedManager].responseText];
    
    if(kLotTitleSSQ == self.lotTitle || kLotTitleDLT == self.lotTitle || kLotTitleFC3D == self.lotTitle || kLotTitleQLC == self.lotTitle || kLotTitleQXC == self.lotTitle || kLotTitle22_5 == self.lotTitle)
    {
        viewController.m_nsLastText = [NSString stringWithFormat:@"#博雅彩客户端#，%@第%@期，开奖时间：%@，开奖号码：%@，本期销量：%llu元,奖池滚存：%llu元,博雅彩下载地址：%@", [[CommonRecordStatus commonRecordStatusManager] lotNameWithLotNo:self.lotNo], [parserDict objectForKey:@"batchCode"], [parserDict objectForKey:@"openTime"], [parserDict objectForKey:@"winNo"], [[parserDict objectForKey:@"sellTotalAmount"] longLongValue]/100, [[parserDict objectForKey:@"prizePoolTotalAmount"] longLongValue]/100,KAppWapDoload];
    }
    else
    {
        viewController.m_nsLastText = [NSString stringWithFormat:@"#博雅彩客户端#，%@第%@期，开奖时间：%@，开奖号码：%@，本期销量：%llu元,博雅彩下载地址：%@", [[CommonRecordStatus commonRecordStatusManager] lotNameWithLotNo:self.lotNo], [parserDict objectForKey:@"batchCode"], [parserDict objectForKey:@"openTime"], [parserDict objectForKey:@"winNo"], [[parserDict objectForKey:@"sellTotalAmount"] longLongValue]/100,KAppWapDoload];
    }
    viewController.titleStr = @"分享到微信";
    //    viewController.TengXun_shareType = TX_LOTTERY_OPEN;
    [self  presentModalViewController:viewController animated:YES];
    [viewController release];
    [jsonParser release];
}


- (void)sinaButtonClick:(id)sender
{
    //    [MobClick event:@"openPage_share_sinna"];
    
    [self setHidesBottomBarWhenPushed:YES];
    
    ShareSendViewController* viewController = [[ShareSendViewController alloc] init];
    
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:
                                               [RuYiCaiNetworkManager sharedManager].responseText];
    if(kLotTitleSSQ == self.lotTitle || kLotTitleDLT == self.lotTitle || kLotTitleFC3D == self.lotTitle || kLotTitleQLC == self.lotTitle || kLotTitleQXC == self.lotTitle || kLotTitle22_5 == self.lotTitle)
    {
        viewController.shareContent = [NSString stringWithFormat:@"@博雅彩，%@第%@期，开奖时间：%@，开奖号码：%@，本期销量：%llu元,奖池滚存：%llu元,博雅彩下载地址：%@", [[CommonRecordStatus commonRecordStatusManager] lotNameWithLotNo:self.lotNo], [parserDict objectForKey:@"batchCode"], [parserDict objectForKey:@"openTime"], [parserDict objectForKey:@"winNo"], [[parserDict objectForKey:@"sellTotalAmount"] longLongValue]/100, [[parserDict objectForKey:@"prizePoolTotalAmount"] longLongValue]/100,KAppWapDoload];
    }
    else
    {
        viewController.shareContent = [NSString stringWithFormat:@"@博雅彩，%@第%@期，开奖时间：%@，开奖号码：%@，本期销量：%llu元,博雅彩下载地址：%@", [[CommonRecordStatus commonRecordStatusManager] lotNameWithLotNo:self.lotNo], [parserDict objectForKey:@"batchCode"], [parserDict objectForKey:@"openTime"], [parserDict objectForKey:@"winNo"], [[parserDict objectForKey:@"sellTotalAmount"] longLongValue]/100,KAppWapDoload];
    }
    viewController.title = @"新浪微博分享";
    viewController.XinLang_shareType = XL_LOTTERY_OPEN;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
    [jsonParser release];
}
- (void)goToBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)tengXunButtonClick:(id)sender
{
    //    [MobClick event:@"openPage_share_tengxun"];
    
    [self setHidesBottomBarWhenPushed:YES];
    
    TengXunSendViewController* viewController = [[TengXunSendViewController alloc] init];
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:
                                               [RuYiCaiNetworkManager sharedManager].responseText];
    
    if(kLotTitleSSQ == self.lotTitle || kLotTitleDLT == self.lotTitle || kLotTitleFC3D == self.lotTitle || kLotTitleQLC == self.lotTitle || kLotTitleQXC == self.lotTitle || kLotTitle22_5 == self.lotTitle)
    {
        viewController.shareContent = [NSString stringWithFormat:@"@博雅彩，%@第%@期，开奖时间：%@，开奖号码：%@，本期销量：%llu元,奖池滚存：%llu元,博雅彩下载地址：%@", [[CommonRecordStatus commonRecordStatusManager] lotNameWithLotNo:self.lotNo], [parserDict objectForKey:@"batchCode"], [parserDict objectForKey:@"openTime"], [parserDict objectForKey:@"winNo"], [[parserDict objectForKey:@"sellTotalAmount"] longLongValue]/100, [[parserDict objectForKey:@"prizePoolTotalAmount"] longLongValue]/100,KAppWapDoload];
    }
    else
    {
        viewController.shareContent = [NSString stringWithFormat:@"@博雅彩，%@第%@期，开奖时间：%@，开奖号码：%@，本期销量：%llu元,博雅彩下载地址：%@", [[CommonRecordStatus commonRecordStatusManager] lotNameWithLotNo:self.lotNo], [parserDict objectForKey:@"batchCode"], [parserDict objectForKey:@"openTime"], [parserDict objectForKey:@"winNo"], [[parserDict objectForKey:@"sellTotalAmount"] longLongValue]/100,KAppWapDoload];
    }
    viewController.title = @"腾讯微博分享";
    viewController.TengXun_shareType = TX_LOTTERY_OPEN;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
    [jsonParser release];
}


#pragma mark 微信分享
-(void) onCancelText
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void) onCompleteText:(NSString*)nsText
{
    [self dismissModalViewControllerAnimated:YES];
    m_nsLastText = nsText;
    if (_delegate)
    {
        [_delegate sendTextContent:m_nsLastText] ;
    }
}


#pragma mark 短信分享

- (void)phoneMessage:(id)sender
{
    //    [MobClick event:@"openPage_share_tengxun"];
    
    [self setHidesBottomBarWhenPushed:YES];
    
    
    
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:
                                               [RuYiCaiNetworkManager sharedManager].responseText];
    
    [self sendsms:[NSString stringWithFormat:@"@博雅彩，%@第%@期，开奖时间：%@，开奖号码：%@，本期销量：%llu元,奖池滚存：%llu元,博雅彩下载地址：%@", [[CommonRecordStatus commonRecordStatusManager] lotNameWithLotNo:self.lotNo], [parserDict objectForKey:@"batchCode"], [parserDict objectForKey:@"openTime"], [parserDict objectForKey:@"winNo"], [[parserDict objectForKey:@"sellTotalAmount"] longLongValue]/100, [[parserDict objectForKey:@"prizePoolTotalAmount"] longLongValue]/100,KAppWapDoload]];
}

- (void)displaySMS:(NSString*)message
{
    MFMessageComposeViewController*picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate=self;
    //    picker.navigationBar.tintColor= [UIColor redColor];
    [picker.navigationController.navigationBar setBackground];
    picker.body= message;// 默认信息内容
    
    // 默认收件人(可多个)
    //    NSArray *numArray = [m_numTextView.text componentsSeparatedByString:@","];
    //    picker.recipients = numArray;
    //    picker.recipients = [NSArray arrayWithObjects:@"13161962673", nil];
    
    [self presentModalViewController:picker animated:YES];
    [picker release];
}



- (void)sendsms:(NSString*)message
{
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    NSLog(@"can send SMS [%d]", [messageClass canSendText]);
    NSLog(@"infor:%@",message);
    if(messageClass !=nil)
    {
        if([messageClass canSendText])
        {
            [self displaySMS:message];
        }
        else
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"设备没有短信功能!" withTitle:@"提示" buttonTitle:@"确定"];
        }
    }
    else
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"iOS版本过低，iOS4.0以上才支持程序内发送短信" withTitle:@"提示" buttonTitle:@"确定"];
    }
}
- (void)messageComposeViewController:(MFMessageComposeViewController*)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    NSLog(@"tel:::: %@", controller.recipients);
    NSString* msg;
    switch(result) {
        case MessageComposeResultCancelled:
            msg =@"发送取消";
            [[RuYiCaiNetworkManager sharedManager] showMessage:msg withTitle:@"提示" buttonTitle:@"确定"];
            break;
        case MessageComposeResultSent:
            msg =@"已发送";
            [[RuYiCaiNetworkManager sharedManager] showMessage:msg withTitle:@"提示" buttonTitle:@"确定"];
            break;
        case MessageComposeResultFailed:
            msg =@"发送失败";
            [[RuYiCaiNetworkManager sharedManager] showMessage:msg withTitle:@"提示" buttonTitle:@"确定"];
            break;
        default:
            break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
    [[[[UIApplication sharedApplication] windows] objectAtIndex:0] makeKeyWindow];
    
    [[Custom_tabbar showTabBar] hideTabBar:YES];
}

@end
