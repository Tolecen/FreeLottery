//
//  JCLotteryView.h
//  RuYiCai
//
//  Created by  on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RandomPickerViewController.h"


@interface JCLotteryView : UIViewController<UITableViewDataSource, UITableViewDelegate, RandomPickerDelegate>
{
    UITableView     *m_myTableView;
    NSMutableArray  *m_dataArray;
    NSMutableArray  *m_selectDataArray;
    
    NSInteger       m_cellCount;
    
    int            m_isJCLQ;//1 为 篮球 0 为 足球  2为北京单场
    
    BOOL           isPlayButtonClick;
    UIButton*      m_playTypeButton;
    UIButton*      m_batchCodeOrDateButton;
    NSMutableArray*       m_playTypeArray;//存的lotno
    NSString*      m_playType;
}

@property (nonatomic, retain)UITableView     *myTableView;
@property (nonatomic, retain)NSMutableArray  *dataArray;
@property (nonatomic, retain)NSMutableArray  *selectDataArray;
@property (nonatomic, assign)int  isJCLQ;
@end