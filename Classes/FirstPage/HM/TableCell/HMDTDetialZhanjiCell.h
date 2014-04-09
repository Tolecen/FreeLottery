//
//  HMDTDetialZhanjiCell.h
//  RuYiCai
//
//  Created by ruyicai on 12-9-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMDTBetCaseLotViewController;
@interface HMDTDetialZhanjiCell : UITableViewCell
{
    UILabel*    cellLabel;
    NSString*   cellTitle;
    //金冠，金杯，金钻，金星，灰冠，灰杯，灰钻，灰星
    
    NSInteger   m_graygoldStar;
    NSInteger   m_graydiamond;
    NSInteger   m_graycup;
    NSInteger   m_graycrown;
    
    NSInteger   m_goldStar;
    NSInteger   m_diamond;
    NSInteger   m_cup;
    NSInteger   m_crown;
    HMDTBetCaseLotViewController* m_superViewController;
}
@property (nonatomic, retain) HMDTBetCaseLotViewController* superViewController;
@property (nonatomic, retain) NSString*   cellTitle;
@property (nonatomic, assign) NSInteger graygoldStar;
@property (nonatomic, assign) NSInteger graydiamond;
@property (nonatomic, assign) NSInteger graycup;
@property (nonatomic, assign) NSInteger graycrown;
@property (nonatomic, assign) NSInteger goldStar;
@property (nonatomic, assign) NSInteger diamond;
@property (nonatomic, assign) NSInteger cup;
@property (nonatomic, assign) NSInteger crown;

- (void)refreshCell;

@end
