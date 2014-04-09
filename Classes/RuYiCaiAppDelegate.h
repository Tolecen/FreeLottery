//
//  RuYiCaiAppDelegate.h
//  RuYiCai
//
//  Created by ruyicai on 09-3-28.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AdSupport/AdSupport.h>
#import "RandomPickerViewController.h"
#import "RYCLoginView.h"
#import "WXApi.h"
#import "RespForWeChatViewController.h"
#import "MobClick.h"


//腾讯微博
#define AppTokenKey		@"tokenKey"
#define AppTokenSecret	@"tokenSecret"

//友盟
#define UMENG_APPKEY @"5031952552701513a300016d"

@class CustomTabBarViewController;
@class RuYiCaiViewController;
@class RuYiCaiStartViewController;
@class ActivityView;

@interface RuYiCaiAppDelegate : NSObject <UIApplicationDelegate,UIAlertViewDelegate, WXApiDelegate,RespForWeChatViewDelegate> {
    UIWindow                   *m_window;
    RuYiCaiViewController      *m_viewController;
	
	RandomPickerViewController *randomPickerView;
    RuYiCaiStartViewController *m_startViewController;
    RYCLoginView               *loginView;
    ActivityView               *m_activityView;//联网框
    
    BOOL                       m_autoRememberMystatus;
    NSString*                  m_autoLoginRandomNumber;//自动登录成功 返回的代码
  
    BOOL                       m_isShowNewFuctionInfo;
    
    //腾讯微博记录值
    NSString                   *tokenKey;
	NSString                   *tokenSecret;
    NSString                   *verifier;//验证
	NSString                   *response;
    
//    //新浪微博
//    SinaWeibo *sinaweibo;
    //摇一摇
    BOOL                       m_isStartYaoYiYao;
}

/*
 自动登录
 */

@property (nonatomic, assign) BOOL autoRememberMystatus; 
@property (nonatomic, retain) NSString* autoLoginRandomNumber;


- (void)readAutoLoginPlist;
- (NSString*)getAutoLoginPath;
- (void)saveAutoLoginPlist;
- (void)resetAutoLoginPlist;
- (void)setLoginRandomNumberNil;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RuYiCaiViewController *viewController;

@property (nonatomic, retain) RandomPickerViewController *randomPickerView;
@property (nonatomic, retain) RYCLoginView         *loginView;
@property (nonatomic, retain) ActivityView         *activityView;

@property (nonatomic, assign) BOOL   isShowNewFuctionInfo;

@property (nonatomic, copy) NSString *tokenKey;
@property (nonatomic, copy) NSString *tokenSecret;
@property (nonatomic, copy) NSString *verifier;
@property (nonatomic, copy) NSString *response;
@property (nonatomic, retain) CustomTabBarViewController *mainMenuTabbar;

- (void)showLoading:(id)sender;

- (void)readUserPlist;
- (void)saveUserPlist;
- (void)resetUserPlist;

//腾讯微博
- (void)parseTokenKeyWithResponse:(NSString *)response;
- (void)saveDefaultKey;
- (void)loadDefaultKey;

//异常发送
- (void)sendException;
//摇一摇
@property (nonatomic, assign) BOOL   isStartYaoYiYao;

@property (nonatomic,retain) NSString * betchString;
- (void)setYaoYiYao:(BOOL)isStart;
@end

