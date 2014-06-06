//
//  SetViewController.m
//  RuYiCai
//
//  Created by  on 12-6-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SetViewController.h"
#import "SetupViewController.h"
#import "FuWuSetViewController.h"
//#import "SetWeiBoViewController.h"
#import "SetLotShowViewController.h"
#import "SetYaoYiYaoViewController.h"
#import "RYCImageNamed.h"
#import "RuYiCaiNetworkManager.h"
#import "LotteryBetWarnViewController.h"
#import "BackBarButtonItemUtils.h"
#import "ColorUtils.h"
#import "NewMoreCell.h"
#import "AdaptationUtils.h"

@implementation SetViewController

@synthesize myTableView = m_myTableView;

- (void)dealloc
{
    [m_myTableView release],m_myTableView = nil;
    
    [super dealloc];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [RuYiCaiNetworkManager sharedManager].goBackType = GO_GCDT_TYPE;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];

    self.view.backgroundColor = [ColorUtils parseColorFromRGB:@"#efede9"];


    self.myTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain] autorelease];
    m_myTableView.backgroundColor = [UIColor clearColor];
    m_myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    m_myTableView.delegate = self;
    m_myTableView.dataSource = self;
    [self.view addSubview:m_myTableView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setHidesBottomBarWhenPushed:YES];
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jointLogin:) name:@"jointLogin" object:nil];
    
   
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"jointLogin" object:nil];
    [super viewWillDisappear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    if ([RuYiCaiNetworkManager sharedManager].hasLogin)
    {
        if ([[CommonRecordStatus commonRecordStatusManager].loginWay isEqualToString: kNormalLogin])
        {
            return 4;
        }else
        {
            return 3;
        }
    }else
    {
        return 4;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    NewMoreCell *cell = (NewMoreCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NewMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    if ([RuYiCaiNetworkManager sharedManager].hasLogin)
    {
        if ([[CommonRecordStatus commonRecordStatusManager].loginWay isEqualToString: kNormalLogin])
        {
            if(0 == indexPath.row)
            {
                cell.titleLable.text = @"自动登录";
            }
            else if(1 == indexPath.row)
            {
                cell.titleLable.text = @"摇一摇机选";
            }
            //    else if(2 == indexPath.row)
            //    {
            //         cell.textLabel.text = @"服务设置";
            //    }
            else if(2 == indexPath.row)
            {
                cell.titleLable.text = @"彩种购买提醒";
            }
            else if(3 == indexPath.row)
            {
                cell.titleLable.text = @"微博绑定";
            }
        }else
        {
            if(0 == indexPath.row)
            {
                cell.titleLable.text = @"摇一摇机选";
            }
            //    else if(2 == indexPath.row)
            //    {
            //         cell.textLabel.text = @"服务设置";
            //    }
            else if(1 == indexPath.row)
            {
                cell.titleLable.text = @"彩种购买提醒";
            }
            else if(2 == indexPath.row)
            {
                cell.titleLable.text = @"微博绑定";
            }
        }
    }else
    {
        if(0 == indexPath.row)
        {
            cell.titleLable.text = @"自动登录";
        }
        else if(1 == indexPath.row)
        {
            cell.titleLable.text = @"摇一摇机选";
        }
        //    else if(2 == indexPath.row)
        //    {
        //         cell.textLabel.text = @"服务设置";
        //    }
        else if(2 == indexPath.row)
        {
            cell.titleLable.text = @"彩种购买提醒";
        }
        else if(3 == indexPath.row)
        {
            cell.titleLable.text = @"微博绑定";
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([RuYiCaiNetworkManager sharedManager].hasLogin)
    {
        if ([[CommonRecordStatus commonRecordStatusManager].loginWay isEqualToString: kNormalLogin])
        {
            if(indexPath.row == 0)
            {
                if([RuYiCaiNetworkManager sharedManager].hasLogin)
                {
                    //设置
                    [self setHidesBottomBarWhenPushed:YES];
                    SetupViewController* viewController = [[SetupViewController alloc] init];
                    viewController.title = @"自动登录";
                    [self.navigationController pushViewController:viewController animated:YES];
                    [viewController release];
                }
                else
                {
                    [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_BASE;
                    [RuYiCaiNetworkManager sharedManager].goBackType = GO_GDSZ_TYPE;
                    [[RuYiCaiNetworkManager sharedManager] showLoginAlertView];
                }
            }
            else if(1 == indexPath.row)
            {
                [self setHidesBottomBarWhenPushed:YES];
                SetYaoYiYaoViewController* viewController = [[SetYaoYiYaoViewController alloc] init];
                viewController.title = @"摇一摇机选";
                [self.navigationController pushViewController:viewController animated:YES];
                [viewController release];
            }
            //    else if(2 == indexPath.row)
            //    {
            //        if([RuYiCaiNetworkManager sharedManager].hasLogin)
            //        {
            //            [self setHidesBottomBarWhenPushed:YES];
            //            FuWuSetViewController* viewController = [[FuWuSetViewController alloc] init];
            //            viewController.title = @"服务设置";
            //            [self.navigationController pushViewController:viewController animated:YES];
            //            [viewController release];
            //        }
            //        else
            //        {
            //            [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_BASE;
            //            [[RuYiCaiNetworkManager sharedManager] showLoginAlertView];
            //        }
            //    }
            else if(2 == indexPath.row)
            {
                [self setHidesBottomBarWhenPushed:YES];
                LotteryBetWarnViewController* viewController = [[LotteryBetWarnViewController alloc] init];
                viewController.title = @"彩种购买提醒";
                [self.navigationController pushViewController:viewController animated:YES];
                [viewController release];
            }
            else if(3 == indexPath.row)
            {
//                [self setHidesBottomBarWhenPushed:YES];
//                SetWeiBoViewController* viewController = [[SetWeiBoViewController alloc] init];
//                viewController.title = @"微博绑定";
//                [self.navigationController pushViewController:viewController animated:YES];
//                [viewController release];
            }
        }else
        {
            if(0 == indexPath.row)
            {
                [self setHidesBottomBarWhenPushed:YES];
                SetYaoYiYaoViewController* viewController = [[SetYaoYiYaoViewController alloc] init];
                viewController.title = @"摇一摇机选";
                [self.navigationController pushViewController:viewController animated:YES];
                [viewController release];
            }
            //    else if(2 == indexPath.row)
            //    {
            //        if([RuYiCaiNetworkManager sharedManager].hasLogin)
            //        {
            //            [self setHidesBottomBarWhenPushed:YES];
            //            FuWuSetViewController* viewController = [[FuWuSetViewController alloc] init];
            //            viewController.title = @"服务设置";
            //            [self.navigationController pushViewController:viewController animated:YES];
            //            [viewController release];
            //        }
            //        else
            //        {
            //            [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_BASE;
            //            [[RuYiCaiNetworkManager sharedManager] showLoginAlertView];
            //        }
            //    }
            else if(1 == indexPath.row)
            {
                [self setHidesBottomBarWhenPushed:YES];
                LotteryBetWarnViewController* viewController = [[LotteryBetWarnViewController alloc] init];
                viewController.title = @"彩种购买提醒";
                [self.navigationController pushViewController:viewController animated:YES];
                [viewController release];
            }
            else if(2 == indexPath.row)
            {
//                [self setHidesBottomBarWhenPushed:YES];
//                SetWeiBoViewController* viewController = [[SetWeiBoViewController alloc] init];
//                viewController.title = @"微博绑定";
//                [self.navigationController pushViewController:viewController animated:YES];
//                [viewController release];
            }

        }
    }else
    {
        if(indexPath.row == 0)
        {
            if([RuYiCaiNetworkManager sharedManager].hasLogin)
            {
                //设置
                [self setHidesBottomBarWhenPushed:YES];
                SetupViewController* viewController = [[SetupViewController alloc] init];
                viewController.title = @"自动登录";
                [self.navigationController pushViewController:viewController animated:YES];
                [viewController release];
            }
            else
            {
                [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_BASE;
                [RuYiCaiNetworkManager sharedManager].goBackType = GO_GDSZ_TYPE;
                [[RuYiCaiNetworkManager sharedManager] showLoginAlertView];
            }
        }
        else if(1 == indexPath.row)
        {
            [self setHidesBottomBarWhenPushed:YES];
            SetYaoYiYaoViewController* viewController = [[SetYaoYiYaoViewController alloc] init];
            viewController.title = @"摇一摇机选";
            [self.navigationController pushViewController:viewController animated:YES];
            [viewController release];
        }
        //    else if(2 == indexPath.row)
        //    {
        //        if([RuYiCaiNetworkManager sharedManager].hasLogin)
        //        {
        //            [self setHidesBottomBarWhenPushed:YES];
        //            FuWuSetViewController* viewController = [[FuWuSetViewController alloc] init];
        //            viewController.title = @"服务设置";
        //            [self.navigationController pushViewController:viewController animated:YES];
        //            [viewController release];
        //        }
        //        else
        //        {
        //            [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_BASE;
        //            [[RuYiCaiNetworkManager sharedManager] showLoginAlertView];
        //        }
        //    }
        else if(2 == indexPath.row)
        {
            [self setHidesBottomBarWhenPushed:YES];
            LotteryBetWarnViewController* viewController = [[LotteryBetWarnViewController alloc] init];
            viewController.title = @"彩种购买提醒";
            [self.navigationController pushViewController:viewController animated:YES];
            [viewController release];
        }
        else if(3 == indexPath.row)
        {
//            [self setHidesBottomBarWhenPushed:YES];
//            SetWeiBoViewController* viewController = [[SetWeiBoViewController alloc] init];
//            viewController.title = @"微博绑定";
//            [self.navigationController pushViewController:viewController animated:YES];
//            [viewController release];
        }
    }

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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)jointLogin:(NSNotification *)notification
{
    //联合登陆成功发个通知，维护一下登陆状态
    
    [RuYiCaiNetworkManager sharedManager].hasLogin = YES;
    //随便复个任意一个的联合登陆的状态，让表识别是联合登陆就行
     [CommonRecordStatus commonRecordStatusManager].loginWay = kQQLogin;
    if (self.myTableView)
    {
        [self.myTableView reloadData];
    }
}
- (void)back:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
