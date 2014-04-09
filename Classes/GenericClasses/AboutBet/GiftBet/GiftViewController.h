//
//  GiftViewController.h
//  RuYiCai
//
//  Created by haojie on 11-12-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>

@interface GiftViewController : UIViewController<UITextViewDelegate, UITextFieldDelegate>
{
	UITextView    *m_adviceTextView;
	UITextView    *m_numTextView;
	
	UILabel       *m_amountLabel;
	
	UIButton      *m_geneButton;
	UIButton      *m_phoneBookButton;
	
    int               allAmount;
}
@property (nonatomic, retain) IBOutlet UILabel *lotTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *batchCodeLabel;
//@property (nonatomic, retain) IBOutlet UILabel *batchEndTimeLabel;
@property (nonatomic, retain) IBOutlet UIButton *betCodeList;
@property (nonatomic, retain) IBOutlet UILabel  *zhuShuLabel;
@property (nonatomic, retain) IBOutlet UILabel  *biAccountLabel;

@property(nonatomic, retain)IBOutlet UITextView    *adviceTextView;
@property(nonatomic, retain)IBOutlet UITextView    *numTextView;
//@property(nonatomic, retain)IBOutlet UILabel       *beiShuLabel;
@property(nonatomic, retain)IBOutlet UILabel       *amountLabel;
@property(nonatomic, retain)IBOutlet UIButton      *geneButton;
@property(nonatomic, retain)IBOutlet UIButton      *phoneBookButton;

@property (nonatomic, retain) IBOutlet UILabel*    zhuiJiaLabel;
@property (nonatomic, retain) IBOutlet UISwitch*   zhuiJiaSwitch;
@property (nonatomic, retain) IBOutlet UISlider *sliderBeishu;
@property (nonatomic, retain) IBOutlet UITextField *fieldBeishu;

- (void)refreshTopView;

- (IBAction)betCodeClick:(id)sender;

- (void)geneButtonClick;
- (void)phoneBookButtonClick;

- (void)sureButonClick;
- (void)buildBetCode;

- (void)hideKeybord;

@end
