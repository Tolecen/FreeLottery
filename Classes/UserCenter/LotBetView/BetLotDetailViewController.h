//
//  BetLotDetailViewController.h
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 12-11-9.
//
//

#import <UIKit/UIKit.h>

typedef enum _DetailType
{
    DETAILTYPEBASE = 1,
    DETAILTYPEBET,//投注查询
    DETAILTYPEWIN,//中奖查询
}DetailType;

@interface BetLotDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate>
{
    NSString*             m_lotNo;
    NSString*             m_orderId;
    
    DetailType           m_detailType;
    
    //投注查询
    //    NSString*             m_winNum;//中奖金额
    NSString*             m_amountCount;// 付款金额
    
    BOOL                  m_showInTable;
    UITableView           *m_myTableView;
    
    //    NSDictionary*         m_contentDic;
    NSMutableArray        *m_contentArray;
    NSDictionary*         m_betCodeJson;
    
    BOOL                  isRepeatBuy;//再买一次
    
    //    NSInteger             JCBetContentHeigth;
}
@property(nonatomic, retain) NSString*             lotNo;
@property(nonatomic, retain) NSString*             orderId;

@property(nonatomic, assign) DetailType            detailType;

//@property(nonatomic, retain) NSString*             winNum;
@property(nonatomic, retain) NSString*             amountCount;
@property(nonatomic, assign) BOOL                  showInTable;
//@property(nonatomic, retain) NSDictionary          *contentDic;
@property(nonatomic, retain) NSMutableArray        *contentArray;
@property(nonatomic, retain) UITableView           *myTableView;
@property(nonatomic, retain) NSDictionary          *betCodeJson;

@property(nonatomic, assign) BOOL                  isRepeatBuy;
- (void)setUpTopView;

@end
