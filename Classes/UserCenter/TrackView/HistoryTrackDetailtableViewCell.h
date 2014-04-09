//
//  HistoryTrackDetailtableViewCell.h
//  RuYiCai
//
//  Created by  on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

/*{"batchCode":"2012071201","lotMulti":"1","amount":"200","winCode":"","state":"1","stateMemo":"已完成","prizeAmt":"0","desc":"2_4_200.00%"}*/
@interface HistoryTrackDetailtableViewCell : UITableViewCell
{
    UILabel*         batchCodeLabel;
    UILabel*         lotMultiLabel;
    UILabel*         amountLabel;
    UILabel*         stateLabel;
    UILabel*         winCodeLabel;
    UILabel*         winAccountLabel;
    UILabel*         planInputLabel;
    UILabel*         planYieldLabel;
    UILabel*         yieldRateLabel;
    
    NSString*         batchCodeStr;
    NSString*         lotMultiStr;
    NSString*         amountStr;
    NSString*         stateStr;
    NSString*         winCodeStr;
    NSString*         winAccountStr;
    NSString*         planStr;
}

@property(nonatomic, retain)NSString*         batchCodeStr;
@property(nonatomic, retain)NSString*         lotMultiStr;
@property(nonatomic, retain)NSString*         amountStr;
@property(nonatomic, retain)NSString*         stateStr;
@property(nonatomic, retain)NSString*         winCodeStr;
@property(nonatomic, retain)NSString*         winAccountStr;
@property(nonatomic, retain)NSString*         planStr;
   

- (void)refreshCell;



@end
