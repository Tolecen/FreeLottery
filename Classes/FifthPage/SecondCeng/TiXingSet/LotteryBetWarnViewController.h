//
//  LotteryBetWarnViewController.h
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 12-11-29.
//
//

#import <UIKit/UIKit.h>
#import "DatePickView.h"

@class DatePickView;
@interface LotteryBetWarnViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, DatePickViewDelegate>
{
    UITableView*     m_myTableView;
    
    NSMutableDictionary*  m_recodeSwitchDic;//总共9个，1表示开，0表示关,前1个是记录声音的开关
        
    DatePickView    *m_selectDateView;
}

@property (nonatomic, retain)UITableView*      myTableView;
@property (nonatomic, retain)NSMutableDictionary*  recodeSwitchDic;
@end
