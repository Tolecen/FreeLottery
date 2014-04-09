//
//  LotteryDetailView.h
//  RuYiCai
//
//  Created by  on 12-4-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LotteryDetailView : UIView
{
    NSString* m_jiangXiang;
    NSString* m_winZhuShu;
    NSString* m_winAccountStr;
    
    UILabel  *m_jiangXiangLabel;
    UILabel  *m_zhuShuLabel;
    UILabel  *m_winAccount;
}

@property (nonatomic, retain)NSString* jiangXiang;
@property (nonatomic, retain)NSString* winZhuShu;
@property (nonatomic, retain)NSString* winAccountStr;

- (void)refeshView;
- (void)setJXNewFrame;

@end
