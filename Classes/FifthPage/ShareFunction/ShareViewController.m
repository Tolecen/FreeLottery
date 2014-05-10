//
//  ShareViewController.m
//  RuYiCai
//
//  Created by  on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShareViewController.h"
#import "RYCImageNamed.h"
#import "SharePublicCell.h"
#import "ShareSendViewController.h"
#import "RuYiCaiCommon.h"
#import "TengXunSendViewController.h"
#import "RuYiCaiNetworkManager.h"
#import "Custom_tabbar.h"
#import "NSLog.h"
#import "BackBarButtonItemUtils.h"
#import "UINavigationBarCustomBg.h"
#import "TextViewController.h"
#import "UINavigationBarCustomBg.h"
#import "ColorUtils.h"
#import "ImageNewCell.h"
#import "AdaptationUtils.h"

#define TIPSLABEL_TAG 10086


@implementation ShareViewController

@synthesize pushType = m_pushType;
@synthesize delegate = _delegate;
@synthesize m_nsLastText;
@synthesize shareContent = m_shareContent;
@synthesize sinShareContent = m_sinShareContent;
@synthesize txShareContent  = m_txShareContent;

@synthesize myTableView = m_myTableView;

- (void)dealloc
{
    [m_pushType release];
    [wxTitleStr release];
    [m_myTableView release], m_myTableView = nil;
    [m_shareContent release];
    [m_txShareContent release];
    [m_sinShareContent release];
    [super dealloc];
}


#pragma mark - View lifecycle

- (void)sendAppContent
{
    if (_delegate)
    {
        [_delegate sendAppContent];
    }
}

