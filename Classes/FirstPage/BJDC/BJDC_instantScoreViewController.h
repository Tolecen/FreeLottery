//
//  BJDC_instantScoreViewController.h
//  RuYiCai
//
//  Created by huangxin on 13-7-3.
//
//

#import <UIKit/UIKit.h>
#import "RuYiCaiAppDelegate.h"
#import "CustomSegmentedControl.h"
@interface BJDC_instantScoreViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,RandomPickerDelegate,CustomSegmentedControlDelegate>
{
    int                     m_typeTag;
    NSString                *m_currentLotNo;
    NSString                *m_currentBatchCode;//当前期号
    NSString                *m_todayBatchCode;//今天的期号
    NSString                *m_selectDetailBatchCode;//传到详情里的期号
    
    int                     pickViewCurrentNum;//pickView的当前的期号
    
    UIView                  *m_messageView;
    
    NSString                *m_userDefaultsTag;//保存数据关键字
    UISegmentedControl      *m_segmented;
    UITableView             *m_myTableView;
    NSString                *m_dataScore; //当前的数据
    int                      m_tableViewNum;// tableView 的行数
    
    //选择器
    RuYiCaiAppDelegate      *m_delegate;
    
    UILabel                 *m_noMessageLabel;
    UIButton                *m_dateChooseButton;
    UIButton                *m_refreshButton;
    CustomSegmentedControl  *m_segmentView;
}
@property (nonatomic, retain)CustomSegmentedControl  *segmentView;
@property (nonatomic, retain) NSString                 *todayBatchCode;
@property (nonatomic, retain) NSString                 *selectDetailBatchCode;
@property (nonatomic, retain) NSString                 *currentBatchCode;
@property (nonatomic, retain) NSString                 *currentLotNo;
@property (nonatomic, retain) NSString                 *userDefaultsTag;
@property (nonatomic, retain) UISegmentedControl       *segmented;
//@property (nonatomic, retain) UITableView              *myTableView;
@property (nonatomic, retain) NSString                 *dataScore;

@property (nonatomic, retain) UILabel                  *noMessageLabel;
@property (nonatomic, retain) UIButton                 *dateChooseButton;

- (void)shouCangButtonClick:(BOOL)isSelect INDEX:(NSString*)event;

@end
