//
//  UmpayCreditCardVC.h
//  Boyacai
//
//  Created by qiushi on 13-6-3.
//
//

#import <UIKit/UIKit.h>

@interface WealthTenpayVC : UIViewController
{
    UITextField*        m_amountTextField;
    NSString          *m_ipAdressStr;
    NSUInteger  an_Integer;
    NSArray * ipItemsArray;
    NSString *externalIP;
}

@property(nonatomic, retain) UITextField *amountTextField;
@property(nonatomic, retain) NSString    *ipAdressStr;
@property(nonatomic, retain) NSString * lotNo;

@end
