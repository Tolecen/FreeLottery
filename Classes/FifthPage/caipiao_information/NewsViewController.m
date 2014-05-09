//
//  NewsViewController.m
//  RuYiCai
//
//  Created by  on 12-2-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewsViewController.h"
#import "SBJsonParser.h"
#import "RuYiCaiNetworkManager.h"
#import "ShareSendViewController.h"
#import "TengXunSendViewController.h"
#import "NSLog.h"
#import "BackBarButtonItemUtils.h"
#import "ShareRightBarButtonItemUtils.h"
#import "BlockActionSheet.h"
#import "ColorUtils.h"
#import "AdaptationUtils.h"

#define news_viewv_controller_background_color @"#efede9"

//彩民专区 新闻页面
@implementation NewsViewController

@synthesize shareURL;
@synthesize delegate = _delegate;
@synthesize newsTitle   =m_newsTitle;

- (void)dealloc
{
    [m_newsTitle release];
    [m_shareButton release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:RYCImageNamed(@"table_beijing.png")];
    self.view.backgroundColor = [ColorUtils parseColorFromRGB:news_viewv_controller_background_color];
//    self.title = @"新闻";
    [self setMainView];
    
    [BackBarButtonItemUtils addBackButtonForController:self];
    [ShareRightBarButtonItemUtils addShareRightButtonForController:self addTarget:self action:@selector(shareButtonClick:) andTitle:nil];
        
    
    
}


- (void)setMainView
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    [jsonParser release];
    self.shareURL = [[parserDict objectForKey:@"url"] stringByReplacingOccurrencesOfString:@"ruyicai" withString:@"boyacai"];
//    self.title  = [parserDict objectForKey:@"title"];
//    UIImageView *image_topbg = [[UIImageView alloc] initWithFrame:CGRectMake(9, 10, 302, 12)];
//    image_topbg.image = RYCImageNamed(@"croner_top.png");
//    [self.view addSubview:image_topbg];
//    [image_topbg release];
    
    UIImageView *image_middlebg = [[UIImageView alloc] init];
//    image_middlebg.image = RYCImageNamed(@"croner_middle.png");
    [image_middlebg setBackgroundColor:[ColorUtils parseColorFromRGB:news_viewv_controller_background_color ]];
    [self.view addSubview:image_middlebg];
    
    CGSize titleSize = [[parserDict objectForKey:@"title"] sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(280, 200) lineBreakMode:UILineBreakModeTailTruncation];
    
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 280, titleSize.height)];
    myLabel.textAlignment = UITextAlignmentCenter;
    myLabel.lineBreakMode = UILineBreakModeTailTruncation;
    myLabel.numberOfLines = titleSize.height/19;
    myLabel.text = [parserDict objectForKey:@"title"];
    self.newsTitle = [parserDict objectForKey:@"title"];
//    [myLabel setTextColor:[UIColor colorWithRed:108.0/255.0 green:59.0/255.0 blue:59.0/255.0 alpha:1.0]];
    [myLabel setTextColor:[UIColor blackColor]];
    myLabel.backgroundColor = [UIColor clearColor];
    myLabel.font = [UIFont boldSystemFontOfSize:17];
    [image_middlebg addSubview:myLabel];
    
    UILabel* m_timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, myLabel.frame.origin.y + myLabel.frame.size.height + 5, 302, 19)];

//    m_timeLabel.text = [parserDict objectForKey:@"updateTime"];
    m_timeLabel.text = [NSString stringWithFormat:@"发表于：%@",[parserDict objectForKey:@"updateTime"]];
//    [m_timeLabel setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
    [m_timeLabel setTextColor:[ColorUtils parseColorFromRGB:@"#a0a0a0"]];
    m_timeLabel.textAlignment = UITextAlignmentCenter;
    m_timeLabel.backgroundColor = [UIColor clearColor];
    m_timeLabel.font = [UIFont systemFontOfSize:13];
    [image_middlebg addSubview:m_timeLabel];
    
    image_middlebg.frame = CGRectMake(9, 20, 302, m_timeLabel.frame.origin.y + m_timeLabel.frame.size.height + 5);
    
    [myLabel release];
    [m_timeLabel release];
    
    UIImageView *image_bottombg = [[UIImageView alloc] initWithFrame:CGRectMake(9, image_middlebg.frame.origin.y + image_middlebg.frame.size.height, 302, [UIScreen mainScreen].bounds.size.height - 74 - image_middlebg.frame.origin.y - image_middlebg.frame.size.height)];
    [image_bottombg setBackgroundColor:[ColorUtils parseColorFromRGB:news_viewv_controller_background_color]];
    [self.view addSubview:image_bottombg];
    
    UIWebView* m_replyView = [[UIWebView alloc] initWithFrame:CGRectMake(0, image_bottombg.frame.origin.y + 2, 320, image_bottombg.frame.size.height - 5)];
    [m_replyView setBackgroundColor:[UIColor clearColor]];
    [m_replyView setOpaque:NO];
    [m_replyView loadHTMLString:[parserDict objectForKey:@"content"] baseURL:nil];
    [self.view addSubview:m_replyView];
    [m_replyView release];
    
    [image_middlebg release];
    [image_bottombg release];
    
//    [self setShareButton];
}

