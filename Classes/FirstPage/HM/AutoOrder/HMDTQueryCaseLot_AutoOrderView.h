//
//  HMDTQueryCaseLot_AutoOrderView.h
//  RuYiCai
//
//  Created by ruyicai on 12-11-19.
//
//

#import <UIKit/UIKit.h>
/*
{"id":"87345","starter":"James","starterUserNo":"00000444","lotNo":"T01001","lotName":"大乐透","times":"10","joinAmt":"1","safeAmt":null,"maxAmt":"0","percent":null,"joinType":"0","forceJoin":"0","createTime":"2012-11-16 16:46:14","state":"0"}
*/
@class HMDTQueryCaseLotViewController;
@interface HMDTQueryCaseLot_AutoOrderView : UIView
{
    UILabel*   m_lotNameLabel;
    UILabel*   m_stateLabel;
    UILabel*   m_buyTimeLabel;
    UILabel*   m_starterLabel;
    UILabel*   m_joinAmtLabel;
    
    UILabel* joinAmountTip;
    
    UIButton*  m_checkDetailButton;
    UIButton*  m_modifyButton;
    
    NSString*  m_lotName;
    NSString*  m_caseId;
    NSString*  m_starter;
    NSString*  m_starterUserNo;
    NSString*  m_lotNo;
    NSString*  m_times;
    NSString*  m_createTime;
    NSString*  m_joinAmt;
    NSString*  m_safeAmt;
    NSString*  m_maxAmt;
    
    
    NSString*  m_percent;
    NSString*  m_joinType;
    NSString*  m_forceJoin;
    NSString*  m_state;
    
    NSDictionary*       m_zhanjiDic;
    HMDTQueryCaseLotViewController* m_supViewController;
}
 
@property (nonatomic, retain) NSString* lotName;;
@property (nonatomic, retain) NSString* caseId;
@property (nonatomic, retain) NSString* starter;
@property (nonatomic, retain) NSString* starterUserNo;
@property (nonatomic, retain) NSString* lotNo;
@property (nonatomic, retain) NSString* times;
@property (nonatomic, retain) NSString* safeAmt;
@property (nonatomic, retain) NSString* joinAmt;
@property (nonatomic, retain) NSString* maxAmt;

@property (nonatomic, retain) NSString* percent;
@property (nonatomic, retain) NSString* joinType;
@property (nonatomic, retain) NSString* createTime;
@property (nonatomic, retain) NSString* forceJoin;
@property (nonatomic, retain) NSString* state;
@property (nonatomic, retain) NSDictionary* zhanjiDic;
@property (nonatomic, retain) HMDTQueryCaseLotViewController* supViewController;
- (void)refreshView;


@end
