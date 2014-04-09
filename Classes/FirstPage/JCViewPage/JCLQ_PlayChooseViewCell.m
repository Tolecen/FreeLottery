//
//  JCLQ_PlayChooseViewCell.m
//  RuYiCai
//
//  Created by ruyicai on 12-4-26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "JCLQ_PlayChooseViewCell.h"
#import "RuYiCaiCommon.h"
#import "JCLQ_PickGameViewController.h"
@interface JCLQ_PlayChooseViewCell (internal)

-(void)ImageChange; 
-(void)ButtonClick:(id)sender;
@end

@implementation JCLQ_PlayChooseViewCell
@synthesize SFTitle = m_SFTitle;
@synthesize SFCTitle = m_SFCTitle;
@synthesize LetPointTitle = m_LetPointTitle;
@synthesize BigAndSmallTitle = m_BigAndSmallTitle;

@synthesize SFTitle_DanGuan = m_SFTitle_DanGuan;
@synthesize SFCTitle_DanGuan = m_SFCTitle_DanGuan;
@synthesize LetPointTitle_DanGuan = m_LetPointTitle_DanGuan;
@synthesize BigAndSmallTitle_DanGuan = m_BigAndSmallTitle_DanGuan;
@synthesize hunheTitle = m_hunheTitle;

@synthesize PlayTypeTag = m_PlayTypeTag;
@synthesize parentController = m_parentController;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView* bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        bgImage.image = [UIImage imageNamed:@"playchooseview_bg.png"];
        [self addSubview:bgImage];
        [bgImage release];
        
        UILabel *sfLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 80, 30)];
        sfLable.textAlignment = UITextAlignmentRight;
        sfLable.backgroundColor = [UIColor clearColor];
        sfLable.font = [UIFont boldSystemFontOfSize:12];
        sfLable.text = @"胜负:";
        [self addSubview:sfLable];
        [sfLable release];
        
        UILabel *letpointLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 25 + 35, 80, 30)];
        letpointLable.textAlignment = UITextAlignmentRight;
        letpointLable.backgroundColor = [UIColor clearColor];
        letpointLable.font = [UIFont boldSystemFontOfSize:12];
        letpointLable.text = @"让分胜负:";
        [self addSubview:letpointLable];
        [letpointLable release];
        
        UILabel *sfcLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 25 + 35 * 2, 80, 30)];
        sfcLable.textAlignment = UITextAlignmentRight;
        sfcLable.backgroundColor = [UIColor clearColor];
        sfcLable.font = [UIFont boldSystemFontOfSize:12];
        sfcLable.text = @"胜分差:";
        [self addSubview:sfcLable];
        [sfcLable release];
        
        UILabel *DXLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 25 + 35 * 3, 80, 30)];
        DXLable.textAlignment = UITextAlignmentRight;
        DXLable.backgroundColor = [UIColor clearColor];
        DXLable.font = [UIFont boldSystemFontOfSize:12];
        DXLable.text = @"大小分:";
        [self addSubview:DXLable];
        [DXLable release];
        
        UILabel *hunheLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 25 + 35 * 4, 80, 30)];
        hunheLable.textAlignment = UITextAlignmentRight;
        hunheLable.backgroundColor = [UIColor clearColor];
        hunheLable.font = [UIFont boldSystemFontOfSize:12];
        hunheLable.text = @"混合投注:";
        [self addSubview:hunheLable];
        [hunheLable release];
    }
    return self;
}

- (void)dealloc
{
    [m_SFTitle release];
    [m_SFCTitle release];
    [m_LetPointTitle release];
    [m_BigAndSmallTitle release];
    [m_SFTitle_DanGuan release];
    [m_SFCTitle_DanGuan release];
    [m_LetPointTitle_DanGuan release];
    [m_BigAndSmallTitle_DanGuan release];
    
    [m_SFButton release];
    [m_SFCButton release];
    [m_LetPointButton release];
    [m_BigAndSmallButton release];
    
    [m_SFButton_DanGuan release];
    [m_SFCButton_DanGuan release];
    [m_LetPointButton_DanGuan release];
    [m_BigAndSmallButton_DanGuan release];
    
    [m_hunheButton release];
    [super dealloc];
}

