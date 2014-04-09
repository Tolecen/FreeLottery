//
//  HelpContentViewController.m
//  RuYiCai
//
//  Created by  on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HelpContentViewController.h"
#import "SBJsonParser.h"
#import "RuYiCaiNetworkManager.h"
#import "BackBarButtonItemUtils.h"
#import "ColorUtils.h"
#import "AdaptationUtils.h"

@implementation HelpContentViewController

@synthesize contentId = m_contentId;
@synthesize contentTitle = m_contentTitle;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryHelpContentOK" object:nil];
    [m_contentView release];
    [m_contentTitle release];    
    [super dealloc];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryHelpContentOK:) name:@"queryHelpContentOK" object:nil];
    [self.view setBackgroundColor:[ColorUtils parseColorFromRGB:@"#efede9"]];
    
    UILabel *contentLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, 320,20)];
    [contentLable setText:self.contentTitle];
    contentLable.textAlignment = UITextAlignmentCenter;
    contentLable.backgroundColor = [UIColor clearColor];
    contentLable.textColor = [UIColor blackColor];
    contentLable.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:contentLable];
    
    
    m_contentView = [[UITextView alloc] initWithFrame:CGRectMake(0, 35, 320, [UIScreen mainScreen].bounds.size.height - 64)];
    m_contentView.backgroundColor = [UIColor clearColor];
    m_contentView.editable = NO;
    m_contentView.textColor = [UIColor blackColor];
    m_contentView.font = [UIFont systemFontOfSize:15.0f];
    [self.view addSubview:m_contentView];
    
    
    [RuYiCaiNetworkManager sharedManager].netHelpCenterCenter = NET_HELP_QUERY_CONTENT;
    [[RuYiCaiNetworkManager sharedManager] queryHelpContentWithId:self.contentId];
}

- (void)queryHelpContentOK:(NSNotification*)notification
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    [jsonParser release];

    m_contentView.text = [parserDict objectForKey:@"content"];
}

@end
