//
//  LeaveMessageReplyViewController.m
//  RuYiCai
//
//  Created by  on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LeaveMessageReplyViewController.h"
#import "RYCImageNamed.h"
#import "NSLog.h"
#import "SBJsonParser.h"
#import "RuYiCaiNetworkManager.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"

@implementation LeaveMessageReplyViewController

@synthesize timeLabel = m_timeLabel;
@synthesize contentLabel = m_contentLabel;
@synthesize replyView = m_replyView;
@synthesize rowIndex;
@synthesize contentArray = m_contentArray;

#pragma mark - View lifecycle

- (void)dealloc
{
    [m_timeLabel release];
    [m_contentLabel release];
    [m_replyView release];
    //[m_contentArray release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    self.view.backgroundColor = [UIColor colorWithPatternImage:RYCImageNamed(@"table_beijing.png")];
    [BackBarButtonItemUtils addBackButtonForController:self];
    [self setMainView];
}

- (void)setMainView
{
//    SBJsonParser *jsonParser = [SBJsonParser new];
//    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
//    NSArray* contentArray = [parserDict objectForKey:@"result"];
//    [jsonParser release];
    
    UIImageView *image_topbg = [[UIImageView alloc] initWithFrame:CGRectMake(9, 10, 302, 34)];
    image_topbg.image = RYCImageNamed(@"reply_top.png");
    [self.view addSubview:image_topbg];
    [image_topbg release];
    
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, 150, 30)];
    myLabel.textAlignment = UITextAlignmentLeft;
    myLabel.text = @"客服回复信息";
    [myLabel setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
    myLabel.backgroundColor = [UIColor clearColor];
    myLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:myLabel];
    [myLabel release];
    
    m_timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 12, 120, 30)];
    m_timeLabel.text = [[self.contentArray objectAtIndex:rowIndex] objectForKey:@"createTime"];
    [m_timeLabel setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
    m_timeLabel.textAlignment = UITextAlignmentRight;
    m_timeLabel.backgroundColor = [UIColor clearColor];
    m_timeLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:m_timeLabel];
    
    UIImageView *image_middlebg = [[UIImageView alloc] init];
    image_middlebg.image = RYCImageNamed(@"reply_middle.png");
    [self.view addSubview:image_middlebg];

    UILabel *questLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 50, 20)];
    questLabel.textAlignment = UITextAlignmentLeft;
    questLabel.text = @"问：";
    [questLabel setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
    questLabel.backgroundColor = [UIColor clearColor];
    questLabel.font = [UIFont systemFontOfSize:15];
    [image_middlebg addSubview:questLabel];
    [questLabel release];
    
    NSString *questS = [[self.contentArray objectAtIndex:rowIndex] objectForKey:@"content"];
    CGSize titleSize = [questS sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(270, 200) lineBreakMode:UILineBreakModeTailTruncation]; 
    
    m_contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 270, titleSize.height)];
    m_contentLabel.text = questS;
    m_contentLabel.lineBreakMode = UILineBreakModeTailTruncation;
    m_contentLabel.numberOfLines = titleSize.height/19;
    [m_contentLabel setTextColor:[UIColor colorWithRed:0 green:102.0/255.0 blue:153.0/255.0 alpha:1.0]];
    m_contentLabel.textAlignment = UITextAlignmentLeft;
    m_contentLabel.backgroundColor = [UIColor clearColor];
    m_contentLabel.font = [UIFont systemFontOfSize:15];
    [image_middlebg addSubview:m_contentLabel];
    
    image_middlebg.frame = CGRectMake(9, 44, 302, titleSize.height + 25);
    
    UIImageView *image_bottombg = [[UIImageView alloc] initWithFrame:CGRectMake(9, image_middlebg.frame.origin.y + image_middlebg.frame.size.height, 302, [UIScreen mainScreen].bounds.size.height - 74 - image_middlebg.frame.origin.y - image_middlebg.frame.size.height)];
    image_bottombg.image = RYCImageNamed(@"reply_bottom.png");
    [self.view addSubview:image_bottombg];

    
    UILabel *answerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 50, 20)];
    answerLabel.textAlignment = UITextAlignmentLeft;
    answerLabel.text = @"答：";
    [answerLabel setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
    answerLabel.backgroundColor = [UIColor clearColor];
    answerLabel.font = [UIFont systemFontOfSize:15];
    [image_bottombg addSubview:answerLabel];
    [answerLabel release];
    
    m_replyView = [[UITextView alloc] initWithFrame:CGRectMake(15, image_bottombg.frame.origin.y + 20, 280, image_bottombg.frame.size.height - 25)];
    m_replyView.editable = NO;
    m_replyView.scrollEnabled = YES;
    m_replyView.showsVerticalScrollIndicator = NO;
    if([[[self.contentArray objectAtIndex:rowIndex] objectForKey:@"reply"] length] == 0)
    {
        m_replyView.text = @"暂未回复";
    }
    else
        m_replyView.text = [[self.contentArray objectAtIndex:rowIndex] objectForKey:@"reply"];
    [m_replyView setFont:[UIFont boldSystemFontOfSize:15]];
    [m_replyView setTextColor:[UIColor colorWithRed:153.0/255.0 green:0 blue:0 alpha:1.0]];
    [self.view addSubview:m_replyView];
    
    [image_middlebg release];
    [image_bottombg release];
}

@end
