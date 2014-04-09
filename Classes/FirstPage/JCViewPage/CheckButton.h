//
//  CheckButton.h
//  RuYiCai
//
//  Created by ruyicai on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
/*
 自定义 复选框
 竞彩筛选里边 有用到
 */
#import <UIKit/UIKit.h>
#import "JCLQ_PickGameViewController.h"
#import "JCZQ_PickGameViewController.h"
#import "JC_LeagueTableCell.h"
@interface CheckButton : UIButton
{
    UIButton                        *icoButton;
    UILabel                         *lable;
    NSString                        *m_title;
    
    JC_LeagueTableCell*             m_partentView;
    BOOL                            m_isSelect;
}
@property (nonatomic,retain) NSString* title;
@property (nonatomic,assign) BOOL isSelect;
 
 
@property (nonatomic,retain) JC_LeagueTableCell* partentView;
-(void) refreshButton;

@end
