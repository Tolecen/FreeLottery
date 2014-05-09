//
//  FifthPageViewController.m
//  RuYiCai
//
//  Created by LiTengjie on 11-9-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FifthPageViewController.h"
#import "RYCImageNamed.h"
#import "RuYiCaiNetworkManager.h"
#import "RuYiCaiCommon.h"
#import "RYCImageNamed.h"
#import "UserCenterTableViewCell.h"
#import "UINavigationBarCustomBg.h"
#import "LotterPeopleZoneViewController.h"

#import "NewVersionIntroduction.h"
#import "CaipiaoInformationViewController.h"
#import "FourthPageViewController.h"
#import "ActionCenterViewController.h"

#import "BaseHelpViewController.h"
#import "NSLog.h"
#import "Custom_tabbar.h"
#import "FeedBackViewController.h"
#import "SetupViewController.h"
#import "CommonRecordStatus.h"

#import "SetViewController.h"
#import "HelpViewController.h"

#import "XinShouZhiNanViewController.h"
#import "RankingViewController.h"
#import "RankingMainViewController.h"
#import "LuckViewController.h"
#import "LotteryBetWarnViewController.h"
#import "ColorUtils.h"
#import "NewMoreCell.h"
#import "AdaptationUtils.h"

@interface FifthPageViewController ()

- (void)setTableTopView;
- (void)keFuTelClick:(id)sender;

@end

@implementation FifthPageViewController

@synthesize myTableView = m_myTableView;
@synthesize shareviewController = _shareviewController;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"userLoginOK2" object:nil];
    
    [m_myTableView release], m_myTableView = nil;
    [_shareviewController release];
    
    [super dealloc];
}
-(void) onShowMediaMessage:(WXMediaMessage *) message
{
    // 微信启动， 有消息内容。
    [self viewContent:message];
}

- (id)init{
    if(self = [super init]){
        _scene = WXSceneSession;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"更多";
    [AdaptationUtils adaptation:self];
    [self.navigationController.navigationBar setBackground];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginOK2:) name:@"userLoginOK2" object:nil];
    self.view.backgroundColor = [ColorUtils parseColorFromRGB:@"#efede9"];
    
    m_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 2, 320, [UIScreen mainScreen].bounds.size.height - 20) style:UITableViewStylePlain];
    m_myTableView.backgroundView = [[[UIView alloc]init] autorelease];
    m_myTableView.backgroundColor = [UIColor clearColor];
    m_myTableView.delegate = self;
    m_myTableView.dataSource = self;
    m_myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    m_myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    m_myTableView.separatorColor = [UIColor lightGrayColor];
    [self.view addSubview:m_myTableView];
    
    //    [self setTableTopView];
    
    m_delegate = (RuYiCaiAppDelegate*)[[UIApplication sharedApplication] delegate];
    [RuYiCaiNetworkManager sharedManager].fifthViewController = self;
}

- (void)setTableTopView
{
    UIImageView *image_topbg = [[UIImageView alloc] initWithFrame:CGRectMake(9, -60, 302, 12)];
    image_topbg.image = RYCImageNamed(@"croner_top.png");
    [self.myTableView addSubview:image_topbg];
    [image_topbg release];
    
    UIImageView *image_midbg = [[UIImageView alloc] initWithFrame:CGRectMake(9, -48, 302, 26)];
    image_midbg.image = RYCImageNamed(@"croner_middle.png");
    [self.myTableView addSubview:image_midbg];
    
    UIImageView* image_kefu = [[UIImageView alloc] initWithFrame:CGRectMake(8, 3, 20, 20)];
    image_kefu.image = RYCImageNamed(@"kfdh_icon.png");
    [image_midbg addSubview:image_kefu];
    [image_kefu release];
    
    UILabel*  titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(41, 0, 100, 26)];
    titleLabel.text = @"客服电话";
    titleLabel.textAlignment = UITextAlignmentLeft;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [image_midbg addSubview:titleLabel];
    [titleLabel release];
    
    [image_midbg release];
    
    UIButton*  telButton = [UIButton buttonWithType:UIButtonTypeCustom];
    telButton.frame = CGRectMake(9, -60, 302, 50);
    [telButton setBackgroundColor:[UIColor clearColor]];
    [telButton addTarget:self action:@selector(keFuTelClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.myTableView addSubview:telButton];
    
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"gdphone_biao.png"]];
    imageV.frame = CGRectMake(155, 12, 135, 26);
    [telButton addSubview:imageV];
    [imageV release];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self setHidesBottomBarWhenPushed:YES];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self setHidesBottomBarWhenPushed:YES];
    [super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setHidesBottomBarWhenPushed:YES];
    [[Custom_tabbar showTabBar] hideTabBar:NO];
    UILabel *label = [[[UILabel alloc] init] autorelease];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:label] autorelease]; //消掉系统的按钮
    
    /*每次进来刷新活动中心的正在进行活动的数量*/
    NSIndexPath *updatapath = [NSIndexPath indexPathForRow:1 inSection:0];
    NSArray *updatapaths = [NSArray arrayWithObject:updatapath];
    [self.myTableView reloadRowsAtIndexPaths:updatapaths withRowAnimation:NO];
}

