//
//  ExchangeLotteryViewController.h
//  Boyacai
//
//  Created by fengyuting on 14-1-14.
//
//

#import <UIKit/UIKit.h>
#import "RTBWall.h"
#import <iAd/iAd.h>
#import "iAd/ADBannerView.h"
#import "ThirdPageTabelCellView.h"
#import "AdWallTopCell.h"
#import "RuYiCaiNetworkManager.h"
#import "RuYiCaiAppDelegate.h"
#import "ActivityView.h"
#import "ADIntroduceViewController.h"
#import <immobSDK/immobView.h>
#import "YouMiConfig.h"
#import "YouMiWall.h"
#import "DianRuAdWall.h"
#import "DiskViewController.h"
#import "OtherActivityViewController.h"
//#import<Escore/YJFUserMessage.h>
//#import<Escore/YJFInitServer.h>
//#import<Escore/YJFAdWall.h>
//#import<Escore/YJFIntegralWall.h>
//#import<Escore/YJFBanner.h>
//#import<Escore/YJFInterstitial.h>
//#import<Escore/YJFScore.h>
#import "DMOfferWallViewController.h"
#import "MiidiManager.h"
#import "MiidiAdWallSpendPointsDelegate.h"
#import "MiidiAdWallAwardPointsDelegate.h"
#import "MiidiAdWallGetPointsDelegate.h"
#import "MiidiAdWallShowAppOffersDelegate.h"
#import "MiidiAdWallRequestToggleDelegate.h"
#import "MiidiAdDesc.h"
#import "MiidiAdWall.h"
#import "SFHFKeychainUtils.h"


#define LiMeiAdID     @"2ccba7d7614fbdc10c1c532c822205ca"
#define YouMiAdWallPublishID  @"1915de8d0608f33f"
#define YouMiAdWallSecret  @"92e33e961d5789c0"
#define DianRuAppKey     @"0000911311000001"
#define EScoreUserAppId   @"70515"
#define EScoreUserDevId   @"80098"
#define EScoreAppkey      @"EM5YP9F8HWSMPL9LFRA48YEBLC6BFG4MRF"
#define EScoreChannel     @"appstore"
#define DuoMengPublisherID   @"96ZJ21XAzePizwTAUd"
#define MiidiPublisher       @"17140"
#define MiidiAppSecret       @"37spm32qxkrsxn90"
#define AdViewKey      @"RTB20140915090425fqfoawfedeh48n9"

#define MaxAllowIDFACount   5
#define CurrentIDFA   @"currentIDFA"
#define CheckCheatStatus  @"checkcheatstatusfreelotteryquanmin"
#define IDFACount   @"idfaCount"

@class ADWallViewController;
@interface ExchangeLotteryWithIntegrationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,immobViewDelegate,DianRuAdWallDelegate,DMOfferWallDelegate,MiidiAdWallShowAppOffersDelegate,UIAlertViewDelegate,RTBWallDelegate,ADBannerViewDelegate>
{
    RuYiCaiAppDelegate  *m_delegate;
    NSArray * titleArray;
    NSArray * realArray;
    NSArray * notRealArray;
    NSString * theUserID;
    UIWindow * keywindow;
    ADWallViewController * adWallV;
    DMOfferWallViewController *_offerWallController;
    
    UIView * bgBTopBar;
    BOOL AdWallHaveInit;
    NSString * previousUserno;
    BOOL realAdwall;
    NSString * exchangeScale;
//    BOOL shouldShowTabbar;
    ADBannerView * bannerView;
    UIButton * imgV;
    UIImageView * bgv;
    BOOL adAdded;
    
    NSArray * jifenImgArray;
}

@property(nonatomic, assign)BOOL isShowTabBar;
@property(nonatomic, retain)UITableView * listTableV;
@property(nonatomic, retain)NSString * theUserID;
@property(nonatomic, retain)RTBWall * rtbAdWall; //Adview
@property (nonatomic) BOOL isShowBackButton;
@property (nonatomic,assign) BOOL shouldShowTabbar;

/**********力美********/
@property (nonatomic, retain)immobView *adView_adWall;
-(void)enterLiMeiAdWall;
-(void)QueryScore;
-(void)ReduceScore;

@end
