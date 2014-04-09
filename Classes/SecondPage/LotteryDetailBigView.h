//
//  LotteryDetailBigView.h
//  RuYiCai
//
//  Created by  on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LotteryDetailBigView : UIView
{
    UIScrollView     *m_jiangXianScroll;
    
    NSString*         m_winLotTitle;
    
    NSInteger         m_jiangXiangCount;
    UILabel          *m_caizhongLable;
    
}

@property(nonatomic, retain)NSString*         winLotTitle;
@property (nonatomic,retain)  UILabel          *caizhongLable;

- (void)setDetailView;
- (void)setWinTable;
- (void)setNewFrame;

@end
