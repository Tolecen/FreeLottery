//
//  EditShareContentViewController.m
//  PetGroup
//
//  Created by wangxr on 13-12-19.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "EditShareContentViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "ActivitiesViewController.h"
#import "ColorUtils.h"
@interface EditShareContentViewController ()
@property (nonatomic,retain) UITextView * textV;
@end

@implementation EditShareContentViewController
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackground];
    [AdaptationUtils adaptation:self];
//    self.navigationItem.title = @"邀请好友";
    self.navigationItem.titleView = ({
        UILabel*label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:18];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"邀请好友";
        label;
    });
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:({UIButton * nextB = [UIButton buttonWithType:UIButtonTypeCustom];
        nextB.frame = CGRectMake(0, 0, 52, 30);
//        [nextB setBackgroundImage:[UIImage imageNamed:@"nextBtn"] forState:UIControlStateNormal];
        [nextB.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [nextB setTitle:@"分享" forState:UIControlStateNormal];
        [nextB setBackgroundImage:[UIImage imageNamed:@"item_bar_right_button_normal.png"] forState:UIControlStateNormal];
        [nextB setBackgroundImage:[UIImage imageNamed:@"item_bar_right_button_click.png"] forState:UIControlStateHighlighted];
        [nextB addTarget:self action:@selector(shareContent) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:nextB];
        nextB;
    })];
    
	self.textV = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-253)];
    _textV.text = self.contentString;
    [_textV becomeFirstResponder];
    _textV.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:_textV];
}
- (void)back:(id)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)backButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)shareContent
{
    switch (self.shareStyle) {
        case shareStyleSineWeiBo:{
            id<ISSContent> publishContent = [ShareSDK content:_textV.text
                                               defaultContent:nil
                                                        image:nil
                                                        title:nil
                                                          url:nil
                                                  description:nil
                                                    mediaType:SSPublishContentMediaTypeText];
            id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                                 allowCallback:YES
                                                                 authViewStyle:SSAuthViewStyleFullScreenPopup
                                                                  viewDelegate:nil
                                                       authManagerViewDelegate:nil];
            [ShareSDK shareContent:publishContent
                              type:ShareTypeSinaWeibo
                       authOptions:authOptions
                     statusBarTips:NO
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess) {
                                    if (self.delegate) {
                                        [_delegate shareContentSuccess];
                                    }
                                    [self dismissViewControllerAnimated:YES completion:nil];
                                }
                                if (state == SSResponseStateFail) {
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                        message:[NSString stringWithFormat:@"发送失败!%@", [error errorDescription]]
                                                                                       delegate:nil
                                                                              cancelButtonTitle:@"知道了"
                                                                              otherButtonTitles:nil];
                                    [alertView show];
                                }
                            }];
        }break;
        case shareStyleTencentWeiBo:{
            id<ISSContent> publishContent = [ShareSDK content:_textV.text
                                               defaultContent:nil
                                                        image:nil
                                                        title:nil
                                                          url:nil
                                                  description:nil
                                                    mediaType:SSPublishContentMediaTypeText];
            id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                                 allowCallback:YES
                                                                 authViewStyle:SSAuthViewStyleFullScreenPopup
                                                                  viewDelegate:nil
                                                       authManagerViewDelegate:nil];
            [ShareSDK shareContent:publishContent
                              type:ShareTypeTencentWeibo
                       authOptions:authOptions
                     statusBarTips:NO
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess) {
                                    if (self.delegate) {
                                        [_delegate shareContentSuccess];
                                    }
                                    [self dismissViewControllerAnimated:YES completion:nil];
                                }
                                if (state == SSResponseStateFail) {
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                        message:[NSString stringWithFormat:@"发送失败!%@", [error errorDescription]]
                                                                                       delegate:nil
                                                                              cancelButtonTitle:@"知道了"
                                                                              otherButtonTitles:nil];
                                    [alertView show];
                                }
                            }];
        }break;
        case shareStylerenren:{
            id<ISSContent> publishContent = [ShareSDK content:_textV.text
                                              defaultContent:@""
                                                        image:[ShareSDK jpegImageWithImage:[UIImage imageNamed:@"icon-144"] quality:1]
                                                       title:@""
                                                         url:nil
                                                 description:@""
                                                   mediaType:SSPublishContentMediaTypeText];
            id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                                 allowCallback:YES
                                                                 authViewStyle:SSAuthViewStyleFullScreenPopup
                                                                  viewDelegate:nil
                                                       authManagerViewDelegate:nil];
            [ShareSDK shareContent:publishContent
                              type:ShareTypeRenren
                       authOptions:authOptions
                     statusBarTips:NO
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess) {
                                    if (self.delegate) {
                                        [_delegate shareContentSuccess];
                                    }
                                    [self dismissViewControllerAnimated:YES completion:nil];
                                }
                                if (state == SSResponseStateFail) {
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                        message:[NSString stringWithFormat:@"发送失败!%@", [error errorDescription]]
                                                                                       delegate:nil
                                                                              cancelButtonTitle:@"知道了"
                                                                              otherButtonTitles:nil];
                                    [alertView show];
                                }
                            }];
        }break;
        default:
            break;
    }
    
}
@end