//- (void)loginClick
//{
//    [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_LOGIN;
//    [[RuYiCaiNetworkManager sharedManager] showLoginAlertView];
//}

//- (void)changeUserClick
//{
//    [[RuYiCaiNetworkManager sharedManager] showChangeUserAlertView];
//}

- (void)userLoginOK2:(NSNotification*)notification
{
    //    if([RuYiCaiNetworkManager sharedManager].netAppType == NET_APP_FEED_BACK)
    //    {
    //        [MobClick event:@"morePage_leave_message"];
    //        [[Custom_tabbar showTabBar] hideTabBar:YES];
    //        [self setHidesBottomBarWhenPushed:YES];
    //        FeedBackViewController* viewController = [[FeedBackViewController alloc] init];
    //        viewController.title = @"留言反馈";
    //        [self.navigationController pushViewController:viewController animated:YES];
    //        [viewController release];
    //    }
    //    else if([RuYiCaiNetworkManager sharedManager].netAppType == NET_APP_HELP_SET)
    //    {
    //        [[Custom_tabbar showTabBar] hideTabBar:YES];
    //        [self setHidesBottomBarWhenPushed:YES];
    //        SetViewController* viewController = [[SetViewController alloc] init];
    //        viewController.navigationItem.title = @"设置";
    //        [self.navigationController pushViewController:viewController animated:YES];
    //        [viewController release];
    //    }
}

