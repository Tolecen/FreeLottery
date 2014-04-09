//
//  SeeDetailTableViewCell.h
//  RuYiCai
//
//  Created by  on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum
{
    NONE_BUTTON = 0,
    HMDT_CHEDAN_BUTTON = 1,//为1时是参与合买里的 撤单 按钮
    ZHUIHAO_STOP_TRACK = 2,//追号详情查询里得停止追期
    HM_CANCEL_ORDER,      //合买 --撤销定制
} buttonType;

@interface SeeDetailTableViewCell : UITableViewCell
{
    UILabel*    cellLabel;
    UILabel*    cellDetailLabel;
    
    NSString*   cellTitle;
    NSString*   cellDetailTitle;
    
    UITextView*  contentView;//投注内容显示
    UIWebView*   contentWeb;//投注内容显示(投注查询)
    NSString*    contentStr;
    
    UIButton*    oneButton;
    
    BOOL        isTextView;
    BOOL        isRedText;
    BOOL        isWebView;
    buttonType   hasButton;
}

@property(nonatomic, retain) NSString*   cellTitle;
@property(nonatomic, retain) NSString*   cellDetailTitle;
@property(nonatomic, retain) NSString*   contentStr;
@property(nonatomic, assign) BOOL        isTextView;
@property(nonatomic, assign) BOOL        isRedText;
@property(nonatomic, assign) BOOL        isWebView;
@property(nonatomic, assign) buttonType        hasButton;

- (void)refreshCell;
- (void)buttonClick:(id)sender;

@end