//- (void)refreshView
//{
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(9, 15, 302, 25)];
//    label.textAlignment = UITextAlignmentCenter;
//    label.text = dict;
//    label.backgroundColor = [UIColor clearColor];
//    [label setTextColor:[UIColor brownColor]];
//    [self.view addSubview:label];
//    [label release];
//    
//    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(9, 40, 302, 25)];
//    timeLabel.textAlignment = UITextAlignmentCenter;
//    timeLabel.text = [parserDict objectForKey:@"updateTime"];
//    timeLabel.backgroundColor = [UIColor clearColor];
//    [timeLabel setTextColor:[UIColor grayColor]];
//    timeLabel.font = [UIFont systemFontOfSize:14];
//    [self.view addSubview:timeLabel];
//    [timeLabel release];
//    
//    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(9, 69, 301, [UIScreen mainScreen].bounds.size.height - 145)];
//    textView.text = content;
//    textView.editable = NO;
//    [textView setTextColor:[UIColor blackColor]];
//    [textView setFont:[UIFont systemFontOfSize:14]];
//    [textView setBackgroundColor:[UIColor clearColor]];
//    [self.view addSubview:textView];
//    [textView release];
//    
////    UIWebView*  webView = [[UIWebView alloc] initWithFrame:CGRectMake(10, 69, 300, 333)];
////    [webView loadHTMLString:content baseURL:nil];
////    [self.view addSubview:webView];
////    [webView release];
//    
//  
//}

#pragma mark 分享
- (void)setShareButton
{
    m_shareButton = [[UIButton alloc] initWithFrame:CGRectMake(320-37, 345, 37, 32)];
    [m_shareButton setBackgroundImage:RYCImageNamed(@"share_c_nomal.png") forState:UIControlStateNormal];
    [m_shareButton setBackgroundImage:RYCImageNamed(@"share_c_click.png") forState:UIControlStateHighlighted];
    [m_shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    m_shareButton.center = CGPointMake(163 + 270, [UIScreen mainScreen].bounds.size.height - 113);
    [self.view addSubview:m_shareButton];
    
//    UIButton*  xinLang = [[UIButton alloc] initWithFrame:CGRectMake(58, 7, 118, 30)];
//    [xinLang setBackgroundImage:RYCImageNamed(@"sina.png") forState:UIControlStateNormal];
//    [xinLang addTarget:self action:@selector(sinaButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [m_shareButton addSubview:xinLang];
//    [xinLang release];
//    
//    UIButton*  tengXun = [[UIButton alloc] initWithFrame:CGRectMake(186, 7, 118, 30)];
//    [tengXun setBackgroundImage:RYCImageNamed(@"tengxun.png") forState:UIControlStateNormal];
//    [tengXun addTarget:self action:@selector(tengXunButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [m_shareButton addSubview:tengXun];
//    [tengXun release];
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
    
    //163 + 270
//    [UIView beginAnimations:@"movement" context:nil]; 
//	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
//	[UIView setAnimationDuration:0.5f];
//	[UIView setAnimationRepeatCount:1];
//	[UIView setAnimationRepeatAutoreverses:NO];
//    CGPoint buttonCenter = m_shareButton.center;
//    if(buttonCenter.x != 163)
//    {
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
    [self setHidesBottomBarWhenPushed:YES];
    [_delegate changeScene:WXSceneTimeline];
    TextViewController* viewController = [[TextViewController alloc] init];
    viewController.m_nsLastText = [NSString stringWithFormat:@"@全民免费彩，我在全民免费彩发现了一条比较有趣的新闻。%@。%@", self.newsTitle,self.shareURL];
    viewController.titleStr  = @"分享到朋友圈";
    //    viewController.XinLang_shareType = XL_SHARE_NEWS;
    viewController.m_delegate = self;
    [self  presentModalViewController:viewController animated:YES];
    [viewController release];
}


- (void)weiXinButtonClick:(id)sender
{
    [self setHidesBottomBarWhenPushed:YES];
    [_delegate changeScene:WXSceneSession];
    TextViewController* viewController = [[TextViewController alloc] init];
    viewController.m_nsLastText = [NSString stringWithFormat:@"@全民免费彩，我在全民免费彩发现了一条比较有趣的新闻。%@。%@", self.newsTitle,self.shareURL];
    viewController.titleStr = @"分享到微信";
//    viewController.XinLang_shareType = XL_SHARE_NEWS;
    viewController.m_delegate = self;
    [self  presentModalViewController:viewController animated:YES];
    [viewController release];
}
- (void)sinaButtonClick:(id)sender
{
    [self setHidesBottomBarWhenPushed:YES];

    ShareSendViewController* viewController = [[ShareSendViewController alloc] init];
    viewController.shareContent = [NSString stringWithFormat:@"@全民免费彩，我在全民免费彩发现了一条比较有趣的新闻。%@。%@", self.newsTitle,self.shareURL];       
    viewController.title = @"新浪微博分享";
    viewController.XinLang_shareType = XL_SHARE_NEWS;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)tengXunButtonClick:(id)sender
{
    [self setHidesBottomBarWhenPushed:YES];

    TengXunSendViewController* viewController = [[TengXunSendViewController alloc] init];
    viewController.shareContent = [NSString stringWithFormat:@"@全民免费彩，我在全民免费彩发现了一条比较有趣的新闻。%@。%@", self.newsTitle,self.shareURL];
    viewController.title = @"腾讯微博分享";
    viewController.TengXun_shareType = TX_SHARE_NEWS;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
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
    
    [self sendsms:[NSString stringWithFormat:@"@全民免费彩，我在全民免费彩发现了一条比较有趣的新闻。%@。%@", self.newsTitle,self.shareURL]];
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
