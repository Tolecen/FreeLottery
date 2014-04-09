//
//  BJDC_LaunchHMViewController.h
//  RuYiCai
//
//  Created by ruyicai on 13-6-13.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "RuYiCaiAppDelegate.h"

@interface BJDC_LaunchHMViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate,RandomPickerDelegate>
{
    UILabel             *m_allCountLabel;
	UILabel             *m_zhuShuLabel;
    UILabel             *m_qihaoLabel;
    //	UILabel             *m_beiShuLabel;
	UILabel             *m_buyByTotal;
	UILabel             *m_saveByTotal;
	
	UITextField         *m_buyField;
	UITextField         *m_lowField;
	UITextField         *m_saveField;
	
	UITextView          *m_desText;
	
	UIButton            *m_yesSave;
	UIButton            *m_noSave;
	
	UIButton            *m_buttonOne;
	UIButton            *m_buttonTwo;
	UIButton            *m_buttonThere;
	UIButton            *m_buttonFore;
	UIButton            *m_buttonFive;
	
	NSInteger           m_getNum;
	UIButton            *m_getButton;
	
	BOOL                allSave;
	NSInteger           isPublic;
	
	RuYiCaiAppDelegate         *m_delegate;
    
    float               allAmount;
    
    /*
     2013.4.2
     扩展 注码信息可以点击展开
     */
    int                          m_betCodeListHeight;
    BOOL                         m_expandBetCode;
    
    NSTimer              *m_timer;
}


@property (nonatomic, retain) IBOutlet UIView *betInfo_downView;//投注信息的下半部分
@property (nonatomic, retain) IBOutlet UIView *launchView;//合买信息

@property (nonatomic, retain) IBOutlet UIImageView *image_sanjiao;
@property (nonatomic, retain) IBOutlet UILabel *lotTitleLabel;

@property (nonatomic, retain) IBOutlet UIButton *betCodeList;

@property(nonatomic, retain) IBOutlet UILabel  *allCountLabel;
@property(nonatomic, retain) IBOutlet UILabel  *zhuShuLabel;

@property(nonatomic, retain) IBOutlet UILabel  *qihaoLabel;

@property(nonatomic, retain) IBOutlet UILabel  *buyByTotal;
@property(nonatomic, retain) IBOutlet UILabel  *saveByTotal;

@property(nonatomic, retain) IBOutlet UITextField  *buyField;
@property(nonatomic, retain) IBOutlet UITextField  *lowField;
@property(nonatomic, retain) IBOutlet UITextField  *saveField;

@property(nonatomic, retain) IBOutlet UITextView  *desText;

@property(nonatomic, retain) UIButton  *yesSave;
@property(nonatomic, retain) UIButton  *noSave;

@property(nonatomic, retain) UIButton  *buttonOne;
@property(nonatomic, retain) UIButton  *buttonTwo;
@property(nonatomic, retain) UIButton  *buttonThere;
@property(nonatomic, retain) UIButton  *buttonFore;
@property(nonatomic, retain) UIButton  *buttonFive;

@property(nonatomic, retain) UIButton *getButton;

@property(nonatomic, retain) IBOutlet UIButton *jiaBeishuButton;
@property(nonatomic, retain) IBOutlet UIButton *jianBeishuButton;

@property (nonatomic, retain) IBOutlet UITextField *fieldBeishu;

- (void)LotComplete:(id)sender;
- (void)buildBetCode;
- (void)refreshTopView;
- (void)hideKeybord;

@end
