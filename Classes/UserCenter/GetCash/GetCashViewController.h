//
//  GetCashViewController.h
//  RuYiCai
//
//  Created by LiTengjie on 11-10-5.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RandomPickerViewController.h"
#import "RuYiCaiAppDelegate.h"

/*{"error_code":"0000","message":"查询成功","cashdetailid":"00000319","amount":"200","name":"翼支付测试",
    "stat":"1","bankname":"招商银行","areaname":"北京市西城区","bankcardno":"11111111111",
    "allbankname":"中国工商银行,招商银行,中国建设银行,中国农业银行,交通银行,上海浦东发展银行,广东发展银行,中国光大银行,
    兴业银行,深圳发展银行,中国民生银行,中信银行,杭州银行"}*/
@class AnimationTabView;
@class PullUpRefreshView;

@interface GetCashViewController : UIViewController <RandomPickerDelegate, UITextFieldDelegate, UIScrollViewDelegate> 
{
    UIScrollView*   m_newCashScrollView;
    UITextField*    m_nameTextField;
    UIButton*       m_bankNameButton;
    UITextField*    m_bankCardNoTextField;
    UITextField*    m_amountTextField;
    UITextField*    m_passWordField;
    UILabel*        m_balanceLabel;
    UITextField *    m_regionField;
    UITextField *    m_subbankField;
    
    UIScrollView*   m_alipayGetCashScrollView;
    UITextField*    m_alipayAccountField;
    UITextField*    m_alipayNameField;
    UILabel*        m_canBalanceLable;
    UITextField*    m_alipayAmountField;
    UITextField*    m_alipayPassWordField;
    
    NSString*       m_cashDetailId;    //提现记录id
    NSString*       m_amount;          //金额
    NSString*       m_userName;        //账户名称
    NSString*       m_stat;            //处理状态，1待审核,2审核中，3成功，4驳回取消
    NSString*       m_bankName;        //银行名称
    NSString*       m_bankCardNo;      //银行卡号
    NSString*       m_region;          //银行地域
    NSString*       m_subbank;         //银行分行
    NSMutableArray* m_allBankName;     //所有可以提现的银行名称

    RuYiCaiAppDelegate *m_delegate;
        
    AnimationTabView*   m_animationTabView;
    UIScrollView*       m_getCashRecordScrollView;
    
    NSUInteger      m_curPageIndex;
    NSUInteger      m_totalPageCount;
    NSUInteger      m_curPageSize;
        
    PullUpRefreshView      *refreshView;
    float           startY;
    float           centerY;
    
    BOOL            isFirstGetCashRecord;
    
    BOOL            bindState;
    NSInteger       topButtonIndex;
    UIButton        *m_bankTxBtn;
    UIButton        *m_txLogBtn;
    UIButton        *m_alipayBtn;
    UILabel*        m_bankCardLable;
    
}
@property (nonatomic, retain) UIButton        *bankTxBtn;
@property (nonatomic, retain) UIButton        *txLogBtn;
@property (nonatomic, retain) UIButton        *alipayBtn;

@property (nonatomic, retain) IBOutlet UILabel*     bankCardLable;
@property (nonatomic, retain) AnimationTabView*      animationTabView;
@property (nonatomic, retain) IBOutlet UIScrollView* newsCashScrollView;
@property (nonatomic, retain) IBOutlet UITextField* nameTextField;
@property (nonatomic, retain) IBOutlet UIButton* bankNameButton;
@property (nonatomic, retain) IBOutlet UITextField* bankCardNoTextField;
@property (nonatomic, retain) IBOutlet UITextField* amountTextField;
@property (nonatomic, retain) IBOutlet UITextField* passWordField;
@property (nonatomic, retain) IBOutlet UILabel* passWordLabel;
@property (nonatomic, retain) IBOutlet UILabel* balanceLabel;
@property (nonatomic, retain) IBOutlet UITextView* m_warnTextView;
@property (nonatomic, retain) IBOutlet UITextView* m_zfbTextView;
@property (nonatomic, retain) IBOutlet UITextField *regionField;
@property (nonatomic, retain) IBOutlet UITextField *subbankField;


@property (nonatomic, retain) IBOutlet UIScrollView*   alipayGetCashScrollView;
@property (nonatomic, retain) IBOutlet UITextField*    alipayAccountField;
@property (nonatomic, retain) IBOutlet UITextField*    alipayNameField;
@property (nonatomic, retain) IBOutlet UILabel*        canBalanceLable;
@property (nonatomic, retain) IBOutlet UITextField*    alipayAmountField;
@property (nonatomic, retain) IBOutlet UITextField*    alipayPassWordField;
@property (nonatomic, retain) IBOutlet UILabel* alipayPassWordLabel;

@property (nonatomic, retain) NSString* cashDetailId;
@property (nonatomic, retain) NSString* amount;
@property (nonatomic, retain) NSString* userName;
@property (nonatomic, retain) NSString* stat;
@property (nonatomic, retain) NSString* bankName;
@property (nonatomic, retain) NSString* bankCardNo;
@property (nonatomic, retain) NSString* region;
@property (nonatomic, retain) NSString* subbank;
@property (nonatomic, retain) NSMutableArray* allBankName;

@property (nonatomic, retain) UIScrollView*   getCashRecordScrollView;

- (void)okClick;

@end
