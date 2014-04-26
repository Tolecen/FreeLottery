//
//  ExchangeLotteryViewController.h
//  Boyacai
//
//  Created by fengyuting on 14-1-14.
//
//

#import <UIKit/UIKit.h>
#import "ThirdPageTabelCellView.h"
#import "RuYiCaiNetworkManager.h"
#import "RuYiCaiAppDelegate.h"
#import "ActivityView.h"
#import <immobSDK/immobView.h>
#import "YouMiConfig.h"
#import "YouMiWall.h"
#import "DianRuAdWall.h"
//#import<Escore/YJFUserMessage.h> 
//#import<Escore/YJFInitServer.h>
//#import<Escore/YJFAdWall.h> 
//#import<Escore/YJFIntegralWall.h> 
//#import<Escore/YJFBanner.h> 
//#import<Escore/YJFInterstitial.h> 
//#import<Escore/YJFScore.h>
#import "DMOfferWallViewController.h"

#define LiMeiAdID     @"2ccba7d7614fbdc10c1c532c822205ca"
#define YouMiAdWallPublishID  @"1915de8d0608f33f"
#define YouMiAdWallSecret  @"92e33e961d5789c0"
#define DianRuAppKey     @"0000911311000001"
#define EScoreUserAppId   @"70515"
#define EScoreUserDevId   @"80098"
#define EScoreAppkey      @"EM5YP9F8HWSMPL9LFRA48YEBLC6BFG4MRF"
#define EScoreChannel     @"appstore"
#define DuoMengPublisherID   @"96ZJ21XAzePizwTAUd"

@class ADWallViewController;
@interface ExchangeLotteryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,immobViewDelegate,DianRuAdWallDelegate,DMOfferWallDelegate>
{
    RuYiCaiAppDelegate  *m_delegate;
    NSArray * titleArray;
    NSString * theUserID;
    UIWindow * keywindow;
    ADWallViewController * adWallV;
    DMOfferWallViewController *_offerWallController;
    
    UIView * bgBTopBar;
}

@property(nonatomic, assign)BOOL isShowTabBar;
@property(nonatomic, retain)UITableView * listTableV;
@property(nonatomic, retain)NSString * theUserID;


/**********力美********/
@property (nonatomic, retain)immobView *adView_adWall;
-(void)enterLiMeiAdWall;
-(void)QueryScore;
-(void)ReduceScore;

@end
