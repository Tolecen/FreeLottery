//
//  LKLPayment.h
//  LklSDK
//
//  Created by ifuninfo on 12-6-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    Completion,//成功
    NotFoundApp,//尚未安装拉卡拉应用
    Error_MerId,//merId为空
    Error_MerPswd,//merPswd为空
    Error_OrderId,//orderId为空
    Error_Amount,//amount为空
    Error_MinCode,//minCode为空
    Error_RedirectURL,//redirectURL为空
    Error_Random      //随机数传值为空
}ErrorType;


/*
 *支付成功会以openURL方式返回，返回Completion则成功，Failed则失败
 */

@interface LKLPayment : NSObject


/*
 * merId:商户编号
 * mac:商户的密码等编码成的字符串，进过MD5加密以后的值
 * orderId:商户订单号
 * amount:交易金额.单位为元，小数点后两位（例100.20）
 * minCode:快捷商户编号(快捷商户：拉卡拉分配(若不是快捷商户，则不用添加))
 * redirectURL: URL Schemes 支付成功后跳转路径 (例如: tel)
 * 商户取得的随机数应和mac中的随机数一致
 */

+ (ErrorType)openLKLWithMerId:(NSString *)merId
                      orderId:(NSString *)orderId
                       amount:(NSString *)amount
                          mac:(NSString *)mac
                      minCode:(NSString *)minCode
                  redirectURL:(NSString *)redirectURL
                       random:(NSString *)rnd;

@end