#pragma mark UITableView delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 11;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *myIdentifier = @"MyIdentifier";
    NewMoreCell *cell = (NewMoreCell*)[tableView dequeueReusableCellWithIdentifier:myIdentifier];
    if (cell == nil)
    {
        cell = [[[NewMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.numberLable.text=@"400-856-1000";
    cell.subLable.text = @"（24小时客服热线）";
    cell.accessoryType = UITableViewCellAccessoryNone;
    //cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
    NSUInteger rowIndex = [indexPath row];
    if (0 == rowIndex)
    {
        cell.titleLable.text = @"客服电话";
        [cell.numberLable setHidden:NO];
        [cell.subLable setHidden:NO];
    }
    else if(0!=rowIndex)
    {
        [cell.numberLable setHidden:YES];
        [cell.subLable setHidden:YES];
    }
    if (1 == rowIndex)
    {
        cell.titleLable.text  = @"中奖排行";
    }
    else if (2 == rowIndex)
    {
        cell.titleLable.text  = @"幸运选号";
    }
    else if (3 == rowIndex)
    {
        cell.titleLable.text  = @"彩民专区";
    }
    else if (4 == rowIndex)
    {
        //cell.title = @"登录设置";
        //cell.imageView.image = RYCImageNamed(@"setupico.png");
        cell.titleLable.text = @"活动中心";
        //            cell.imageViewRight.image = RYCImageNamed(@"fuction_new.png");
        //            if([[CommonRecordStatus commonRecordStatusManager].inProgressActivityCount intValue] > 0)
        //            {
        //                 cell.isHaveImageRight = YES;
        //            }
        //            else
        //            {
        //                 cell.isHaveImageRight = NO;
        //            }
    }
    else if(5 == rowIndex)
    {
        cell.titleLable.text = @"帮助中心";
    }
    //        else if(5 == rowIndex)
    //        {
    //            cell.title = @"彩种购买提醒设置";
    //            cell.imageView.image = RYCImageNamed(@"gd_sz_icon.png");
    //        }
    else if(6 == rowIndex)
    {
        cell.titleLable.text = @"我要反馈";
        
    }
    
    if(7 == rowIndex)
    {
        cell.titleLable.text = @"新手指南";
    }
    else if(8 == rowIndex)
    {
        cell.titleLable.text = @"分享";
    }
    //        else if(1 == rowIndex)
    //        {
    //            cell.title = @"亲，给个好评吧！";
    //            cell.imageView.image = RYCImageNamed(@"more_pingjia.png");
    //        }
    else if (9 == rowIndex)
    {
        cell.titleLable.text = @"设置";
        
    }
    else if (10 == rowIndex)
    {
        cell.titleLable.text = @"关于";
        cell.accessoryImageView.frame = CGRectMake(0, 0, 320, 39);
    }
    if (10 != rowIndex) {
        cell.accessoryImageView.frame = CGRectMake(0, 0, 320, 42);
    }
    
    //    [cell refresh];
    return cell;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewMoreCell *Aircell = (NewMoreCell *)[tableView cellForRowAtIndexPath:indexPath];
    Aircell.accessoryImageView.image = [UIImage imageNamed:@"cell_c_gengduo_click.png"];
    
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}
- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewMoreCell *Aircell = (NewMoreCell *)[tableView cellForRowAtIndexPath:indexPath];
    Aircell.accessoryImageView.image = [UIImage imageNamed:@"cell_c_gengduo.png"];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSIndexPath *currentSelectedIndexPath = [self.myTableView indexPathForSelectedRow];
    if (currentSelectedIndexPath != nil)
    {
        NewMoreCell *Aircell = (NewMoreCell *)[tableView cellForRowAtIndexPath:currentSelectedIndexPath];
        Aircell.accessoryImageView.image = [UIImage imageNamed:@"cell_c_gengduo.png"];
        [self.myTableView deselectRowAtIndexPath:currentSelectedIndexPath animated:NO];
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == 0)
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
    else if ([indexPath row] == 1)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
//        RankingViewController* viewController = [[RankingViewController alloc] init];
        
        RankingMainViewController *viewController = [[RankingMainViewController alloc]init];

        viewController.title = @"中奖排行";
        [RuYiCaiNetworkManager sharedManager].isRefreshUserCenter = YES;
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
    else if ([indexPath row] == 2)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
        LuckViewController* viewController = [[LuckViewController alloc] init];
        viewController.title = @"幸运选号";
        [RuYiCaiNetworkManager sharedManager].isRefreshUserCenter = YES;
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
    else if ([indexPath row] == 3)
    {
        //            [MobClick event:@"morePage_caiPiao_information"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
        
        //        CaipiaoInformationViewController* viewController = [[CaipiaoInformationViewController alloc] init];
        //        viewController.title = @"彩民专区";
        //        [RuYiCaiNetworkManager sharedManager].isRefreshUserCenter = YES;
        //        [self.navigationController pushViewController:viewController animated:YES];
        //        [viewController release];
        
        LotterPeopleZoneViewController *viewController = [[LotterPeopleZoneViewController alloc]init];
        viewController.title = @"彩民专区";
        [RuYiCaiNetworkManager sharedManager].isRefreshUserCenter = YES;
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
        
        
    }else if([indexPath row] == 4)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
        
        ActionCenterViewController *viewController = [[ActionCenterViewController alloc] init];
        viewController.title = @"活动中心";
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
    else if([indexPath row] == 5)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
        
        HelpViewController *viewController = [[HelpViewController alloc] init];
        viewController.title = @"帮助中心";
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
        
    }
    else if([indexPath row] == 6)
    {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
        FeedBackViewController* viewController = [[FeedBackViewController alloc] init];
        viewController.title = @"我要反馈";
        viewController.isPushHid = NO;
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
        
//        if([RuYiCaiNetworkManager sharedManager].hasLogin)
//        {
//            //                    [MobClick event:@"morePage_leave_message"];
//            
//            [[Custom_tabbar showTabBar] hideTabBar:YES];
//            [self setHidesBottomBarWhenPushed:YES];
//            FeedBackViewController* viewController = [[FeedBackViewController alloc] init];
//            viewController.title = @"我要反馈";
//            [self.navigationController pushViewController:viewController animated:YES];
//            [viewController release];
//        }
//        else
//        {
//            [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_FEED_BACK;
//            [[RuYiCaiNetworkManager sharedManager] showLoginAlertView];
//        }
    }
    else if([indexPath row] == 7)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
        XinShouZhiNanViewController* viewController = [[XinShouZhiNanViewController alloc] init];
        viewController.title = @"新手指南";
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
    else if([indexPath row] == 8)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
        self.shareviewController = [[[ShareViewController alloc] init] autorelease];
        _shareviewController.delegate=self;
        _shareviewController.title = @"分享";
        _shareviewController.sinShareContent = [NSString stringWithFormat:@"@全民免费彩，我刚使用了全民免费彩票客户端买彩票，很方便呢！你也试试吧，彩票随身投，大奖时时有！中奖了记的要请客啊！下载地址为：%@", kAppStoreDownLoad];
        _shareviewController.txShareContent = [NSString stringWithFormat:@"@全民免费彩，我刚使用了全民免费彩票客户端买彩票，很方便呢！你也试试吧，彩票随身投，大奖时时有！中奖了记的要请客啊！下载地址为：%@", kAppStoreDownLoad];
        _shareviewController.shareContent = [NSString stringWithFormat:@"@全民免费彩，我刚使用了全民免费彩买彩票，很方便呢！你也试试吧，彩票随身投，大奖时时有！中奖了记的要请客啊！下载地址为：%@", kAppStoreDownLoad];
        [self.navigationController pushViewController:_shareviewController animated:YES];
    }
    else if([indexPath row] == 9)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
        SetViewController* viewController = [[SetViewController alloc] init];
        viewController.navigationItem.title = @"设置";
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
        
        
        
    }
    else if([indexPath row] == 10)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
        NewVersionIntroduction* viewController = [[NewVersionIntroduction alloc] init];
        viewController.title = @"关于";
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
    
    
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (void) viewContent:(WXMediaMessage *) msg
{
    //显示微信传过来的内容
    WXAppExtendObject *obj = msg.mediaObject;
    
    NSString *strTitle = [NSString stringWithFormat:@"消息来自微信"];
    NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%u bytes\n\n", msg.title, msg.description, obj.extInfo, msg.thumbData.length];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

- (void)doAuth
{
    SendAuthReq* req = [[[SendAuthReq alloc] init] autorelease];
    req.scope = @"post_timeline";
    req.state = @"xxx";
    
    [WXApi sendReq:req];
}

-(void) changeScene:(NSInteger)scene{
    _scene = scene;
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"发送结果"];
        if (resp.errCode==0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:@"微信分享成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:@"微信分享失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        
        
    }
    else if([resp isKindOfClass:[SendAuthResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"Auth结果"];
        NSString *strMsg = [NSString stringWithFormat:@"Auth结果:%d", resp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

-(void) onSentTextMessage:(BOOL) bSent
{
    // 通过微信发送消息后， 返回本App
    NSString *strTitle = [NSString stringWithFormat:@"发送结果"];
    
    NSString *strMsg = [NSString stringWithFormat:@"发送文本消息结果:%u", bSent];
    if ([strMsg isEqualToString:@"0"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:@"分享成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:@"分享失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    
    
}

- (void) sendTextContent:(NSString*)nsText
{
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = YES;
    req.text = nsText;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}


@end


