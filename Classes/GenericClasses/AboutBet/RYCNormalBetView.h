//
//  RYCNormalBetView.h
//  RuYiCai
//
//  Created by  on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
//#import <MessageUI/MessageUI.h>
#import "CustomSegmentedControl.h"

@class AnimationTabView;
@class ZhuiHaoBetViewController;
@class LaunchHMViewController;
@class GiftViewController;

@interface RYCNormalBetView : UIViewController<UITextFieldDelegate, ABPeoplePickerNavigationControllerDelegate, UIAlertViewDelegate, CustomSegmentedControlDelegate>
{
    BOOL             isNormalBet;//是否为普通投注  或  追加投注
    int              allCount;
//    enum WXScene _scene;
    
    AnimationTabView*   m_animationTabView;
    ZhuiHaoBetViewController*  m_zhuiHaoViewController;
    LaunchHMViewController*       m_LaunchHMView;
    GiftViewController*           m_giftViewController;
    NSDictionary                  *m_dataDic;
}
@property (nonatomic, retain) NSDictionary     *getShareDetileDic;
@property (nonatomic, retain) NSDictionary     *dataDic;
@property (nonatomic, retain) IBOutlet UILabel *lotTitleLabel;
@property (nonatomic, retain) IBOutlet UIScrollView*  normalBetScroll;
@property (nonatomic, retain) IBOutlet UIScrollView*  zhuiHaoBetScroll;
@property (nonatomic, retain) IBOutlet UIScrollView*  HMBetScroll;
@property (nonatomic, retain) IBOutlet UIScrollView*  giftBetScroll;

@property (nonatomic, retain) IBOutlet UILabel *allCountLabel;
@property (nonatomic, retain) IBOutlet UILabel *zhuShuLabel;
@property (nonatomic, retain) IBOutlet UILabel *batchCodeLabel;
@property (nonatomic, retain) IBOutlet UIButton *betCodeList;
@property (nonatomic, retain) IBOutlet UISlider *sliderBeishu;
@property (nonatomic, retain) IBOutlet UITextField *fieldBeishu;
@property (nonatomic, retain) IBOutlet UILabel  *beiLabelBei;
@property (nonatomic, retain) UILabel  *normalLabelBei;
@property (nonatomic, retain) IBOutlet UIButton *zhuiJiaButton;
@property (nonatomic, retain) IBOutlet UILabel  *zhuiJiaLabel;
@property (nonatomic, retain) IBOutlet UILabel  *biAccountLabel;

@property (nonatomic, retain) AnimationTabView*      animationTabView;
@property (nonatomic, retain) ZhuiHaoBetViewController*  zhuiHaoViewController;
@property (nonatomic, retain) LaunchHMViewController*       LaunchHMView;
@property (nonatomic, retain) GiftViewController*           giftViewController;

@property (nonatomic, retain) IBOutlet UIButton*   buyButton;
@property (nonatomic, retain) CustomSegmentedControl *segmented;

- (IBAction)sliderBeishuChange:(id)sender;
- (IBAction)betCodeClick:(id)sender;
- (IBAction)zhuiJiaButtonClick:(id)sender;

- (IBAction)buyClick:(id)sender;
- (void)back:(id)sender;
- (void)buildBetCode;

- (void)wapPageBuild;
- (void)betCompleteOK:(NSNotification*)notification;

- (void)hideKeybord;

- (void)giftWordButtonClick:(NSNotification*)notification;
- (void)phoneButtonClick:(NSNotification*)notification;
- (void)giftSendSms:(NSNotification*)notification;

- (void)updateInformation:(NSNotification*)notification;//期号
- (void)betOutTime:(NSNotification*)notification;
- (void)notEnoughMoney:(NSNotification*)notification;

@end