-(void) onCancelText
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void) onCompleteText:(NSString*)nsText
{
    [self dismissModalViewControllerAnimated:YES];
    self.m_nsLastText = nsText;
    if (_delegate)
    {
        [_delegate sendTextContent:self.shareContent] ;
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

- (void)sendTextContent
{
    TextViewController* viewController = [[[TextViewController alloc] init] autorelease];
    viewController.m_delegate = self;
    viewController.m_nsLastText =self.shareContent;
    viewController.titleStr = wxTitleStr;
    UINavigationController *navigatitonController = [[[UINavigationController alloc]initWithRootViewController:viewController] autorelease];
//    UIImageView *ima = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_bg.png"]];     [ima setFrame:CGRectMake(0, 0, 320, 44)];
//        ima.alpha=0.7;
//    [self.navigationController.navigationBar addSubview:ima];
   
	[self presentModalViewController:navigatitonController animated:YES];
}


- (void)sendNewsContent
{
    if (_delegate)
    {
        [_delegate sendNewsContent] ;
    }
}

- (void)doOAuth
{
    if (_delegate)
    {
        [_delegate doAuth];
    }
}

- (id)init{
    if(self = [super init]){
        m_pushType = @"PUSHSHOW";

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    self.view.backgroundColor = [ColorUtils parseColorFromRGB:@"#efede9"];

    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    m_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    m_myTableView.delegate = self;
    m_myTableView.dataSource = self;
    m_myTableView.backgroundColor = [UIColor clearColor];
    m_myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    m_myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    m_myTableView.separatorColor = [UIColor lightGrayColor];
    [self.view addSubview:m_myTableView];
//    m_nsLastText = @"完善的跨终端即时通讯能力，使得Mac可以与PC、手机、Pad等终端的QQ进行无缝沟通，让您的交流更畅快。 完善的跨终端即时通讯能力，使得Mac可以与PC、手机、Pad等终端的QQ进行无缝沟通，让您的交流更畅快。 ";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
//    self.m_nsLastText = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark  tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{ 
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	static NSString *myIdentifier = @"MyIdentifier";
    ImageNewCell *cell = (ImageNewCell*)[tableView dequeueReusableCellWithIdentifier:myIdentifier];
    if (cell == nil)
    {
        cell = [[[ImageNewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier] autorelease];
    }
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
    NSUInteger rowIndex = [indexPath row];
    
    if ([indexPath section] == 0)
    {
        if (0 == rowIndex)
        {
            cell.titleLable.text = @"分享到新浪微博";
            cell.logImageView.image = RYCImageNamed(@"share_xinlang.png");
        }
        else if (1 == rowIndex)
        {
            cell.titleLable.text = @"分享到腾讯微博";
            cell.logImageView.image = RYCImageNamed(@"share_tengxu.png");
        }
//        else if (2 == rowIndex)
//        {
//            cell.titleLable.text = @"分享到微信";
//            cell.logImageView.image = RYCImageNamed(@"weixin_c_byc.png");
//        }
//        else if (3 == rowIndex)
//        {
//            cell.titleLable.text = @"分享到朋友圈";
//            cell.logImageView.image = RYCImageNamed(@"weixin_friend_byc.png");
//        }
        else if(2 == rowIndex)
        {
            cell.titleLable.text = @"短信分享";
            cell.logImageView.image = RYCImageNamed(@"share_message.png");
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self setHidesBottomBarWhenPushed:YES];
    if(0 == indexPath.row)
    {
        ShareSendViewController* viewController = [[ShareSendViewController alloc] init];
        viewController.shareContent = self.sinShareContent;
        viewController.title = @"新浪微博分享";
        viewController.XinLang_shareType = XL_SHARE_DOWN_LOAD;
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
    else if(1 == indexPath.row)
    {
        TengXunSendViewController* viewController = [[TengXunSendViewController alloc] init];
        //if([RuYiCaiOR91 isEqualToString:@"RuYiCai"])
        viewController.shareContent = self.txShareContent;
        viewController.title = @"腾讯微博分享";
        viewController.TengXun_shareType = TX_SHARE_DOWN_LOAD;
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
//    else if(2 == indexPath.row)
//    {
////        TextViewController* viewController = [[TextViewController alloc] init];
////        //if([RuYiCaiOR91 isEqualToString:@"RuYiCai"])
////        viewController.m_nsLastText = [NSString stringWithFormat:@"#全民免费彩彩票iPhone客户端#，我正在使用@全民免费彩 手机客户端，购彩很方便，你也试试吧！下载地址：%@", kAppStoreDownLoad];
////        viewController.title = @"微信分享给好友";
////        [self.navigationController pushViewController:viewController animated:YES];
////        [viewController release];
////
//        [_delegate changeScene:WXSceneSession];
//        wxTitleStr = @"分享到微信";
//            [self sendTextContent];
//     
//        
//    
//    }
//    else if(3 == indexPath.row)
//    {
//        [_delegate changeScene:WXSceneTimeline];
//        wxTitleStr = @"分享到朋友圈";
//        [self sendTextContent];
//        
//        
//        
//    }
    else
    {
        [self sendsms:self.shareContent];
    }
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImageNewCell *Aircell = (ImageNewCell *)[tableView cellForRowAtIndexPath:indexPath];
    Aircell.accessoryImageView.image = [UIImage imageNamed:@"cell_c_gengduo_click.png"];
    
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}
- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImageNewCell *Aircell = (ImageNewCell *)[tableView cellForRowAtIndexPath:indexPath];
    Aircell.accessoryImageView.image = [UIImage imageNamed:@"cell_c_gengduo.png"];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSIndexPath *currentSelectedIndexPath = [self.myTableView indexPathForSelectedRow];
    if (currentSelectedIndexPath != nil)
    {
        ImageNewCell *Aircell = (ImageNewCell *)[tableView cellForRowAtIndexPath:currentSelectedIndexPath];
        Aircell.accessoryImageView.image = [UIImage imageNamed:@"cell_c_gengduo.png"];
        [self.myTableView deselectRowAtIndexPath:currentSelectedIndexPath animated:NO];
    }
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

- (void)back:(id)sender
{
    if ([m_pushType isEqualToString:@"PUSHHIDE"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
    }else
    {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
