//
//  RTBWall.h
//  AdWallRTB
//
//  Created by 马明 on 14-1-7.
//  Copyright (c) 2014年 马明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class RTBWall;

typedef enum
{
    RTBWallThemeColor_White,
    RTBWallThemeColor_Orange,			//get ad header
    RTBWallThemeColor_Blue,		//get ad body
    RTBWallThemeColor_Red,
    RTBWallThemeColor_Green,
} RTBWallThemeColor; // RTBWall 主题颜色


/*
 用于异步通知从网络抓取文件成功
 */
@protocol RTBWallFetchUrlDelegate <NSObject>

@required
- (void)didFetchUrl:(NSString*)sUrl WithData:(NSData*)retData;

@end

@protocol RTBWallDelegate <NSObject>

@required
// 查询积分回调 参数adArray存储的数据位获得积分的广告信息，该数组元素内容为NSDictionary类型，包括广告名字和积分数，key值分别为name和point
- (void)didReceiveResultGetScore:(int)point withAdInfo:(NSArray*)adArray;
// 消费积分回调
- (void)didSpendScoreSuccessAndResidualScore:(int)point;
// 消费积分失败
- (void)didFailedSpendScoreWithError:(NSError*)error;
@optional
// 是否打印日志
- (BOOL)logMode;
// 是否为测试模式
- (BOOL)testMode;
// 广告请求失败
- (void)didFailToReceiveAd:(RTBWall*)adWall Error:(NSError*)error;
// 广告请求成功
- (void)didReceiveAd:(RTBWall*)adWall;
// RTBWall关闭回调
- (void)rtbWallDidDismissScreen:(UIViewController*)adWall;
// RTBWall展示成功(暂未调用)
//- (void)rtbWallWillPresentScreen:(UIViewController*)adWall;
// 查询中奖结果成功
- (void)didReceiveResultGetLotteryWinning:(NSArray*)winInfo;
// 查询中奖结果失败
- (void)didFailedExaminationResultGetLotteryWinning:(NSError*)error;

@end

@interface RTBWall : NSObject

@property (assign, nonatomic) id<RTBWallDelegate> delegate;

// 创建 RTBWall
- (RTBWall*)initWithAppID:(NSString*)appID andDelegate:(id<RTBWallDelegate>)delegate;

// 查询积分
- (void)getScore;
// 消费积分（只限用于积分墙）
- (void)spendScore:(int)score;
// 展示RTBWall
- (void)showRTBWallWithController:(UIViewController*)viewController;
// 设置RTBWall的主题颜色
- (void)setRTBWallColor:(RTBWallThemeColor)color;
// 设置RTBWall模式（rewarded为YES时为积分墙，为NO时为彩票墙;默认为积分墙）
- (void)setRTBWallModel:(BOOL)rewarded;
// 设置开发者账户体系的用户名；该方法请在调用showRTBWallWithController:方法之前调用，避免不能及时生效。
- (void)setDeveloperUserID:(NSString*)userID;
// 查询近期购买的彩票是否中奖（只限用于彩票墙）
- (void)examinationTheInfoOfWinningLottery;
// 设置积分墙右上角积分view是否显示（只限用于积分墙,默认为展示；该方法请在调用showRTBWallWithController:方法之前调用，否则设置无效，会取默认展示的效果）
- (void)setDisplayScoreView:(BOOL)isDisplay;

@end
