//
//  JC_SeeDetailTableViewCell.h
//  RuYiCai
//
//  Created by ruyicai on 12-12-19.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#define betContentCellHeight (18)
#define CellHeight (60)

@interface JC_SeeDetailTableViewCell : UIView<UITextViewDelegate>
{
    NSDictionary*                   m_contentStr;
}
@property(nonatomic, retain) NSDictionary* contentStr;
@property(nonatomic, retain)NSString*       jc_lotNo;
@end
