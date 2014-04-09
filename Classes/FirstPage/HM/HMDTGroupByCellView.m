//
//  HMDTGroupByCellView.m
//  RuYiCai
//
//  Created by LiTengjie on 11-10-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HMDTGroupByCellView.h"
#import "HMDTBetCaseLotViewController.h"
#import "HMDTGroupByViewController.h"
#import "RYCImageNamed.h"
#import "RuYiCaiCommon.h"
#import "NSLog.h"
#import "ColorUtils.h"
#import "Custom_tabbar.h"
 
#define kMaxOffsetXOK (10)
#define kMaxOffsetYOK (10)

@interface HMDTGroupByCellView (internal)
-(NSInteger)creatIcoImage:(NSInteger)widthIndex ICONAME:(NSString*)icoName ICONUM:(NSInteger)icoNum;
//-(NSInteger)creatIcoNumLable:(NSInteger)widthIndex   ICONUM:(NSInteger)icoNum;
@end

@implementation HMDTGroupByCellView
 
@synthesize caseLotId = m_caseLotId;
@synthesize starter = m_starter;
@synthesize starterUserNo = m_starterUserNo;
@synthesize totalAmt = m_totalAmt;
@synthesize safeAmt = m_safeAmt;
@synthesize buyAmt = m_buyAmt;
@synthesize progressInfo = m_progressInfo;
 
@synthesize graygoldStar = m_graygoldStar;
@synthesize graydiamond = m_graydiamond;
@synthesize graycup = m_graycup;
@synthesize graycrown = m_graycrown;

@synthesize goldStar = m_goldStar;
@synthesize diamond = m_diamond;
@synthesize cup = m_cup;
@synthesize crown = m_crown;
@synthesize lotNo = m_lotNo;
@synthesize batchCode = m_batchCode;
 
@synthesize superViewController = m_superViewController;
@synthesize isTop = m_isTop;
@synthesize safeRate = m_safeRate;

@synthesize nameLabel = _nameLabel ;
@synthesize progressNumLabel = _progressNumLabel ;
@synthesize schemeTextLabel = _schemeTextLabel;
@synthesize titleLabel = _titleLabel;

