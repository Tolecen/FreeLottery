//
//  NormalBetViewController.h
//  RuYiCai
//
//  Created by  on 12-8-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NormalBetViewController : UIViewController<UITextFieldDelegate>//高频彩普通投注
{
    int              allCount;
}
@property (nonatomic, retain) IBOutlet UILabel *normalBet_lotTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *normalBet_allCountLabel;
@property (nonatomic, retain) IBOutlet UILabel *normalBet_zhuShuLabel;
@property (nonatomic, retain) IBOutlet UILabel *normalBet_batchCodeLabel;
@property (nonatomic, retain) UILabel *normalLabelBei;
@property (nonatomic, retain) IBOutlet UILabel *beiLabelBei;
@property (nonatomic, retain) IBOutlet UIButton *normalBet_betCodeList;
@property (nonatomic, retain) IBOutlet UISlider *normalBet_sliderBeishu;
@property (nonatomic, retain) IBOutlet UITextField *normalBet_fieldBeishu;
@property (nonatomic, retain) IBOutlet UILabel  *biAccountLabel;

- (BOOL)normalBetCheck;
- (void)buildBetCode;
- (void)hideKeybord;
@end
