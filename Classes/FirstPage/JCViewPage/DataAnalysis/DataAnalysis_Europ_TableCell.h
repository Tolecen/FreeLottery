//
//  DataAnalysis_Europ_TableCell.h
//  RuYiCai
//
//  Created by ruyicai on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataAnalysis_Europ_TableCell : UITableViewCell
{
    BOOL                                    m_isJCLQ;
    NSString*                               m_companyName;//公司名
 
    NSString*                               m_homeWin;//胜
    NSString*                               m_standoff;//平
    NSString*                               m_guestWin;//负
    
    NSString*                               m_homeWinLu;//即时主胜赔率
    NSString*                               m_standoffLu;//即时平局赔率
    NSString*                               m_guestWinLu;//即时客胜赔率
 
    NSString*                               m_k_h;//主凯指
    NSString*                               m_k_s;//平凯指
    NSString*                               m_k_g;//客凯指
 
    NSString*                               m_fanHuanLu;//返还率
    
    UILabel*                                m_companyNameLable;
    
    UILabel*                                m_homeWinLable;
    UILabel*                                m_standoffLable;
    UILabel*                                m_guestWinLable;
 
    UILabel*                                m_homeWinLuLable;
    UILabel*                                m_standoffLuLable;
    UILabel*                                m_guestWinLuLable;

    UILabel*                                m_k_hLable;
    UILabel*                                m_k_sLable;
    UILabel*                                m_k_gLable;
    UILabel*                                m_fanHuanLuLable;

}
@property (nonatomic,assign) BOOL isJCLQ;
@property (nonatomic,retain) NSString* companyName;
@property (nonatomic,retain) NSString* homeWin;
@property (nonatomic,retain) NSString* standoff;
@property (nonatomic,retain) NSString* guestWin;

@property (nonatomic,retain) NSString* homeWinLu;
@property (nonatomic,retain) NSString* standoffLu;
@property (nonatomic,retain) NSString* guestWinLu;


@property (nonatomic,retain) NSString* k_h;
@property (nonatomic,retain) NSString* k_s;
@property (nonatomic,retain) NSString* k_g;
@property (nonatomic,retain) NSString* fanHuanLu;
-(void) refreshTableCell;

@end
 

