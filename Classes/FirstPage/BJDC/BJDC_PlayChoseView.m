//
//  BJDC_PlayChoseView.m
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 13-4-24.
//
//

#import "BJDC_PlayChoseView.h"
#import "RuYiCaiCommon.h"
#import "BJDC_pickNumViewController.h"

#define kButtonTagStart (22)

@implementation BJDC_PlayChoseView

@synthesize parentController = m_parentController;

- (void)dealloc
{
    [m_SPFButton release], m_SPFButton = nil;
    [m_AllJinQiuButton release], m_AllJinQiuButton = nil;
    [m_ScoreButton release], m_ScoreButton = nil;
    [m_HalfAndAllButton release], m_HalfAndAllButton = nil;
    [m_UpAndDownButton release], m_UpAndDownButton = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView* bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        bgImage.image = [UIImage imageNamed:@"playchooseview_bg.png"];
        [self addSubview:bgImage];
        [bgImage release];
        
        m_SPFButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 25, 105, 30)];
        [m_SPFButton addTarget:self action: @selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        m_SPFButton.tag = kButtonTagStart;
        [m_SPFButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [m_SPFButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        m_SPFButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [m_SPFButton setTitle:@"让球胜平负" forState:UIControlStateNormal];
        [m_SPFButton setBackgroundImage:[UIImage imageNamed:@"jc_choose_normal.png"] forState:UIControlStateNormal];
        [m_SPFButton setBackgroundImage:[UIImage imageNamed:@"jc_choose_click.png"] forState:UIControlStateSelected];
        m_SPFButton.selected = YES;
        [self addSubview:m_SPFButton];
        
        m_AllJinQiuButton = [[UIButton alloc] initWithFrame:CGRectMake(136, 25, 105, 30)];
        [m_AllJinQiuButton addTarget:self action: @selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        m_AllJinQiuButton.tag = kButtonTagStart + 1;
        [m_AllJinQiuButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        m_AllJinQiuButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [m_AllJinQiuButton setTitle:@"总进球数" forState:UIControlStateNormal];
        [m_AllJinQiuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [m_AllJinQiuButton setBackgroundImage:[UIImage imageNamed:@"jc_choose_normal.png"] forState:UIControlStateNormal];
        [m_AllJinQiuButton setBackgroundImage:[UIImage imageNamed:@"jc_choose_click.png"] forState:UIControlStateSelected];
        [self addSubview:m_AllJinQiuButton];
        
        m_ScoreButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 70, 105, 30)];
        [m_ScoreButton addTarget:self action: @selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        m_ScoreButton.tag = kButtonTagStart + 2;
        [m_ScoreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        m_ScoreButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [m_ScoreButton setTitle:@"比分" forState:UIControlStateNormal];
        [m_ScoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [m_ScoreButton setBackgroundImage:[UIImage imageNamed:@"jc_choose_normal.png"] forState:UIControlStateNormal];
        [m_ScoreButton setBackgroundImage:[UIImage imageNamed:@"jc_choose_click.png"] forState:UIControlStateSelected];
        [self addSubview:m_ScoreButton];

        m_HalfAndAllButton = [[UIButton alloc] initWithFrame:CGRectMake(136, 70, 105, 30)];
        [m_HalfAndAllButton addTarget:self action: @selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        m_HalfAndAllButton.tag = kButtonTagStart + 3;
        [m_HalfAndAllButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        m_HalfAndAllButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [m_HalfAndAllButton setTitle:@"半全场" forState:UIControlStateNormal];
        [m_HalfAndAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [m_HalfAndAllButton setBackgroundImage:[UIImage imageNamed:@"jc_choose_normal.png"] forState:UIControlStateNormal];
        [m_HalfAndAllButton setBackgroundImage:[UIImage imageNamed:@"jc_choose_click.png"] forState:UIControlStateSelected];
        [self addSubview:m_HalfAndAllButton];

        m_UpAndDownButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 115, 105, 30)];
        [m_UpAndDownButton addTarget:self action: @selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        m_UpAndDownButton.tag = kButtonTagStart + 4;
        [m_UpAndDownButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        m_UpAndDownButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [m_UpAndDownButton setTitle:@"上下单双" forState:UIControlStateNormal];
        [m_UpAndDownButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [m_UpAndDownButton setBackgroundImage:[UIImage imageNamed:@"jc_choose_normal.png"] forState:UIControlStateNormal];
        [m_UpAndDownButton setBackgroundImage:[UIImage imageNamed:@"jc_choose_click.png"] forState:UIControlStateSelected];
        [self addSubview:m_UpAndDownButton];

    }
    return self;
}


- (void)buttonClick:(UIButton*)tempButton
{
    switch (tempButton.tag) {
        case kButtonTagStart:
        {
            self.parentController.playTypeTag = IBJDCPlayType_RQ_SPF;
            m_SPFButton.selected = YES;
            m_AllJinQiuButton.selected = NO;
            m_ScoreButton.selected = NO;
            m_HalfAndAllButton.selected = NO;
            m_UpAndDownButton.selected = NO;
        } break;
        case kButtonTagStart + 1:
        {
            self.parentController.playTypeTag = IBJDCPlayType_ZJQ;
            m_SPFButton.selected = NO;
            m_AllJinQiuButton.selected = YES;
            m_ScoreButton.selected = NO;
            m_HalfAndAllButton.selected = NO;
            m_UpAndDownButton.selected = NO;
        } break;
        case kButtonTagStart + 2:
        {
            self.parentController.playTypeTag = IBJDCPlayType_Score;
            m_SPFButton.selected = NO;
            m_AllJinQiuButton.selected = NO;
            m_ScoreButton.selected = YES;
            m_HalfAndAllButton.selected = NO;
            m_UpAndDownButton.selected = NO;
        } break;
        case kButtonTagStart + 3:
        {
            self.parentController.playTypeTag = IBJDCPlayType_HalfAndAll;
            m_SPFButton.selected = NO;
            m_AllJinQiuButton.selected = NO;
            m_ScoreButton.selected = NO;
            m_HalfAndAllButton.selected = YES;
            m_UpAndDownButton.selected = NO;
        } break;
        case kButtonTagStart + 4:
        {
            self.parentController.playTypeTag = IBJDCPlayType_SXDS;
            m_SPFButton.selected = NO;
            m_AllJinQiuButton.selected = NO;
            m_ScoreButton.selected = NO;
            m_HalfAndAllButton.selected = NO;
            m_UpAndDownButton.selected = YES;
        } break;
        default:
            break;
    }
    [self.parentController playChooseButtonEvent];
}

@end
