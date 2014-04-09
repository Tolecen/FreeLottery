//
//  DataAnalysis_Asia_TableCell.h
//  RuYiCai
//
//  Created by ruyicai on 12-12-13.
//
//

#import <UIKit/UIKit.h>
@interface DataAnalysis_Asia_TableCell : UITableViewCell
{
    NSString*                               m_companyName;//公司名
    
    NSString*                               m_firstUpodds;//主队初盘赔率
    NSString*                               m_firstGoal;//初盘盘口
    NSString*                               m_firstDownodds;//客队初盘赔率
    
    NSString*                               m_upOdds;//主队即时赔率
    NSString*                               m_goal;//实时盘口
    NSString*                               m_downOdds;//客队即时赔率
    
    
    UILabel*                                m_companyNameLable;
    
    UILabel*                                m_firstUpoddsLable;
    UILabel*                                m_firstGoalLable;
    UILabel*                                m_firstDownoddsLable;
    
    UILabel*                                m_upOddsLable;
    UILabel*                                m_goalLable;
    UILabel*                                m_downOddsLable;
}

@property (nonatomic,retain) NSString* companyName;
@property (nonatomic,retain) NSString* firstUpodds;
@property (nonatomic,retain) NSString* firstGoal;
@property (nonatomic,retain) NSString* firstDownodds;

@property (nonatomic,retain) NSString* upOdds;
@property (nonatomic,retain) NSString* goal;
@property (nonatomic,retain) NSString* downOdds;

@property (nonatomic,assign) BOOL      isJCLQ;

-(void) refreshTableCell;

@end