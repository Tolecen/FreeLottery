//
//  ZJJHViewController.m
//  RuYiCai
//
//  Created by  on 12-4-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ZJJHViewController.h"
#import "RYCImageNamed.h"
#import "RuYiCaiNetworkManager.h"
#import "SBJsonParser.h"
#import "Custom_tabbar.h"
#import "NSLog.h"
#import "AdaptationUtils.h"

#define kSegmentedOne      (0)
#define kSegmentedTwo      (1)
#define kSegmentedThere    (2)
#define kSegmentedFour     (3)

@interface ZJJHViewController (internal)

- (void)setNavigationBackButton;
- (void)viewBack:(id)sender;
- (void)segmentedChange:(id)sender;
- (void)getExpertCodeOK:(NSNotification*)notification;
- (void)refrshMyScrollView;
- (void)DGbuttonClick:(UIButton*)button;
- (void)displaySMS:(NSString*)message;
- (void)sendsms:(NSString*)message;

@end

@implementation ZJJHViewController

@synthesize  titleDataArrayOne = m_titleDataArrayOne;
@synthesize  titleDataArrayTwo = m_titleDataArrayTwo;
@synthesize  titleDataArrayThere = m_titleDataArrayThere;
@synthesize  titleDataArrayFour = m_titleDataArrayFour;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getExpertCodeOK" object:nil];
    
    [m_segmented release];
    [m_scrollViewOne release];
    [m_scrollViewTwo release];
    [m_scrollViewThere release];
    [m_scrollViewFour release];
    [m_titleDataArrayOne release], m_titleDataArrayOne = nil;
    [m_titleDataArrayTwo release], m_titleDataArrayTwo = nil;
    [m_titleDataArrayThere release], m_titleDataArrayThere = nil;
    [m_titleDataArrayFour release], m_titleDataArrayFour = nil;

    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationBackButton];
    [AdaptationUtils adaptation:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getExpertCodeOK:) name:@"getExpertCodeOK" object:nil];
    
    isScrollTwo = YES;
    isScrollThere = YES;
    isScrollFour = YES;
    clickButtonTag = 0;
    
    NSArray *items = [NSArray arrayWithObjects:@"开奖短信", @"双色球", @"福彩3D", @"排列三", nil];
    m_segmented = [[UISegmentedControl alloc] initWithItems:items];
    m_segmented.segmentedControlStyle = UISegmentedControlStyleBar;
	m_segmented.tintColor = [UIColor darkGrayColor];
    [self.view addSubview:m_segmented];
    [m_segmented setFrame:CGRectMake(-6, 0, 332, 30)];
    m_segmented.selectedSegmentIndex = 0;
    [m_segmented addTarget:self action:@selector(segmentedChange:) forControlEvents:UIControlEventValueChanged];  
    
    m_scrollViewOne = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 29, 320, (int)([UIScreen mainScreen].bounds.size.height - 93))];
    m_scrollViewOne.backgroundColor = [UIColor colorWithPatternImage:RYCImageNamed(@"table_beijing.png")];
    [self.view addSubview:m_scrollViewOne];
    
    m_scrollViewTwo = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 29, 320, (int)([UIScreen mainScreen].bounds.size.height - 93))];
    m_scrollViewTwo.backgroundColor = [UIColor colorWithPatternImage:RYCImageNamed(@"table_beijing.png")];
    [self.view addSubview:m_scrollViewTwo];
    m_scrollViewTwo.hidden = YES;
    
    m_scrollViewThere = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 29, 320, (int)([UIScreen mainScreen].bounds.size.height - 93))];
    m_scrollViewThere.backgroundColor = [UIColor colorWithPatternImage:RYCImageNamed(@"table_beijing.png")];
    [self.view addSubview:m_scrollViewThere];
    m_scrollViewThere.hidden = YES;
    
    m_scrollViewFour = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 29, 320, (int)([UIScreen mainScreen].bounds.size.height - 93))];
    m_scrollViewFour.backgroundColor = [UIColor colorWithPatternImage:RYCImageNamed(@"table_beijing.png")];
    [self.view addSubview:m_scrollViewFour];
    m_scrollViewFour.hidden = YES;
    
    m_titleDataArrayOne = [[NSMutableArray alloc] initWithCapacity:10];
    m_titleDataArrayTwo = [[NSMutableArray alloc] initWithCapacity:10];
    m_titleDataArrayThere = [[NSMutableArray alloc] initWithCapacity:10];
    m_titleDataArrayFour = [[NSMutableArray alloc] initWithCapacity:10];

    m_curIndex = 0;
    
    [[RuYiCaiNetworkManager sharedManager] getExpertCode:@"1"];
}

