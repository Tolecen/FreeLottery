//
//  LotteryAwardInfoTableViewCell.h
//  RuYiCai
//
//  Created by LiTengjie on 11-9-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WinNoView;

@interface LotteryAwardInfoTableViewCell : UITableViewCell 
{
    UIImageView*  m_boxBgImageView;
    UILabel*      m_batchCodeLabel;
    UILabel*      m_dateLabel;
    WinNoView*    m_winCellView;
    
    NSString*     m_lotTitle;   //彩种简称
    NSString*     m_batchCode;  //期号
    NSString*     m_winNo;      //获奖号码
    NSString*     m_date;       //日期
    NSString*     m_tryCode;    //试机号 福彩3D
    
    UIButton      *accessoryBtn;
    
}

@property (nonatomic, retain) UIButton  *accessoryBtn;
@property (nonatomic, retain) NSString* lotTitle;
@property (nonatomic, retain) NSString* batchCode;
@property (nonatomic, retain) NSString* winNo;
@property (nonatomic, retain) NSString* dateStr;
@property (nonatomic, retain) NSString* tryCode;

- (void)refresh;

@end
