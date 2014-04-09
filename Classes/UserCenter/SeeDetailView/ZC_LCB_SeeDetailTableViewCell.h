//
//  ZC_LCB_SeeDetailTableViewCell.h
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 13-1-21.
//
//

#import <UIKit/UIKit.h>

@interface ZC_LCB_SeeDetailTableViewCell : UIView
{
    NSDictionary*                   m_contentStr;
    BOOL                            isZC_JQC;
}
@property(nonatomic, assign)BOOL   isZC_JQC;
@property(nonatomic,retain) NSDictionary* contentStr;
@end
