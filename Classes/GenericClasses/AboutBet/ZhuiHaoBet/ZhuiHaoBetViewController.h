//
//  ZhuiHaoBetViewController.h
//  RuYiCai
//
//  Created by  on 12-8-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BatchCodeListView;

@interface ZhuiHaoBetViewController : UIViewController<UITextFieldDelegate>
{
    int              allCount;
    BOOL             isBatchCodeAdjust;
    
    BatchCodeListView    *m_batchCodeListView;
}

@property (nonatomic, assign) BOOL     isBatchCodeAdjust;

@property (nonatomic, retain) IBOutlet UILabel *zhuiHao_lotTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *zhuiHao_allCountLabel;
@property (nonatomic, retain) IBOutlet UILabel *zhuiHao_zhuShuLabel;
@property (nonatomic, retain) IBOutlet UILabel *zhuiHao_batchCodeLabel;
@property (nonatomic, retain) IBOutlet UIButton *zhuiHao_betCodeList;
@property (nonatomic, retain) IBOutlet UISlider *zhuiHao_sliderBeishu;
@property (nonatomic, retain) IBOutlet UITextField *zhuiHao_fieldBeishu;
@property (nonatomic, retain) IBOutlet UISlider *zhuiHao_sliderQishu;
@property (nonatomic, retain) IBOutlet UITextField *zhuiHao_fieldQishu;
@property (nonatomic, retain) IBOutlet UILabel  *biAccountLabel;

@property (nonatomic, retain) BatchCodeListView    *batchCodeListView;
@property (nonatomic, retain) IBOutlet UIButton*    batchCodeButton;

@property (nonatomic, retain) IBOutlet UILabel*    zhuiJiaLabel;
@property (nonatomic, retain) IBOutlet UISwitch*   zhuiJiaSwitch;

- (void)setMainView;
- (void)buildBetCode;
- (BOOL)zhuiHaoBetCheck;
- (void)querySampleNetOK:(NSNotification*)notification;

- (void)batchCodeListFieldBegin:(NSNotification*)notification;
- (void)batchCodeListFieldEnd:(NSNotification*)notification;

- (NSString*)buildSubscribeInfo;
- (void)hideKeybord;

- (IBAction)batchCodeAdjust:(id)sender;
@end