- (void)setNavigationBackButton
{
    UILabel *label = [[[UILabel alloc] init] autorelease];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:label] autorelease]; //消掉系统的按钮
    
	m_backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 7, 70, 30)];
    [m_backButton setBackgroundImage:RYCImageNamed(@"back_triangle_normal2.png") forState:UIControlStateNormal];
    [m_backButton setBackgroundImage:RYCImageNamed(@"back_triangle_click2.png") forState:UIControlStateHighlighted];
	[m_backButton addTarget:self action:@selector(viewBack:) forControlEvents:UIControlEventTouchUpInside];
	[m_backButton setTitle:@"购彩大厅" forState:UIControlStateNormal];
    m_backButton.contentEdgeInsets = UIEdgeInsetsMake(0, 8, 2, 0);
    m_backButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [m_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:m_backButton];
}

- (void)viewBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [m_backButton removeFromSuperview];
    [m_backButton release];
}


- (void)segmentedChange:(id)sender
{
    m_scrollViewOne.contentOffset = CGPointMake(0, 0);
    m_scrollViewTwo.contentOffset = CGPointMake(0, 0);
    m_scrollViewThere.contentOffset = CGPointMake(0, 0);
    m_scrollViewFour.contentOffset = CGPointMake(0, 0);

    switch (m_segmented.selectedSegmentIndex)
    {
        case kSegmentedOne:
            m_scrollViewOne.hidden = NO;
            m_scrollViewTwo.hidden = YES;
            m_scrollViewThere.hidden = YES;
            m_scrollViewFour.hidden = YES;
            break;
        case kSegmentedTwo:
            m_scrollViewOne.hidden = YES;
            m_scrollViewTwo.hidden = NO;
            m_scrollViewThere.hidden = YES;
            m_scrollViewFour.hidden = YES;
            if(isScrollTwo)
              [[RuYiCaiNetworkManager sharedManager] getExpertCode:@"2"];
            break;
        case kSegmentedThere:
            m_scrollViewOne.hidden = YES;
            m_scrollViewTwo.hidden = YES;
            m_scrollViewThere.hidden = NO;
            m_scrollViewFour.hidden = YES;
            if(isScrollThere)
              [[RuYiCaiNetworkManager sharedManager] getExpertCode:@"3"];
            break;
        case kSegmentedFour:
            m_scrollViewOne.hidden = YES;
            m_scrollViewTwo.hidden = YES;
            m_scrollViewThere.hidden = YES;
            m_scrollViewFour.hidden = NO;
            if(isScrollFour)
              [[RuYiCaiNetworkManager sharedManager] getExpertCode:@"4"];
            break;
        default:
            break;
    }
}

