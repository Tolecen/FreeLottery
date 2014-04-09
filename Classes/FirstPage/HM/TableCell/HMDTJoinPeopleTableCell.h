//
//  HMDTJoinPeopleTableCell.h
//  RuYiCai
//
//  Created by  on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
/*{"nickName":"小伙计007","buyAmt":"100","buyTime":"2012-07-16 14:25:50","cancelCaselotbuy":"false","state":"0"}*/
@interface HMDTJoinPeopleTableCell : UITableViewCell
{
    UILabel*    nickNameLabel;
    UIButton*   cancelCaseButton;
    UILabel*    buyTimeLabel;
    UILabel*    buyAmtLabel;
    
    UILabel*    canceledCaseLabel;
}

@property(nonatomic, retain)NSString*   nickName;
@property(nonatomic, retain)NSString*   state;
@property(nonatomic, retain)NSString*   buyTime;
@property(nonatomic, retain)NSString*   buyAmt;
@property(nonatomic, retain)NSString*   caseLotId;
@property(nonatomic, retain)NSString*   beState;//0为已撤资

- (void)refreshCell;
- (void)cancelCaselotbuyClick;
@end
