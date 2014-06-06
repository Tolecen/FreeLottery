//
//  BJDC_Bet_viewController.h
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 13-4-25.
//
//

#import <UIKit/UIKit.h>
#import "JC_BetView.h"
#import "CustomSegmentedControl.h"


@class BJDC_LaunchHMViewController;

@interface BJDC_Bet_viewController : UIViewController<CustomSegmentedControlDelegate, UITextFieldDelegate>
{
    CustomSegmentedControl*           m_customSegmentView;
    double                         m_allCount;//所有花费
    int                         m_betNumber;//注数
//    enum WXScene _scene;
    
    BJDC_LaunchHMViewController*       m_LaunchHMView;
    
    NSString                    *m_chooseBetCode;//上个页面形成的注码格式
    
    int                         m_DanCount;//纪录胆的个数
    
    //过关选择
    UIButton                    *m_FreePassButton; //自由过关
    UIButton                    *m_DuoChuanPassButton;//多穿过关
    UIScrollView                *m_freePassScollView;
    //    int                         freePassRadioIndex;
    NSMutableArray*             freePassRadioIndexArray;//自由过关选择的
    
    BOOL                        m_isFreePassButton;
    
    UIScrollView                *m_DuoChuanPassScollView;
    int                         duoChuanPassRadioIndex;
    NSMutableArray              *m_duoChuanPassRadioArray;
    
    BOOL                         m_expandBetCode;
    
    CombineList                 *m_duoChuanChooseArray;//存放 每场比赛的选择count ,例如 只有主胜 或 负 则为1  依次递增
    
    NSTimer                     *m_timer;
    
    CombineList                 *m_Com_SParray;//所有的 赔率
    CombineList                 *m_Com_arrangeSP_Min;//排列之后的 赔率（最小的）
    CombineList                 *m_Com_arrangeSP_Max;//排列之后的 赔率（最da的
    
    double                      min_amount;//预计最小奖金
    double                      max_amount;//预计最大奖金
}
@property (nonatomic, retain) NSDictionary     *getShareDetileDic;
@property (nonatomic, retain) CombineList* m_Com_SParray;
@property (nonatomic, assign) int DanCount;
@property (nonatomic, assign) int  playTypeTag;//玩法
@property (nonatomic, retain) CustomSegmentedControl*     customSegmentView;
@property (nonatomic, retain) BJDC_LaunchHMViewController*  LaunchHMView;
@property (nonatomic, retain) IBOutlet UIScrollView* srollView_normalBet;
@property (nonatomic, retain) IBOutlet UIScrollView* srollView_HMBet;
@property (nonatomic, retain) IBOutlet UIButton*  buyButton;
@property (nonatomic, retain) IBOutlet UIView* view_down;
@property (nonatomic, retain) IBOutlet UIImageView *image_sanjiao;
@property (nonatomic, retain) IBOutlet UILabel *lotTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *allCountLabel;
@property (nonatomic, retain) IBOutlet UILabel *gameCountLabel;
@property (nonatomic, retain) IBOutlet UILabel *betNumberLable;
@property (nonatomic, retain) IBOutlet UILabel* batchCodeLabel;
@property (nonatomic, retain) IBOutlet UIButton *betCodeList;

@property (nonatomic, retain) IBOutlet UILabel *amountLabel;//预计奖金

@property (nonatomic, retain) IBOutlet UIButton *jiaBeishuButton;
@property (nonatomic, retain) IBOutlet UIButton *jianBeishuButton;

@property (nonatomic, retain) IBOutlet UITextField *fieldBeishu;
//@property (nonatomic, retain) IBOutlet UILabel *winAmount;

@property (nonatomic,assign) int gameCount;

@property (nonatomic,retain) CombineList *duoChuanChooseArray;


- (IBAction)betCodeClick:(id)sender;
- (IBAction)buyClick:(id)sender;
- (void) appendDuoChuanChoose:(NSString*)chooseCount IS_DAN:(BOOL)is_Dan CONFUSION:(NSArray*)confusion_array;

#pragma mark 计算赔率
-(void) appendArrangePS:(CombineBase*) PS;
-(void) sortSPArray;
@end