- (void)refrshMyScrollView
{
    UIScrollView  *tempScroll;
    NSMutableArray *tempArray;
    switch (m_segmented.selectedSegmentIndex) {
        case kSegmentedOne:
            tempScroll = m_scrollViewOne;
            tempArray = self.titleDataArrayOne;
            break;
        case kSegmentedTwo:
            tempScroll = m_scrollViewTwo;
            tempArray = self.titleDataArrayTwo;
            isScrollTwo = NO;
            break;
        case kSegmentedThere:
            tempScroll = m_scrollViewThere;
            tempArray = self.titleDataArrayThere;
            isScrollThere = NO;
            break;
        case kSegmentedFour:
            tempScroll = m_scrollViewFour;
            tempArray = self.titleDataArrayFour;
            isScrollFour = NO;
            break;
        default:
            break;
    }
    UIImageView *image_topbg = [[UIImageView alloc] initWithFrame:CGRectMake(9, 10 + m_startY, 302, 12)];
    image_topbg.image = RYCImageNamed(@"croner_top.png");
    [tempScroll addSubview:image_topbg];
    [image_topbg release];
    
    UIImageView *image_middlebg = [[UIImageView alloc] init];
    image_middlebg.image = RYCImageNamed(@"croner_middle.png");
    [tempScroll addSubview:image_middlebg];
    
    NSString *titleStr = [[tempArray objectAtIndex:m_curIndex] objectForKey:@"title"];
    CGSize titleSize = [titleStr sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(292, 200) lineBreakMode:UILineBreakModeTailTruncation]; 
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 180, titleSize.height)];
    titleLabel.text = titleStr;
    titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
    titleLabel.numberOfLines = titleSize.height/19;
    [titleLabel setTextColor:[UIColor colorWithRed:204.0/255.0 green:51.0/255.0 blue:0 alpha:1.0]];
    titleLabel.textAlignment = UITextAlignmentLeft;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    [image_middlebg addSubview:titleLabel];
    
    CGRect button_DG_frame = CGRectMake(200, 15 + m_startY, 100, 32);
	UIButton* button_DG = [[UIButton alloc] initWithFrame:button_DG_frame];
	[button_DG setBackgroundImage:RYCImageNamed(@"dg_normal.png") forState:UIControlStateNormal];
    [button_DG setBackgroundImage:RYCImageNamed(@"dg_click.png") forState:UIControlStateHighlighted];
    [button_DG addTarget:self action:@selector(DGbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button_DG setTitle:[[tempArray objectAtIndex:m_curIndex] objectForKey:@"buttonText"] forState:UIControlStateNormal];
    [button_DG setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button_DG.titleLabel.font = [UIFont systemFontOfSize:13];
    button_DG.contentEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    button_DG.tag = m_curIndex;
    [tempScroll addSubview:button_DG];
    [button_DG release];
    
    NSString *contentStr = [[tempArray objectAtIndex:m_curIndex] objectForKey:@"content"];
    CGSize contentSize = [contentStr sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(292, 200) lineBreakMode:UILineBreakModeTailTruncation];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, titleLabel.frame.origin.y + titleLabel.frame.size.height + 10, 292, contentSize.height)];
    contentLabel.text = contentStr;
    contentLabel.lineBreakMode = UILineBreakModeTailTruncation;
    contentLabel.numberOfLines = contentSize.height/13;
    [contentLabel setTextColor:[UIColor blackColor]];
    contentLabel.textAlignment = UITextAlignmentLeft;
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.font = [UIFont systemFontOfSize:12];
    [image_middlebg addSubview:contentLabel];
    
    [titleLabel release];
    [contentLabel release];
    
    image_middlebg.frame = CGRectMake(9, 22 + m_startY, 302, contentLabel.frame.origin.y + contentLabel.frame.size.height);
    
    UIImageView *image_bottombg = [[UIImageView alloc] initWithFrame:CGRectMake(9,image_middlebg.frame.origin.y + image_middlebg.frame.size.height, 302, 12)];
    image_bottombg.image = RYCImageNamed(@"croner_bottom.png");
    [tempScroll addSubview:image_bottombg];

    m_startY = (int)(image_bottombg.frame.origin.y + image_bottombg.frame.size.height);
    
    [image_bottombg release];
    [image_middlebg release];
    
    tempScroll.contentSize = CGSizeMake(320, m_startY + 10);
}

