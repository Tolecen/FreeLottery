//
//  FourthPageViewController.h
//  RuYiCai
//
//  Created by LiTengjie on 11-9-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RuYiCaiAppDelegate.h"
#import "CustomSegmentedControl.h"
#import "ASettingViewController.h"
@interface FourthPageViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate,CustomSegmentedControlDelegate>
{
    UIBarButtonItem    *m_button_Login;//登录
    CustomSegmentedControl *m_segmentedView;
    UITableView        *m_tableView;
    RuYiCaiAppDelegate *m_delegate;
    
    UIButton           *m_nickName;
    UIButton           *m_bPhone;
    //UILabel            *lineLabel2;
    UILabel            *lineLabel;
    UILabel            *m_balanceLabel;
    UILabel            *m_moneyLabel;
    UILabel            *m_integralLabel;
    UIButton           *m_isBindCertid;
    UIButton           *m_isBindPhone;
    
    NSString*           m_agencyChargeRight;//是否能代理充值，1表示是
    //是否展开的控制变量
    BOOL                flag[30];
    
    UIScrollView*       m_loginTopView;
    UIScrollView*       m_notLoginView;
    
    NSIndexPath*        selectTableRow;
    UIImageView         *m_idCardimage;
    UIImageView         *m_idPhoneimage;
    //区头标题和cell标题数组
    NSMutableArray      *m_cellTitlArray;
    BOOL                isRequestBindEmeil;
    BOOL                isRequestBindPhone;
    
    
}
@property (nonatomic, retain)NSMutableArray      *sectionTitleArray;
@property (nonatomic, retain)NSMutableArray      *cellTitlArray;
@property (nonatomic, retain)NSMutableArray      *totalToolsArray;
@property (nonatomic, retain)UIImageView         *idCardimage;
@property (nonatomic, retain)UIImageView         *idPhoneimage;
@property (nonatomic, retain)UIButton           *m_nickName;
@property (nonatomic, retain)UIButton           *m_bPhone;
@property (nonatomic, retain)UILabel            *m_balanceLabel;
@property (nonatomic, retain)UILabel            *m_moneyLabel;
@property (nonatomic, retain)UILabel            *m_integralLabel;
@property (nonatomic, retain)UIButton           *m_isBindCertid;
@property (nonatomic, retain)UIButton           *m_isBindPhone;

@property (nonatomic, retain)NSString*           agencyChargeRight;

@property (nonatomic, retain)UIScrollView*       loginTopView;
@property (nonatomic, retain)UIScrollView*       notLoginView;

- (void)setupNavigationBarStatus;
- (void)setUpTopView;
- (void)setUpTopView_notLogin;
- (void)setUpNickname;
- (void)setUpBindPhone;
- (void)seeIntegralExplain;
//- (void)updateLoginStatus;

@end
