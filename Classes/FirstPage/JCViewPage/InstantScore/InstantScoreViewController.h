//
//  InstantScoreViewController.h
//  RuYiCai
//
//  Created by ruyicai on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickView.h"
#import "RuYiCaiAppDelegate.h"
#import "RandomPickerViewController.h"
#import "CustomSegmentedControl.h"
typedef enum {
    JCLQ = 0,
    JCZQ = 1,
    BJDC = 2,
    ZC = 3
}Type;
@interface InstantScoreViewController : UIViewController<RandomPickerDelegate,UITableViewDataSource, UITableViewDelegate,CustomSegmentedControlDelegate>
{
    NSInteger                                   m_type;// 竞彩篮球 足球 足彩
    NSString*                                   m_userDefaultsTag;//保存数据关键字
    //instantScore_JCLQ
    //instantScore_JCZQ
    //instantScore_ZC
    
    NSString*                                   currentTime;
    NSString*                                   todayDate;//今天的日期
    int                                         currentDatePickNum;
    
    UISegmentedControl                          *m_segmented;
    UITableView                                 *m_tableView;
    NSInteger                                   tableRowNum;
    
    NSMutableArray                              *m_typeIdArray;
    NSInteger                                   m_typeTag;//0 全部 1 未开赛 2 进行中 3 已完场
    NSString*                                   m_Data;
    //选择器
    RuYiCaiAppDelegate                          *m_delegate;
    UIView*                                     m_messageView;
    
    NSString*                                   m_tempSelectEvent;
    
    UILabel *                                   m_noMessageLabel;
    CustomSegmentedControl                      *m_segmentView;
    
    NSString                                    *m_userChooseGameEvent;
    NSMutableArray                              *m_userChooseGameArray;
    
    UIButton                                    *m_dateChooseButton;
    UIButton                                    *m_refreshButton;

}
@property (nonatomic, retain) NSString           *tempSelectEvent;
@property (nonatomic, retain)  NSString         *currentTime;
@property (nonatomic, retain) NSString           *todayDate;
@property (nonatomic, retain) NSString          *userDefaultsTag;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, retain) UISegmentedControl *segmented;
@property (nonatomic, retain) UITableView        *tableView;
@property (nonatomic, retain) NSMutableArray     *typeIdArray;
@property (nonatomic, retain) NSString           *Data;
@property (nonatomic, assign) int                 currentDatePickNum;
@property (nonatomic, retain) UILabel            *noMassageLabel;
@property (nonatomic, retain)CustomSegmentedControl *segmentView;
@property (nonatomic, retain) NSString           *userChooseGameEvent;
@property (nonatomic, retain) NSMutableArray     *userChooseGameArray;
@property (nonatomic, retain) UIButton           *dateChooseButton;

- (void)shouCangButtonClick:(BOOL)isSelect INDEX:(NSString*)event;
@end
 