- (void)getExpertCodeOK:(NSNotification*)notification
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    [jsonParser release];
    
    //[self.titleDataArray removeAllObjects];
    m_startY = 0;
    switch (m_segmented.selectedSegmentIndex) {
        case kSegmentedOne:
            [self.titleDataArrayOne addObjectsFromArray:[parserDict objectForKey:@"result"]];
            break;
        case kSegmentedTwo:
            [self.titleDataArrayTwo addObjectsFromArray:[parserDict objectForKey:@"result"]];
            break;
        case kSegmentedThere:
            [self.titleDataArrayThere addObjectsFromArray:[parserDict objectForKey:@"result"]];
            break;
        case kSegmentedFour:
            [self.titleDataArrayFour addObjectsFromArray:[parserDict objectForKey:@"result"]];
            break;
        default:
            break;
    }
    for(int i = 0; i < [[parserDict objectForKey:@"result"] count]; i++)
    {
      [self refrshMyScrollView];
        m_curIndex ++;
    }
    m_curIndex = 0;
}

- (void)DGbuttonClick:(UIButton*)button
{
    clickButtonTag = button.tag;
    NSString*  mesStr;

    switch (m_segmented.selectedSegmentIndex) {
        case kSegmentedOne:
            mesStr = [[self.titleDataArrayOne objectAtIndex:clickButtonTag] objectForKey:@"alertMessage"];
            break;
        case kSegmentedTwo:
            mesStr = [[self.titleDataArrayTwo objectAtIndex:clickButtonTag] objectForKey:@"alertMessage"];
            break;
        case kSegmentedThere:
            mesStr = [[self.titleDataArrayThere objectAtIndex:clickButtonTag] objectForKey:@"alertMessage"];
            break;
        case kSegmentedFour:
            mesStr = [[self.titleDataArrayFour objectAtIndex:clickButtonTag] objectForKey:@"alertMessage"];
            break;
        default:
            break;
    }

    UIAlertView* alterView = [[UIAlertView alloc] initWithTitle:@"提示" message:mesStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
    
    [alterView addButtonWithTitle:@"确定"];
    alterView.delegate = self;
    [alterView show];

    [alterView release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( buttonIndex != alertView.cancelButtonIndex)
    {
        switch (m_segmented.selectedSegmentIndex) {
            case kSegmentedOne:
                [self sendsms:[[self.titleDataArrayOne objectAtIndex:clickButtonTag] objectForKey:@"messageCode"]];
                break;
            case kSegmentedTwo:
                [self sendsms:[[self.titleDataArrayTwo objectAtIndex:clickButtonTag] objectForKey:@"messageCode"]];
                break;
            case kSegmentedThere:
                [self sendsms:[[self.titleDataArrayThere objectAtIndex:clickButtonTag] objectForKey:@"messageCode"]];
                break;
            case kSegmentedFour:
                [self sendsms:[[self.titleDataArrayFour objectAtIndex:clickButtonTag] objectForKey:@"messageCode"]];
                break;
            default:
                break;
        }
    }
}                           
                            
- (void)displaySMS:(NSString*)message
{
    MFMessageComposeViewController*picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate=self;
    picker.navigationBar.tintColor= [UIColor redColor];
    picker.body= message;// 默认信息内容
    
    // 默认收件人(可多个)
//    NSArray *numArray = [m_numTextView.text componentsSeparatedByString:@","]; 
//    picker.recipients = numArray;
    //picker.recipients = [NSArray arrayWithObjects:@"13161962673", nil];
    
    switch (m_segmented.selectedSegmentIndex) {
        case kSegmentedOne:
            picker.recipients = [NSArray arrayWithObject:[[self.titleDataArrayOne objectAtIndex:clickButtonTag] objectForKey:@"toPhone"]];
            break;
        case kSegmentedTwo:
            picker.recipients = [NSArray arrayWithObject:[[self.titleDataArrayTwo objectAtIndex:clickButtonTag] objectForKey:@"toPhone"]];
            break;
        case kSegmentedThere:
            picker.recipients = [NSArray arrayWithObject:[[self.titleDataArrayThere objectAtIndex:clickButtonTag] objectForKey:@"toPhone"]];
            break;
        case kSegmentedFour:
            picker.recipients = [NSArray arrayWithObject:[[self.titleDataArrayFour objectAtIndex:clickButtonTag] objectForKey:@"toPhone"]];
            break;
        default:
            break;
    }
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
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"设备没有短信功能，无法进行定阅！" withTitle:@"提示" buttonTitle:@"确定"];
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
