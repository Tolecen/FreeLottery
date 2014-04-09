//
//  HMDTAutoOrderAmountSetcell.h
//  RuYiCai
//
//  Created by ruyicai on 12-11-14.
//
//

#import <UIKit/UIKit.h>
@class HMDTAutoOrderViewController;
@interface HMDTAutoOrderAmountSetcell : UITableViewCell<UITextFieldDelegate>
{
    BOOL                    m_isByAllAmount;
    UIButton*               m_buttonByallAmount;
    UIButton*               m_buttonByPercent;
 
    UIView*                 m_viewByAllAmount;       //按因定金额定制
    UITextField*            m_orderAmountByAllAmount;       //按因定金额定制
    UITextField*            m_orderCountByAllAmount;
    UILabel*                m_freezeAmountLable;
    double                   m_freezeMonney;
    UIButton*               m_forceJoinButtonByAllAmount;
    UILabel*                m_forceJoinLableByAllAmount;
    
    BOOL                    m_forceJoinByAllAmount;//默认yes 强制参与
    BOOL                    m_forceJoinByPercent;//默认yes 强制参与
    
    
    UIView*                 m_viewByByPercent;       //按百分比定制
    UIButton*               m_buttonNoMaxByByPercent;//无金额上线
    UIButton*               m_buttonHaveMaxByPercent;//有金额上线
    BOOL                    m_hasMaxAmountByPercent;//默认 有金额上限
    
    UILabel*                m_lableHaveMaxByPercent;//有金额上线
    UITextField*            m_textHaveMaxByPercent;
    UILabel*                m_lableYuanHaveMaxByPercent;//有金额上线
    UIButton*               m_forceJoinButtonByPercent;
    UILabel*                m_forceJoinLableByPercent;
    
    
    UITextField*            m_orderAmountByPercent;
    UITextField*            m_orderCountByPercent;         
    
    HMDTAutoOrderViewController*    m_superViewController;
 
}
@property(nonatomic,retain) HMDTAutoOrderViewController* superViewController;
-(void) refresh;
@end
