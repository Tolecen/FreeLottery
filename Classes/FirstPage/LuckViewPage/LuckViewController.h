//
//  LuckViewController.h
//  RuYiCai
//
//  Created by  on 12-6-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "DatePickView.h"
#import "RuYiCaiAppDelegate.h"
#import "RandomPickerViewController.h"

@class DatePickView;


@interface LuckViewController : UIViewController<UITextFieldDelegate, DatePickViewDelegate, RandomPickerDelegate>
{
    UIScrollView*       m_mainScrollView;
    
    AVAudioPlayer       *m_musicSelect;
    AVAudioPlayer       *m_musicOK;

    UIButton*        m_LuckTypeButton;
    NSInteger        m_recoderType;
    UIButton*        m_LuckLotButton;
    NSInteger        m_recodeLotType;
    UIButton*        m_LuckNumberButton;
    NSInteger        m_recoderNum;
    NSInteger        m_randomPickType;
    
    UIView           *m_nameView;
    UITextField      *m_nameField;
    
    UIView           *m_xingZuoView;
    NSArray*         xingZuo_imageNameArr_normal;
    NSArray*         xingZuo_imageNameArr_click;
    UIButton*        m_xingZuoButton;
    UILabel*         m_dateLabel;
    
    UIView           *m_shengXiaoView;
    NSArray*         shengXiao_imageNameArr_normal;
    NSArray*         shengXiao_imageNameArr_click;
    UIButton*        m_shengXiaoButton;
    
    UIView           *m_shengRiView;
    UIButton*        m_yearButton;
    UIButton*        m_monthButton;
    UIButton*        m_dayButton;
    DatePickView     *m_selectDateView;
    
    RuYiCaiAppDelegate         *m_delegate;
    UIImageView*               m_birNameImageView;
}
@property(nonatomic, retain)UIImageView*     birNameImageView;
@property(nonatomic, retain)UIView           *nameView;
@property(nonatomic, retain)UIView           *xingZuoView;
@property(nonatomic, retain)UIView           *shengXiaoView;
@property(nonatomic, retain)UIView           *shengRiView;
@property(nonatomic, assign)int       randomPickType;
 
@end
