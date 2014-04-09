//
//  PlayIntroduceViewController.m
//  RuYiCai
//
//  Created by  on 12-7-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PlayIntroduceViewController.h"
#import "SBJsonParser.h"
#import "RuYiCaiNetworkManager.h"
#import "RYCImageNamed.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"
#import "ColorUtils.h"

@implementation PlayIntroduceViewController

@synthesize lotNo;
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    
//
//    [super viewWillDisappear:animated];
//}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"querySampleNetOK" object:nil];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    
    if ([self.lotNo isEqualToString:kLotNoNMK3]) {
        
        //快三返回按钮
        [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back) andAutoPopView:NO normalImage:@"KS_back_normal.png" highlightedImage:@"KS_back_highlighted.png"];
    }else{
        [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back) andAutoPopView:NO];
    }
    
    self.title = @"玩法介绍";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(querySampleNetOK:) name:@"querySampleNetOK" object:nil];
    
    if ([self.lotNo isEqualToString:kLotNoNMK3]) {
        
        self.view.backgroundColor = [ColorUtils parseColorFromRGB:@"#004b47"];

    }else{
        
        [self setMainView];
    }
    
    NSMutableDictionary*  tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [tempDic setObject:@"information" forKey:@"command"];
    [tempDic setObject:@"playIntroduce" forKey:@"newsType"];
    [tempDic setObject:self.lotNo forKey:@"lotno"];

    [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_BASE;
    [[RuYiCaiNetworkManager sharedManager] querySampleLotNetRequest:tempDic isShowProgress:YES];
}

- (void)setMainView
{
    UIImageView *image_topbg = [[UIImageView alloc] initWithFrame:CGRectMake(9, 10, 302, 34)];
    image_topbg.image = RYCImageNamed(@"reply_top.png");
    [self.view addSubview:image_topbg];
    [image_topbg release];
    
    UIImageView *image_middlebg = [[UIImageView alloc] initWithFrame:CGRectMake(9, 33, 302, 10)];
    image_middlebg.image = RYCImageNamed(@"reply_middle.png");
    [self.view addSubview:image_middlebg];
    
    UIImageView *image_bottombg = [[UIImageView alloc] initWithFrame:CGRectMake(9, image_middlebg.frame.origin.y + image_middlebg.frame.size.height, 302, [UIScreen mainScreen].bounds.size.height - 74 - image_middlebg.frame.origin.y - image_middlebg.frame.size.height)];
    image_bottombg.image = RYCImageNamed(@"reply_bottom.png");
    [self.view addSubview:image_bottombg];
    [image_bottombg release];
    [image_middlebg release];
}

- (void)querySampleNetOK:(NSNotification*)notification
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[CommonRecordStatus commonRecordStatusManager].sampleNetStr];
    [jsonParser release];
    
    NSString* dict = [parserDict objectForKey:@"title"];
    NSString* content = [parserDict objectForKey:@"introduce"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(9, 15, 302, 25)];
    label.textAlignment = UITextAlignmentCenter;
    label.text = dict;
    label.backgroundColor = [UIColor clearColor];
        [self.view addSubview:label];
    [label release];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(9, 46, 301, [UIScreen mainScreen].bounds.size.height - 122)];
    textView.text = content;
    textView.editable = NO;
    [textView setFont:[UIFont systemFontOfSize:14]];
    
    if ([self.lotNo isEqualToString:kLotNoNMK3]) {
        [label setTextColor:[ColorUtils parseColorFromRGB:@"#c3e8e9"]];
        [textView setTextColor:[ColorUtils parseColorFromRGB:@"#c3e8e9"]];

    }else{
        [label setTextColor:[UIColor brownColor]];
        [textView setTextColor:[UIColor blackColor]];

    }
    
    [textView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:textView];
    [textView release];
}

-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
