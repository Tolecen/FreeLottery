//
//  ShouYiLvSetViewController.h
//  RuYiCai
//
//  Created by  on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RuYiCaiAppDelegate.h"

@interface ShouYiLvSetViewController : UIViewController<RandomPickerDelegate, UITextFieldDelegate>
{
    RuYiCaiAppDelegate *m_delegate;
    
    NSMutableArray*    m_batchListArr;//期号列表
    
    BOOL               isAllOrSome;//1 全程
}
@property (nonatomic, retain) IBOutlet UILabel *shouYilv_lotTitleLabel;
@property (nonatomic, retain) IBOutlet UIButton *shouYilv_betCodeList;

@property (nonatomic, retain) IBOutlet UIButton*  batchCodeButton;
@property (nonatomic, retain) IBOutlet UITextField* touRuBatchField;
@property (nonatomic, retain) IBOutlet UITextField* beginBatchField;
@property (nonatomic, retain) IBOutlet UIButton*    allBatchButton;
@property (nonatomic, retain) IBOutlet UITextField* allShouField;
@property (nonatomic, retain) IBOutlet UIButton*    someBatchButton;
@property (nonatomic, retain) IBOutlet UITextField* qianBatchField;
@property (nonatomic, retain) IBOutlet UITextField* qianBatchShouField;
@property (nonatomic, retain) IBOutlet UITextField* houBatchShouField;
@property (nonatomic, assign) BOOL               isAllOrSome;
//@property (nonatomic, retain) IBOutlet UILabel  *biAccountLabel;

@property (nonatomic, retain) NSMutableArray*    batchListArr;

- (IBAction)randomNumSet;
- (IBAction)allOrSomeButtonClick:(id)sender;
- (void)okClick:(id)sender;

- (void)getBatchCodeDateOK:(NSNotification*)notification;
//- (void)computeShouYiLvOK:(NSNotification*)notification;
- (void)hideKeybord;
@end
