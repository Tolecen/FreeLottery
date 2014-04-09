//
//  AnalogSeleNumViewController.h
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 12-12-12.
//
//

#import <UIKit/UIKit.h>

@interface AnalogSeleNumViewController : UIViewController
{
    NSString*   m_lotNo;
    NSString*   m_sellWay;//遗漏值类型
    
    UIScrollView*  m_mainScrollView;
    
    UILabel*    m_selectAllCountLabel;
    UILabel*    m_selectRedNumLabel;
    UILabel*    m_selectBlueNumLabel;
    NSInteger   m_redNumCount;
    NSInteger   m_blueNumCount;
}
@property(nonatomic, retain) NSString*   lotNo;
@property(nonatomic, retain) NSString*   sellWay;
@end
