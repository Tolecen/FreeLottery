//
//  DataAnalysisViewController.h
//  RuYiCai
//
//  Created by ruyicai on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSegmentedControl.h"

@interface DataAnalysisViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,CustomSegmentedControlDelegate> {
    //获取数据请求中的 event参数
    NSString                            *m_event;
    BOOL                                m_isJCLQ;
    BOOL                                m_isZC;
    BOOL                                m_isBJDC;
    
    UITableView                         *m_tableView[5];
    NSInteger                           tableRowNum;
    
    NSMutableArray                      *m_typeIdArray;
    NSInteger                           m_typeTag;//0 分析 1 欧指 2 亚盘
    
    //rankings 联赛排名
    NSInteger                      m_rankingsCount;
    
    //preClashSchedules：历史交锋
    NSInteger                      m_preClashSchedulesCount;
    
    //存放每一组的个数
    NSInteger                   m_headerCount;
	int                         m_SectionN[500];
    NSMutableArray              *m_tableHeaderState;
    /*
     homePreSchedules：主近10场赛事
     guestPreSchedules：客近10场赛事
     homeAfterSchedules：主未来5场赛事
     guestAfterSchedules：客未来5场赛事
     */
    NSInteger                          m_homePreSchedulesCount;
    NSInteger                          m_guestPreSchedulesCount;
    NSInteger                          m_homeAfterSchedulesCount;
    NSInteger                          m_guestAfterSchedulesCount;
    
    NSMutableDictionary*               m_dataDic;//一些数据存储：主客队排名等
    NSMutableArray*                    m_recommendData;//推荐数据
    NSMutableArray*                    m_recordTitleViewState;
    float                              m_reommendHeight[10];
    
    UIImageView*                       m_imageTopBg;
    CustomSegmentedControl             *m_segmentedView;

}
@property (nonatomic, retain) NSString           *event;

@property (nonatomic, assign) BOOL               isZC;
@property (nonatomic, assign) BOOL               isJCLQ;
@property (nonatomic, assign) BOOL               isBJDC;
@property (nonatomic, retain) UISegmentedControl *segmented;
//@property (nonatomic, retain) UITableView        *tableView;
@property (nonatomic, retain) NSMutableArray     *typeIdArray;
@property (nonatomic, retain) CustomSegmentedControl             *segmentedView;

@end