- (void)dealloc 
{
    [m_lotNameLable release];
    [m_starterLabel release];
    [m_progressInfoLabel release];
    [m_totalAmtLabel release];
    
    [_nameLabel release];
    [_progressNumLabel release];
    [_schemeTextLabel release];
    [_titleLabel release];
 
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame 
{    
    self = [super initWithFrame:frame];
    if (self) 
    {
        m_beganTouchPt = CGPointZero;
        
//        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:RYCImageNamed(@"hm_list_box.png")];
//        bgImageView.frame = CGRectMake(5, 5, 305, 80);
//        [self addSubview:bgImageView];
//        [bgImageView release];
// 
//        m_lotNameLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 80, 30)];
//        m_lotNameLable.font = [UIFont systemFontOfSize:16];
//        m_lotNameLable.textColor = [UIColor whiteColor];
//        m_lotNameLable.backgroundColor = [UIColor clearColor];
//        m_lotNameLable.textAlignment = UITextAlignmentCenter;
//        [self addSubview:m_lotNameLable];
//     
//        m_starterLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 5, 100, 40)];
//        m_starterLabel.text = @"发起人:";
//        m_starterLabel.font = [UIFont systemFontOfSize:12];
//        m_starterLabel.lineBreakMode = UILineBreakModeCharacterWrap;
//        m_starterLabel.numberOfLines = 2;
//        m_starterLabel.textColor = [UIColor blackColor];
//        m_starterLabel.backgroundColor = [UIColor clearColor];
//        m_starterLabel.textAlignment = UITextAlignmentLeft;
//        [self addSubview:m_starterLabel];
//        
//        UILabel* totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 40, 80, 20)];
//        totalLabel.text = @"方案总额";
//        totalLabel.font = [UIFont systemFontOfSize:12];
//        totalLabel.backgroundColor = [UIColor clearColor];
//        totalLabel.textAlignment = UITextAlignmentLeft;
//        [self addSubview:totalLabel];
//        [totalLabel release];
//        
//        m_totalAmtLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 100, 30)];
//        m_totalAmtLabel.text = @"0元";
//        m_totalAmtLabel.textColor = [UIColor redColor];
//        m_totalAmtLabel.font = [UIFont systemFontOfSize:12];
//        m_totalAmtLabel.backgroundColor = [UIColor clearColor];
//        m_totalAmtLabel.textAlignment = UITextAlignmentCenter;
//        [self addSubview:m_totalAmtLabel];
// 
//        UILabel* progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 40, 100, 20)];
//        progressLabel.text = @"进度";
//        progressLabel.font = [UIFont systemFontOfSize:12];
//        progressLabel.backgroundColor = [UIColor clearColor];
//        progressLabel.textAlignment = UITextAlignmentLeft;
//        [self addSubview:progressLabel];
//        [progressLabel release];
//        
//        m_progressInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 50, 100, 30)];
//        m_progressInfoLabel.text = @"0";
//        m_progressInfoLabel.textColor = [UIColor redColor];
//        m_progressInfoLabel.font = [UIFont systemFontOfSize:12];
//        m_progressInfoLabel.backgroundColor = [UIColor clearColor];
//        m_progressInfoLabel.textAlignment = UITextAlignmentCenter;
//        [self addSubview:m_progressInfoLabel];
// 
//        
//        UILabel* autoOrder = [[UILabel alloc] initWithFrame:CGRectMake(190, 40, 100, 20)];
//        autoOrder.text = @"参与合买";
//        autoOrder.textColor = [UIColor blackColor];
//        autoOrder.font = [UIFont systemFontOfSize:12];
//        autoOrder.backgroundColor = [UIColor clearColor];
//        autoOrder.textAlignment = UITextAlignmentCenter;
//        [self addSubview:autoOrder];
//        [autoOrder release];
//        
//        UILabel* autoOrder2 = [[UILabel alloc] initWithFrame:CGRectMake(190, 60, 100, 20)];
//        autoOrder2.text = @"定制跟单";
//        autoOrder2.textColor = [UIColor blackColor];
//        autoOrder2.font = [UIFont systemFontOfSize:12];
//        autoOrder2.backgroundColor = [UIColor clearColor];
//        autoOrder2.textAlignment = UITextAlignmentCenter;
//        [self addSubview:autoOrder2];
//        [autoOrder2 release];
//     
        
        
        //----------------------------------------------------------------------
        UIImageView *cellMainBackGroundImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"backGroundImg.png"]];
        cellMainBackGroundImgView.frame = CGRectMake(3, 3, 314, 84);
        [self addSubview:cellMainBackGroundImgView];
        [cellMainBackGroundImgView release];
        
        CGRect cacheFrame ;
        UIImageView *titleBackGroundImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"iconBackGround.png"]];
        titleBackGroundImgView.frame = CGRectMake(6, 6, titleBackGroundImgView.frame.size.width/2, titleBackGroundImgView.frame.size.height/2);
        [self addSubview:titleBackGroundImgView];
        cacheFrame = titleBackGroundImgView.frame;
        [titleBackGroundImgView release];
        
        self.titleLabel = [[[UILabel alloc]initWithFrame:CGRectMake(6, 6, cacheFrame.size.width , cacheFrame.size.height )]autorelease];
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textColor = [ColorUtils parseColorFromRGB:@"#ebebeb"];
        self.titleLabel.text = @"竞彩足球";
        [self addSubview:self.titleLabel];
        
        UIImageView *perImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"iconOfPeople.png"]];
        perImgView.frame = CGRectMake(cacheFrame.origin.x + cacheFrame.size.width + 18, 13, perImgView.frame.size.width / 2, perImgView.frame.size.height / 2);
        [self addSubview:perImgView];
        cacheFrame = perImgView.frame;
        [perImgView release];
        
        self.nameLabel = [[[UILabel alloc]initWithFrame:CGRectMake(cacheFrame.origin.x + 18, cacheFrame.origin.y, 100, cacheFrame.size.height)]autorelease];
        [self.nameLabel setBackgroundColor:[UIColor clearColor]];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.font = [UIFont boldSystemFontOfSize:11];
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.text = @"发起人 : 远方博彩";
        [self addSubview:self.nameLabel];
        
        UILabel *progressTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 30, 40, 40)];
        [progressTitleLabel setBackgroundColor:[UIColor clearColor]];
        progressTitleLabel.text = @"进度";
        progressTitleLabel.textColor = [ColorUtils parseColorFromRGB:@"#646464"];
        progressTitleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:progressTitleLabel];
        [progressTitleLabel release];
        
        self.progressNumLabel = [[[UILabel alloc]initWithFrame:CGRectMake(25, 50, 100, 40)]autorelease];
        [self.progressNumLabel setBackgroundColor:[UIColor clearColor]];
        self.progressNumLabel.text = @"85%(+98%)";
        self.progressNumLabel.textColor = [ColorUtils parseColorFromRGB:@"#a90000"];
        self.progressNumLabel.font = [UIFont boldSystemFontOfSize:14];
        [self addSubview:self.progressNumLabel];
        
        UILabel *schemeTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(140, 30, 100, 40)];
        [schemeTitleLabel setBackgroundColor:[UIColor clearColor]];
        schemeTitleLabel.text = @"方案总额";
        schemeTitleLabel.textColor = [ColorUtils parseColorFromRGB:@"#646464"];
        schemeTitleLabel.font = [UIFont boldSystemFontOfSize:12];
        [self addSubview:schemeTitleLabel];
        [schemeTitleLabel release];
        
        self.schemeTextLabel = [[[UILabel alloc]initWithFrame:CGRectMake(145, 50, 100, 40)] autorelease];
        [self.schemeTextLabel setBackgroundColor:[UIColor clearColor]];
        self.schemeTextLabel.text = @"987654元";
        self.schemeTextLabel.textColor = [ColorUtils parseColorFromRGB:@"#3c3c3c"];
        self.schemeTextLabel.font = [UIFont boldSystemFontOfSize:14];
        [self addSubview:self.schemeTextLabel];
        
     
        UIButton *accessoryBtn = [[UIButton alloc]initWithFrame:CGRectMake(290, 50, 8, 16)];
        [accessoryBtn setBackgroundImage:[UIImage imageNamed:@"accessory_c_normal.png"] forState:UIControlStateNormal];
        [accessoryBtn setBackgroundImage:[UIImage imageNamed:@"accessory_c_normal.png"] forState:UIControlStateHighlighted];
        accessoryBtn.tag = 0;
        [self addSubview:accessoryBtn];
        [accessoryBtn release];
    }
    return self;
}

