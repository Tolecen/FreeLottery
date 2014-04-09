//
//  DataAnalysis_top_tableCell.h
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 13-4-18.
//
//

#import <UIKit/UIKit.h>

typedef enum
{
    TOPCELL_BASE = 0,
    TOPCELL_EUROP,//欧指
    TOPCELL_ASIA,//足球亚盘
    
    TOPTYPE_RANGFEN,//篮球让分
    TOPTYPE_ALLSCORE,//篮球总分
}TopCell_type;

@interface DataAnalysis_top_tableCell : UIView

@property(nonatomic, assign)TopCell_type topType;
@property(nonatomic, assign)BOOL         isJCLQ;

@end
