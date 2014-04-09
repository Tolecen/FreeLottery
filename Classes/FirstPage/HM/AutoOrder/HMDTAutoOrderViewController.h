//
//  HMDTAutoOrderViewController.h
//  RuYiCai
//
//  Created by ruyicai on 12-11-13.
//
//

#import <UIKit/UIKit.h>
/*
 创建自动跟单
 */
typedef enum
{
    CREAT_AUTO_ORDER_VIEW= 0,   //创建定制跟单
    MODIFY_AUTO_ORDER_VIEW = 1//修改定制跟单
 
} viewType;
@interface HMDTAutoOrderViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>
{
    NSInteger        m_ViewType;//用来区分 是创建跟单页面 还是 修改跟单页面 默认创建跟单页面
    //修改跟单页面
 
    NSString*        m_creatTimes;
    NSString*        m_states;
    NSString*        m_caseId;
    
    UITableView*     m_myTableView;
    NSMutableArray   *m_titleButtonState;
    
    NSString*        m_lotNo;
    NSString*        m_batchCode;
    NSString*        m_starterUserNo;
    //合买名人信息
    NSDictionary*    m_dataDic;
 
    NSString*         m_orderAmountByAllAmount;//按因定金额定制
    NSString*         m_orderCountByAllAmount;
    
    NSString*         m_orderAmountByPercent;//按百分比定制
    NSString*         m_orderCountByPercent;
    NSString*         m_orderMaxAmountByPercent;
    BOOL              m_hasMaxAmountByPercent;
 
    BOOL              m_isByAllAmount;//跟单金额方式：因定金额；百分比
    BOOL              m_forceJoin;    //强制参与
    
    UITextField*      m_currentTextFeild;
}
@property (nonatomic, assign) NSInteger ViewType;
@property (nonatomic, retain) NSString* states;
@property (nonatomic, retain) NSString* creatTimes;
@property (nonatomic, retain) NSString* caseId;

@property (nonatomic, retain) NSString* lotNo;
@property (nonatomic, retain) NSString* batchCode;
@property (nonatomic, retain) NSString* starterUserNo;

@property (nonatomic, retain) NSDictionary* dataDic;

@property (nonatomic, retain) UITableView*      myTableView;
@property (nonatomic, retain) NSMutableArray   *titleButtonState;

@property (nonatomic, retain) NSString* orderAmountByAllAmount;
@property (nonatomic, retain) NSString* orderCountByAllAmount;
@property (nonatomic, retain) NSString* orderAmountByPercent;
@property (nonatomic, retain) NSString* orderCountByPercent;
@property (nonatomic, retain) NSString* orderMaxAmountByPercent;
@property (nonatomic, assign) BOOL isByAllAmount;
@property (nonatomic, assign) BOOL hasMaxAmountByPercent;
 
@property (nonatomic, assign) BOOL forceJoin;
@end