- (void)refreshView
{
//    m_lotNameLable.text = self.lotName;
//    m_starterLabel.text = [NSString stringWithFormat:@"发起人：%@",self.starter];
//    
//    m_totalAmtLabel.text = [NSString stringWithFormat:@"%d元", ([self.totalAmt intValue] / 100)];
//
//    NSString* progress = [NSString stringWithFormat:@"%@" ,self.progressInfo ];
//    progress = [progress stringByAppendingString:@"%+(保"];
//    
//    progress = [progress stringByAppendingFormat:@"%@" ,self.safeRate];
//    progress = [progress stringByAppendingString:@"%)"];
//    
//    m_progressInfoLabel.text = progress;
// 
//    
    _titleLabel.text = self.lotName;
    _nameLabel.text = [NSString stringWithFormat:@"发起人 ： %@",self.starter];
    
    _schemeTextLabel.text = [NSString stringWithFormat:@"%d元", ([self.totalAmt intValue] / 100)];
    
    NSString* progress = [NSString stringWithFormat:@"%@" ,self.progressInfo ];
    progress = [progress stringByAppendingString:@"%+(保"];
    
    progress = [progress stringByAppendingFormat:@"%@" ,self.safeRate];
    progress = [progress stringByAppendingString:@"%)"];
    
    _progressNumLabel.text = progress;
    
    
    if([self.isTop isEqualToString:@"true"])
    {
        UIImageView*  zhiDengImg = [[UIImageView alloc] initWithFrame:CGRectMake(285, 5, 27, 18)];
        zhiDengImg.image = RYCImageNamed(@"hm_top.png");
        [zhiDengImg setBackgroundColor:[UIColor clearColor]];
        [self addSubview:zhiDengImg];
        [zhiDengImg release];
    }

    int widthIndex = 210;
    icoHeightIndex = 13;
     
    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"crown.png" ICONUM:m_crown];
    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"graycrown.png" ICONUM:m_graycrown];
    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"cup.png" ICONUM:m_cup];
    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"graycup.png" ICONUM:m_graycup];
    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"diamond.png" ICONUM:m_diamond];
    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"graydiamond.png" ICONUM:m_graydiamond];
    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"goldStar.png" ICONUM:m_goldStar];
    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"graygoldStar.png" ICONUM:m_graygoldStar];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    m_beganTouchPt = [[touches anyObject] locationInView:self];
    //设置 accessoryButton 点击样式
    NSArray *library = [self subviews];
    id bt = [library objectAtIndex:[library count]-1];
    if ([bt isKindOfClass:[UIButton class]]) {
        [bt setHighlighted:YES];
    }   
}
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    //设置 accessoryButton 点击样式
    NSArray *library = [self subviews];
    id bt = [library objectAtIndex:[library count]-1];
    if ([bt isKindOfClass:[UIButton class]]) {
        [bt setHighlighted:NO];
    }
    
    CGPoint pt = [[touches anyObject] locationInView:self];
    CGFloat xOffset = (pt.x > m_beganTouchPt.x) ? (pt.x - m_beganTouchPt.x) : (m_beganTouchPt.x - pt.x);
    CGFloat yOffset = (pt.y > m_beganTouchPt.y) ? (pt.y - m_beganTouchPt.y) : (m_beganTouchPt.y - pt.y);
    if (xOffset <= kMaxOffsetXOK && yOffset <= kMaxOffsetYOK)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
        HMDTBetCaseLotViewController* viewController = [[HMDTBetCaseLotViewController alloc] init];
        viewController.caseLotId = self.caseLotId;
        viewController.lotNo = self.lotNo;
        viewController.starterUserNo = self.starterUserNo;