-(void)clearAllButtonBackGroundImage
{
    [m_SFButton setBackgroundImage:[UIImage imageNamed:@"jc_choose_normal.png"] forState:UIControlStateNormal];
    [m_SFButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [m_SFButton setBackgroundImage:[UIImage imageNamed:@"jc_choose_click.png"] forState:UIControlStateHighlighted];
    
    [m_SFCButton setBackgroundImage:[UIImage imageNamed:@"jc_choose_normal.png"] forState:UIControlStateNormal];
    [m_SFCButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [m_SFCButton setBackgroundImage:[UIImage imageNamed:@"jc_choose_click.png"] forState:UIControlStateHighlighted];
    
    [m_LetPointButton setBackgroundImage:[UIImage imageNamed:@"jc_choose_normal.png"] forState:UIControlStateNormal];
    [m_LetPointButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [m_LetPointButton setBackgroundImage:[UIImage imageNamed:@"jc_choose_click.png"] forState:UIControlStateHighlighted];
    
    [m_BigAndSmallButton setBackgroundImage:[UIImage imageNamed:@"jc_choose_normal.png"] forState:UIControlStateNormal];
    [m_BigAndSmallButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [m_BigAndSmallButton setBackgroundImage:[UIImage imageNamed:@"jc_choose_click.png"] forState:UIControlStateHighlighted]; 
    
    //单关
    [m_SFButton_DanGuan setBackgroundImage:[UIImage imageNamed:@"jc_choose_normal.png"] forState:UIControlStateNormal];
    [m_SFButton_DanGuan setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [m_SFButton_DanGuan setBackgroundImage:[UIImage imageNamed:@"jc_choose_click.png"] forState:UIControlStateHighlighted];
    
    [m_SFCButton_DanGuan setBackgroundImage:[UIImage imageNamed:@"jc_choose_normal.png"] forState:UIControlStateNormal];
    [m_SFCButton_DanGuan setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [m_SFCButton_DanGuan setBackgroundImage:[UIImage imageNamed:@"jc_choose_click.png"] forState:UIControlStateHighlighted];
    
    [m_LetPointButton_DanGuan setBackgroundImage:[UIImage imageNamed:@"jc_choose_normal.png"] forState:UIControlStateNormal];
    [m_LetPointButton_DanGuan setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [m_LetPointButton_DanGuan setBackgroundImage:[UIImage imageNamed:@"jc_choose_click.png"] forState:UIControlStateHighlighted]; 
    
    [m_BigAndSmallButton_DanGuan setBackgroundImage:[UIImage imageNamed:@"jc_choose_normal.png"] forState:UIControlStateNormal];
    [m_BigAndSmallButton_DanGuan setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [m_BigAndSmallButton_DanGuan setBackgroundImage:[UIImage imageNamed:@"jc_choose_click.png"] forState:UIControlStateHighlighted];
    
    [m_hunheButton setBackgroundImage:[UIImage imageNamed:@"jc_confusion_normal.png"] forState:UIControlStateNormal];
    [m_hunheButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [m_hunheButton setBackgroundImage:[UIImage imageNamed:@"jc_confusion_click.png"] forState:UIControlStateHighlighted];
}

-(void)ImageChange
{
    [self clearAllButtonBackGroundImage];
    //设置图片 
    if (m_PlayTypeTag == IJCLQPlayType_SF) {
        [m_SFButton setBackgroundImage:[UIImage imageNamed:@"jc_choose_click.png"] forState:UIControlStateNormal];
        
        [m_SFButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [m_SFButton setBackgroundImage:[UIImage imageNamed:@"jc_choose_click.png"] forState:UIControlStateHighlighted]; 
    }
    else if (m_PlayTypeTag == IJCLQPlayType_LetPoint) {
        [m_LetPointButton setBackgroundImage:[UIImage imageNamed:@"jc_choose_click.png"] forState:UIControlStateNormal];
        [m_LetPointButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [m_LetPointButton setBackgroundImage:[UIImage imageNamed:@"jc_choose_click.png"] forState:UIControlStateHighlighted]; 
    }
    else if (m_PlayTypeTag == IJCLQPlayType_SFC) {
        [m_SFCButton setBackgroundImage:[UIImage imageNamed:@"jc_choose_click.png"] forState:UIControlStateNormal];
        [m_SFCButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [m_SFCButton setBackgroundImage:[UIImage imageNamed:@"jc_choose_click.png"] forState:UIControlStateHighlighted]; 
    }
    else if (m_PlayTypeTag == IJCLQPlayType_BigAndSmall) {
        [m_BigAndSmallButton setBackgroundImage:[UIImage imageNamed:@"jc_choose_click.png"] forState:UIControlStateNormal];
        [m_BigAndSmallButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [m_BigAndSmallButton setBackgroundImage:[UIImage imageNamed:@"jc_choose_click.png"] forState:UIControlStateHighlighted]; 
    }
    else if (m_PlayTypeTag == IJCLQPlayType_SF_DanGuan) {
        [m_SFButton_DanGuan setBackgroundImage:[UIImage imageNamed:@"jc_choose_click.png"] forState:UIControlStateNormal];
        [m_SFButton_DanGuan setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [m_SFButton_DanGuan setBackgroundImage:[UIImage imageNamed:@"jc_choose_click.png"] forState:UIControlStateHighlighted]; 
    }
    
    else if (m_PlayTypeTag == IJCLQPlayType_LetPoint_DanGuan) {
        [m_LetPointButton_DanGuan setBackgroundImage:[UIImage imageNamed:@"jc_choose_click.png"] forState:UIControlStateNormal];
        [m_LetPointButton_DanGuan setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [m_LetPointButton_DanGuan setBackgroundImage:[UIImage imageNamed:@"jc_choose_click.png"] forState:UIControlStateHighlighted]; 
    }
    else if (m_PlayTypeTag == IJCLQPlayType_SFC_DanGuan) {
        [m_SFCButton_DanGuan setBackgroundImage:[UIImage imageNamed:@"jc_choose_click.png"] forState:UIControlStateNormal];
        [m_SFCButton_DanGuan setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [m_SFCButton_DanGuan setBackgroundImage:[UIImage imageNamed:@"jc_choose_click.png"] forState:UIControlStateHighlighted]; 
    }
    else if (m_PlayTypeTag == IJCLQPlayType_BigAndSmall_DanGuan) {
        [m_BigAndSmallButton_DanGuan setBackgroundImage:[UIImage imageNamed:@"jc_choose_click.png"] forState:UIControlStateNormal];
        [m_BigAndSmallButton_DanGuan setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [m_BigAndSmallButton_DanGuan setBackgroundImage:[UIImage imageNamed:@"jc_choose_click.png"] forState:UIControlStateHighlighted]; 
    }
    else if (m_PlayTypeTag == IJCLQPlayType_Confusion) {
        [m_hunheButton setBackgroundImage:[UIImage imageNamed:@"jc_confusion_click.png"] forState:UIControlStateNormal];
        [m_hunheButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [m_hunheButton setBackgroundImage:[UIImage imageNamed:@"jc_choose_click.png"] forState:UIControlStateHighlighted];
    }
    
}
-(void)ButtonClick:(id)sender
{
    int tag = [sender tag];
    if (tag == 0) {
        m_PlayTypeTag = IJCLQPlayType_SF;
    }
    else if(tag == 1)
    {
        m_PlayTypeTag = IJCLQPlayType_LetPoint;
    }
    else if(tag == 2)
    {
        m_PlayTypeTag = IJCLQPlayType_SFC;
    }
    else if(tag == 3)
    {
        m_PlayTypeTag = IJCLQPlayType_BigAndSmall;
    }
    
    
    else if(tag == 4)
    {
        m_PlayTypeTag = IJCLQPlayType_SF_DanGuan;
    }
    else if(tag == 5)
    {
        m_PlayTypeTag = IJCLQPlayType_LetPoint_DanGuan;
    }
    else if(tag == 6)
    {
        m_PlayTypeTag = IJCLQPlayType_SFC_DanGuan;
    }
    else if(tag == 7)
    {
        m_PlayTypeTag = IJCLQPlayType_BigAndSmall_DanGuan;
    }
    else if(tag == 8)
    {
        m_PlayTypeTag = IJCLQPlayType_Confusion;
    }
    [self ImageChange];
    [m_parentController playChooseButtonEvent];
}

-(void) RefreshCellView
{
    if (m_SFButton != nil) {
        [m_SFButton removeFromSuperview];
        [m_SFButton release];
    }
    if (m_SFCButton != nil) {
        [m_SFCButton removeFromSuperview];
        [m_SFCButton release];
    }
    if (m_LetPointButton != nil) {
        [m_LetPointButton removeFromSuperview];
        [m_LetPointButton release];
    }
    if (m_BigAndSmallButton != nil) {
        [m_BigAndSmallButton removeFromSuperview];
        [m_BigAndSmallButton release];
    }
    
    if (m_SFButton_DanGuan != nil) {
        [m_SFButton_DanGuan removeFromSuperview];
        [m_SFButton_DanGuan release];
    }
    if (m_SFCButton_DanGuan != nil) {
        [m_SFCButton_DanGuan removeFromSuperview];
        [m_SFCButton_DanGuan release];
    }
    if (m_LetPointButton_DanGuan != nil) {
        [m_LetPointButton_DanGuan removeFromSuperview];
        [m_LetPointButton_DanGuan release];
    }
    if (m_BigAndSmallButton_DanGuan != nil) {
        [m_BigAndSmallButton_DanGuan removeFromSuperview];
        [m_BigAndSmallButton_DanGuan release];
    }
    if (m_hunheButton != nil) {
        [m_hunheButton removeFromSuperview];
        [m_hunheButton release];
    }
 
    m_SFButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 25, 65, 30)];
    [m_SFButton addTarget:self action: @selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside]; 
    m_SFButton.tag = 0;
    [m_SFButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    m_SFButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    m_SFButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    m_SFButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [m_SFButton setTitle:m_SFTitle forState:UIControlStateNormal];
    [self addSubview:m_SFButton];
    
    m_LetPointButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 25 + 35, 65, 30)];
    [m_LetPointButton addTarget:self action: @selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];  
    m_LetPointButton.tag = 1;
    [m_LetPointButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    m_LetPointButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    m_LetPointButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    m_LetPointButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [m_LetPointButton setTitle:m_LetPointTitle forState:UIControlStateNormal];
    [self addSubview:m_LetPointButton];
    
    
    m_SFCButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 25 + 35 * 2, 65, 30)];
    [m_SFCButton addTarget:self action: @selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];  
    m_SFCButton.tag = 2;
    [m_SFCButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    m_SFCButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    m_SFCButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    m_SFCButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [m_SFCButton setTitle:m_SFCTitle forState:UIControlStateNormal];
    [self addSubview:m_SFCButton];
     
    m_BigAndSmallButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 25 + 35 * 3, 65, 30)];
    [m_BigAndSmallButton addTarget:self action: @selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];  
    m_BigAndSmallButton.tag = 3;
    [m_BigAndSmallButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    m_BigAndSmallButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    m_BigAndSmallButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    m_BigAndSmallButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [m_BigAndSmallButton setTitle:m_BigAndSmallTitle forState:UIControlStateNormal];
    [self addSubview:m_BigAndSmallButton];
 
    //单关
    m_SFButton_DanGuan = [[UIButton alloc] initWithFrame:CGRectMake(175, 25, 65, 30)];
    [m_SFButton_DanGuan addTarget:self action: @selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside]; 
    m_SFButton_DanGuan.tag = 4;
    [m_SFButton_DanGuan setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    m_SFButton_DanGuan.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    m_SFButton_DanGuan.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    m_SFButton_DanGuan.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [m_SFButton_DanGuan setTitle:m_SFTitle_DanGuan forState:UIControlStateNormal];
    [self addSubview:m_SFButton_DanGuan];
    
    m_LetPointButton_DanGuan = [[UIButton alloc] initWithFrame:CGRectMake(175, 25 + 35, 65, 30)];
    [m_LetPointButton_DanGuan addTarget:self action: @selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];  
    m_LetPointButton_DanGuan.tag = 5;
    [m_LetPointButton_DanGuan setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    m_LetPointButton_DanGuan.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    m_LetPointButton_DanGuan.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    m_LetPointButton_DanGuan.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [m_LetPointButton_DanGuan setTitle:m_LetPointTitle_DanGuan forState:UIControlStateNormal];
    [self addSubview:m_LetPointButton_DanGuan];
    
    
    m_SFCButton_DanGuan = [[UIButton alloc] initWithFrame:CGRectMake(175, 25 + 35 * 2, 65, 30)];
    [m_SFCButton_DanGuan addTarget:self action: @selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];  
    m_SFCButton_DanGuan.tag = 6;
    [m_SFCButton_DanGuan setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    m_SFCButton_DanGuan.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    m_SFCButton_DanGuan.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    m_SFCButton_DanGuan.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [m_SFCButton_DanGuan setTitle:m_SFCTitle_DanGuan forState:UIControlStateNormal];
    [self addSubview:m_SFCButton_DanGuan];
    
    m_BigAndSmallButton_DanGuan = [[UIButton alloc] initWithFrame:CGRectMake(175, 25 + 35 * 3, 65, 30)];
    [m_BigAndSmallButton_DanGuan addTarget:self action: @selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];  
    m_BigAndSmallButton_DanGuan.tag = 7;
    [m_BigAndSmallButton_DanGuan setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    m_BigAndSmallButton_DanGuan.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    m_BigAndSmallButton_DanGuan.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    m_BigAndSmallButton_DanGuan.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [m_BigAndSmallButton_DanGuan setTitle:m_BigAndSmallTitle_DanGuan forState:UIControlStateNormal];
    [self addSubview:m_BigAndSmallButton_DanGuan];
    
    m_hunheButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 25 + 35 * 4, 130, 30)];
    [m_hunheButton addTarget:self action: @selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    m_hunheButton.tag = 8;
    [m_hunheButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    m_hunheButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    m_hunheButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    m_hunheButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [m_hunheButton setTitle:m_hunheTitle forState:UIControlStateNormal];
    [self addSubview:m_hunheButton];

    [self ImageChange];
}
@end
