//
//  ActionCenterDetailViewController.m
//  RuYiCai
//
//  Created by  on 12-4-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ActionCenterDetailViewController.h"
#import "RuYiCaiNetworkManager.h"
#import "RYCImageNamed.h"
#import "SBJsonParser.h"
#import "NSLog.h"
#import "BackBarButtonItemUtils.h"
#import "ColorUtils.h"
#import "AdaptationUtils.h"

@implementation ActionCenterDetailViewController

@synthesize activityId = m_activityId;
@synthesize activityTime = m_activityTime;
@synthesize pushType     = m_pushType;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetActivityContentOK" object:nil];
    [m_pushType release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    self.view.backgroundColor = [ColorUtils parseColorFromRGB:@"#fff9f4"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetActivityContentOK:) name:@"GetActivityContentOK" object:nil];
  
    [[RuYiCaiNetworkManager sharedManager] getActivityDetail:self.activityId];
    
    
}

- (void)GetActivityContentOK:(NSNotification*)notification
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    [jsonParser release];
    
    UIImageView *image_topbg = [[UIImageView alloc] initWithFrame:CGRectMake(9, 10, 302, 12)];
    image_topbg.backgroundColor = [UIColor clearColor];
    [self.view addSubview:image_topbg];
    [image_topbg release];
    
    UIImageView *image_middlebg = [[UIImageView alloc] init];
    image_topbg.backgroundColor = [UIColor clearColor];
    [self.view addSubview:image_middlebg];
    
    NSString *titleStr = [parserDict objectForKey:@"title"];
    CGSize titleSize = [titleStr sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(280, 200) lineBreakMode:UILineBreakModeTailTruncation]; 
    
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 280, titleSize.height)];
    myLabel.textAlignment = UITextAlignmentCenter;
    myLabel.lineBreakMode = UILineBreakModeTailTruncation;
    myLabel.numberOfLines = titleSize.height/19;
    myLabel.text = titleStr;
    [myLabel setTextColor:[UIColor colorWithRed:108.0/255.0 green:59.0/255.0 blue:59.0/255.0 alpha:1.0]];
    myLabel.backgroundColor = [UIColor clearColor];
    myLabel.font = [UIFont systemFontOfSize:15];
    [image_middlebg addSubview:myLabel];
    
    self.activityTime  = [parserDict objectForKey:@"activityTime"];
    UILabel* m_timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, myLabel.frame.origin.y + myLabel.frame.size.height + 5, 302, 19)];
    m_timeLabel.text = self.activityTime;
    
    [m_timeLabel setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
    m_timeLabel.textAlignment = UITextAlignmentCenter;
    m_timeLabel.backgroundColor = [UIColor clearColor];
    m_timeLabel.font = [UIFont systemFontOfSize:14];
    [image_middlebg addSubview:m_timeLabel];
    
    image_middlebg.frame = CGRectMake(9, 20, 302, m_timeLabel.frame.origin.y + m_timeLabel.frame.size.height + 5);
    
    [myLabel release];
    [m_timeLabel release];
   
    UIImageView *image_bottombg = [[UIImageView alloc] initWithFrame:CGRectMake(9, image_middlebg.frame.origin.y + image_middlebg.frame.size.height, 302, [UIScreen mainScreen].bounds.size.height - 74 - image_middlebg.frame.origin.y - image_middlebg.frame.size.height)];
    image_bottombg.backgroundColor = [UIColor clearColor];
    [self.view addSubview:image_bottombg];
    
    UITextView* m_replyView = [[UITextView alloc] initWithFrame:CGRectMake(15, image_bottombg.frame.origin.y + 2, 280, image_bottombg.frame.size.height - 5)];
    m_replyView.editable = NO;
    m_replyView.scrollEnabled = YES;
    m_replyView.backgroundColor = [UIColor clearColor];
    m_replyView.showsVerticalScrollIndicator = NO;
    m_replyView.text = [parserDict objectForKey:@"content"];
    [m_replyView setFont:[UIFont boldSystemFontOfSize:12]];
    [m_replyView setTextColor:[UIColor blackColor]];
    [self.view addSubview:m_replyView];
    [m_replyView release];
    
    [image_middlebg release];
    [image_bottombg release];
}

- (void)back:(id)sender
{
    if ([m_pushType isEqualToString:@"HIDTYPE"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
    }else
    {
       [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
