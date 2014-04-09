//
//  CheckButton.m
//  RuYiCai
//
//  Created by ruyicai on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CheckButton.h"
@interface CheckButton (internal)
-(void) icoButtonClick;
-(void) ImageChange;
@end

@implementation CheckButton
@synthesize title = m_title;
@synthesize isSelect = m_isSelect;
@synthesize partentView = m_partentView;
 

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        lable = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 100, 40)];
        lable.textAlignment = UITextAlignmentCenter;
        lable.backgroundColor = [UIColor clearColor];
        lable.font = [UIFont systemFontOfSize:12];
        [self addSubview:lable];
 
        icoButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, 30, 30)];
        [icoButton addTarget:self action: @selector(icoButtonClick) forControlEvents:UIControlEventTouchUpInside];  
        [icoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        icoButton.titleLabel.font = [UIFont boldSystemFontOfSize:40];
        icoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [self addSubview:icoButton];
    }
    return self;
}
-(void) refreshButton
{
    lable.text = m_title;
    [self ImageChange];
}
-(void) icoButtonClick
{
    //设置图片 
    m_isSelect = !m_isSelect;
    [self ImageChange];
 
    if (m_partentView) {
        [m_partentView buttonClick:self.tag SELECT:m_isSelect];
    }
}
-(void) ImageChange
{
    if (m_isSelect) {
        [icoButton setBackgroundImage:[UIImage imageNamed:@"select2_select.png"] forState:UIControlStateNormal]; 
        [icoButton setBackgroundImage:[UIImage imageNamed:@"select_2.png"] forState:UIControlStateHighlighted];
    }
    else
    {
        [icoButton setBackgroundImage:[UIImage imageNamed:@"select_2.png"] forState:UIControlStateNormal]; 
        [icoButton setBackgroundImage:[UIImage imageNamed:@"select2_select.png"] forState:UIControlStateHighlighted]; 
    }
}

- (void)dealloc
{

    [m_title release];
    
    [icoButton release];
    [lable release];
    [super dealloc];
}
@end
