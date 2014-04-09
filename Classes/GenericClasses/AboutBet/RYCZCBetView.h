//
//  RYCZCBetView.h
//  RuYiCai
//
//  Created by  on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <QuartzCore/QuartzCore.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "WXApi.h"
#import "RespForWeChatViewController.h"

@class AnimationTabView;
@class LaunchHMViewController;
@class GiftViewController;
#import "CustomSegmentedControl.h"
#import "ShareViewController.h"

@interface RYCZCBetView : UIViewController<UITextFieldDelegate, ABPeoplePickerNavigationControllerDelegate,CustomSegmentedControlDelegate,sendMsgToWeChatViewDelegate,RespForWeChatViewDelegate,WXApiDelegate>
{
    enum WXScene                _scene;
    BOOL                          isNormalBet;
    int                           allCount;
    
    AnimationTabView*             m_animationTabView;
    LaunchHMViewController*       m_LaunchHMView;
    GiftViewController*           m_giftViewController;
    CustomSegmentedControl        *m_segmentedControl;
    UIAlertView*                   zcAlterView;
}
@property (nonatomic, retain) NSDictionary     *getShareDetileDic;
@property (nonatomic, retain) CustomSegmentedControl *segmentedControl;
@property (nonatomic, retain) IBOutlet UILabel *lotTitleLabel;
@property (nonatomic, retain) IBOutlet UIScrollView* normalScroll;
@property (nonatomic, retain) IBOutlet UIScrollView* HMScroll;
@property (nonatomic, retain) IBOutlet UIScrollView* giftScroll;

@property (nonatomic, retain) IBOutlet UILabel *allCountLabel;
@property (nonatomic, retain) IBOutlet UILabel *zhuShuLabel;
@property (nonatomic, retain) IBOutlet UILabel *batchCodeLabel;
//@property (nonatomic, retain) IBOutlet UILabel *batchEndTimeLabel;
@property (nonatomic, retain) IBOutlet UIButton *betCodeList;
@property (nonatomic, retain) IBOutlet UISlider *sliderBeishu;
@property (nonatomic, retain) IBOutlet UITextField *fieldBeishu;

@property (nonatomic, retain) AnimationTabView*      animationTabView;
@property (nonatomic, retain) LaunchHMViewController*       LaunchHMView;
@property (nonatomic, retain) GiftViewController*           giftViewController;

@property (nonatomic, retain) IBOutlet UIButton*   buyButton;

- (IBAction)sliderBeishuChange:(id)sender;
- (IBAction)betCodeClick:(id)sender;
- (IBAction)buyClick:(id)sender;

- (void)back:(id)sender;
- (void)buildBetCode;
- (BOOL)normalBetCheck;

- (void)wapPageBuild;
- (void)betCompleteOK:(NSNotification*)notification;
- (void)tabButtonChanged:(NSNotification*)notification;

- (void)hideKeybord;

- (void)giftWordButtonClick:(NSNotification*)notification;
- (void)phoneButtonClick:(NSNotification*)notification;
- (void)giftSendSms:(NSNotification*)notification;

//- (void)sendsms:(NSString*)message;
//- (void)displaySMS:(NSString*)message;
@end
