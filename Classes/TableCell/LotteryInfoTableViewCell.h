//
//  LotteryInfoTableViewCell.h
//  RuYiCai
//
//  Created by LiTengjie on 11-9-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WinNoView;
#import "DrawLotteryPageViewController.h"
@interface LotteryInfoTableViewCell : UITableViewCell {
    UIImageView*  m_boxBgImageView;
    UIImageView*  m_titleBgImageView;
    UIImageView*  m_icoImageView;
    UILabel*      m_titleLabel;
    UILabel*      m_batchCodeLabel;
    UILabel*      m_dateLabel;
    WinNoView*    m_winCellView;
    
    NSString*     m_lotTitle;   //彩种简称
    NSString*     m_batchCode;  //期号
    NSString*     m_winNo;      //获奖号码
    NSString*     m_date;       //日期
    NSString*     m_tryCode;    //试机号
 
    UIButton*     m_instantScoreButton;
    UIButton*     m_checkButton;
    DrawLotteryPageViewController*  m_superViewController;
}
@property (nonatomic, retain) NSString* tryCodeBatchCode;//试机号期号
@property (nonatomic, retain) NSString* lotTitle;
@property (nonatomic, retain) NSString* batchCode;
@property (nonatomic, retain) NSString* winNo;
@property (nonatomic, retain) NSString* dateStr;
@property (nonatomic, retain) NSString* tryCode;

- (void)refresh;
- (void)JCrefreshView;
@property (nonatomic, retain) DrawLotteryPageViewController* superViewController;
@end
