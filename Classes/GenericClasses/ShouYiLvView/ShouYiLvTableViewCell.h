//
//  ShouYiLvTableViewCell.h
//  RuYiCai
//
//  Created by  on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

/*{"batchCode":"2012071101","lotMulti":"1","currentIssueInput":"200","currentIssueYield":"400","accumulatedInput":"200","accumulatedYield":"400","yieldRate":"200.00%"}
 */

@interface ShouYiLvTableViewCell : UITableViewCell
{
    UILabel*         batchCodeLabel;
    UILabel*         lotMultiLabel;
    UILabel*         currentIssueInputLabel;
    UILabel*         currentIssueYieldLabel;
    UILabel*         accumulatedInputLabel;
    UILabel*         accumulatedYieldLabel;
    UILabel*         yieldRateLabel;
    
    NSString*         batchCodeStr;
    NSString*         lotMultiStr;
    NSString*         currentIssueInputStr;
    NSString*         currentIssueYieldStr;
    NSString*         accumulatedInputStr;
    NSString*         accumulatedYieldStr;
    NSString*         yieldRateStr;    
}

@property(nonatomic, retain)NSString*         batchCodeStr;
@property(nonatomic, retain)NSString*         lotMultiStr;
@property(nonatomic, retain)NSString*         currentIssueInputStr;
@property(nonatomic, retain)NSString*         currentIssueYieldStr;
@property(nonatomic, retain)NSString*         accumulatedInputStr;
@property(nonatomic, retain)NSString*         accumulatedYieldStr;
@property(nonatomic, retain)NSString*         yieldRateStr;

- (void)refreshCell;

@end
