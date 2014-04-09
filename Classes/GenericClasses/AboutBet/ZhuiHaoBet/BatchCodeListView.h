//
//  BatchCodeListView.h
//  RuYiCai
//
//  Created by  on 12-8-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define stateKey          @"stateKey"
#define batchCodeKey      @"batchCodeKey"
#define lotMuKey          @"lotMuKey"
#define amountKey         @"amountKey"

#define ButtonTagStart        (100)
#define TextFeildTagStart     (1000)
#define AmountLabelTagStart   (10000)

@interface BatchCodeListView : UIView<UITextFieldDelegate>
{
    UIScrollView*     m_scrollView;
    
    NSMutableArray    *m_batchCodeDate;//存字典
    
    NSInteger         m_oneBeiShu;
    NSInteger         m_oneAmount;
}

@property(nonatomic, retain)UIScrollView*     scrollView;
@property(nonatomic, retain)NSMutableArray    *batchCodeDate;

- (void)creatLineWithBathCode:(NSArray*)batchArr withLotMu:(NSInteger)lotmu withAmount:(NSInteger)amount;

@end