//        viewController.batchCode = self.batchCode;
        viewController.prizeState = @"0";//未开奖
        viewController.winAmount = @"0";//中奖金额
        [self.superViewController.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
}
 
-(NSInteger)creatIcoImage:(NSInteger)widthIndex ICONAME:(NSString*)icoName ICONUM:(NSInteger)icoNum
{
    NSInteger width = widthIndex;
    if (icoNum > 0) {
        if (width > 290) {
            icoHeightIndex = 30;
            width  = 210;
        }
        UIImageView*  ico = [[UIImageView alloc] initWithFrame:CGRectMake(width,icoHeightIndex,13,13)];
        ico.image = RYCImageNamed(icoName);
        [ico setBackgroundColor:[UIColor clearColor]];
        [self addSubview:ico];
        [ico release];
        
        if (icoNum > 1) {
            UILabel* icoNumLable = [[UILabel alloc] initWithFrame:CGRectMake(width + 2, icoHeightIndex + 2, 13, 13)];
            icoNumLable.backgroundColor = [UIColor clearColor];
            icoNumLable.textAlignment = UITextAlignmentRight;
            icoNumLable.text = [NSString stringWithFormat:@"%d",icoNum];
            icoNumLable.textColor = [UIColor colorWithRed:148.0/255.0 green:118.0/255.0 blue:0.0/255.0 alpha:1.0];
            icoNumLable.font = [UIFont systemFontOfSize:9];
            [self addSubview:icoNumLable];
            [icoNumLable release];
        }
        width += 15;
    }
 
    return width;
}

@end
