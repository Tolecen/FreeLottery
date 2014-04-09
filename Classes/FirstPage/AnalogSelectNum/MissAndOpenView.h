//
//  MissAndOpenView.h
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 12-12-13.
//
//

#import <UIKit/UIKit.h>

#define batchCodeLabelWidth (80)
#define ballHeigth (33)

@interface MissAndOpenView : UIView
{
    NSString*  m_lotNo;
    
    NSArray*   m_dataArray;
}

@property(nonatomic, retain)NSString*  lotNo;
@property(nonatomic ,retain)NSArray*   dataArray;

@end
