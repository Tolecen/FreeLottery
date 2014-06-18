//
//  DiceViewController.h
//  Boyacai
//
//  Created by wangxr on 14-5-22.
//
//

#import <UIKit/UIKit.h>
#import "RuYiCaiNetworkManager.h"
#import "BDKNotifyHUD.h"
#import "IssueHistoryViewController.h"
#import "ADIntroduceViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIWindow+YzdHUD.h"
@class RuYiCaiAppDelegate;
@interface DiceViewController : UIViewController<UIScrollViewDelegate,UITextFieldDelegate>
{
    float gh;
    
    int selectedResult;
    
    BDKNotifyHUD * bdkHUD;
    
    NSString * currentLotNum;
    
    RuYiCaiAppDelegate  *m_delegate;
    
    BOOL lastResultGeted;
    
    int xiaoZhu;
    int daZhu;
    
//    NSTimer * remainingTimer;
//    NSTimer * checkLastResultTimer;
    
}
@property (nonatomic,retain)UILabel * currentRoundNameLabel;
@property (nonatomic,retain)UILabel * currentRemainingTLabel;
@property (nonatomic,retain)UILabel * lastNameLabel;
@property (nonatomic,retain)UILabel * lastStatusLabel;
@property (nonatomic,retain)UIImageView * lastResultImageV;

@property (nonatomic,retain)UIButton * historyBtn;
@property (nonatomic,retain)UIButton * ruleBtn;
@property (nonatomic,retain)UIButton * recordBtn;

@property (nonatomic,retain)UIButton * leftSelectBtn;
@property (nonatomic,retain)UIButton * rightSelectBtn;
@property (nonatomic,retain)UILabel * leftrenshuL;
@property (nonatomic,retain)UILabel * leftcaidouL;
@property (nonatomic,retain)UILabel * rightrenshuL;
@property (nonatomic,retain)UILabel * rightcaidouL;
@property (nonatomic,retain)UIImageView * choumaImageV1;
@property (nonatomic,retain)UIImageView * choumaImageV2;
@property (nonatomic,retain)UILabel * choumaL1;
@property (nonatomic,retain)UILabel * choumaL2;
@property (nonatomic,retain)UILabel * allchoumaL1;
@property (nonatomic,retain)UILabel * allchoumaL2;

@property (nonatomic,retain)UIView * xiuxiView;
@property (nonatomic,retain)UILabel * uu;
@property (nonatomic,retain)UIButton * sureBtn;

@property (nonatomic,retain)UITextField * inputTF;
@property (nonatomic,retain)UIScrollView * m_scrollView;
@property (nonatomic,retain)NSString * currentRemainingTime;
@property (nonatomic,retain)NSTimer * remainingTimer;
@property (nonatomic,assign)NSTimer * checkLastResultTimer;
@end
