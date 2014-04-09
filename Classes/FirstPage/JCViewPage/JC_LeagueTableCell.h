//
//  JC_LeagueTableCell.h
//  RuYiCai
//
//  Created by ruyicai on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
/*
 weiliang 
 联赛选择 tablecell
 包含 所有的 联赛复选框
 */

#import <UIKit/UIKit.h>
#import "JCLQ_PickGameViewController.h"
#import "JCZQ_PickGameViewController.h"
#import "JC_LeagueChooseViewController.h"
@class JC_LeagueChooseViewController;
@interface JC_LeagueTableCell : UITableViewCell
{
    JC_LeagueChooseViewController*             m_parentDelete;
    UIScrollView                            *scrollView;
    
    NSMutableArray                          *m_leagueArray;
    NSMutableArray                          *m_selectedLeagueArrayTag;
}
@property (nonatomic,retain) JC_LeagueChooseViewController* parentDelete;
@property (nonatomic,retain) NSMutableArray* leagueArray;
@property (nonatomic,retain) NSMutableArray* selectedLeagueArrayTag;

-(void) refreshTableCell;
-(void) buttonClick:(NSInteger) tag SELECT:(BOOL)isSelect;
@end
