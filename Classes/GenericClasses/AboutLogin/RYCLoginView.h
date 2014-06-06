//
//  RYCLoginView.h
//  RuYiCai
//
//  Created by  on 12-2-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RuYiCaiAppDelegate;

@interface RYCLoginView : UINavigationController<UITextFieldDelegate>
{
    UITextField*    m_loginPhonenumTextField;
    UITextField*    m_loginPswTextField;
    UIButton*       m_rememberMyLoginStatusPswButton;
    
    
    RuYiCaiAppDelegate         *m_delegate;
    BOOL            isRemberPsw;
    
    BOOL            isRemberMyLoginStatus;
    BOOL            isUseclearPws;
    UIButton       *useClearPws;
    
    UIView*         m_loginView;
    UIView*         m_registerView;
    
    UITableView     *m_myTableView;
//    TencentOAuth*   _tencentOAuth;
    NSMutableArray* _permissions;
    
//    SinaWeibo      *sinaweibo;
    
    NSDictionary    *userInfo;
    //支付宝联合登陆属性
    NSString *partner;
	
	NSString *seller;
    UIButton        *_loginButton;
    BOOL            isExpendCoop;
    UIView          *_cooperationView;
    
}
@property (nonatomic ,retain)UITextField*    loginPhonenumTextField;
@property (nonatomic ,retain)UITextField*    loginPswTextField;
@property (nonatomic ,retain)UIButton*       rememberMyLoginStatusPswButton;
@property (nonatomic ,assign)BOOL            isRemberMyLoginStatus;
@property (nonatomic ,assign)BOOL            isUseclearPws;
@property (nonatomic ,retain)UIButton       *useClearPws;

@property (nonatomic ,retain)UITableView     *myTableView;

@property (nonatomic, retain)NSDictionary *userInfo;
@property(retain,nonatomic)UITextField* userId;

- (void)SinaHandleOpenURL:(NSNotification*)notification;
- (void)SinaBecomeActive:(NSNotification*)notification;

- (void)setMainView;
- (void)presentModalView:(UIView *)subView andAddAnimationType:(BOOL)animationType;
- (void)presentModalView:(UIView *)subView;
- (void)dismissModalView:(UIView *)subView;

- (void)cancelLoginClick:(id)sender;
- (void)useClearPswClick;
- (void)forgetPasswordClick:(id)sender;
- (void)registerClick:(id)sender;

@end