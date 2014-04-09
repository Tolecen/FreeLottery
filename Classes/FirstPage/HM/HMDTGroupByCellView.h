//
//  HMDTGroupByCellView.h
//  RuYiCai
//
//  Created by LiTengjie on 11-10-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMDTGroupByViewController;

@interface HMDTGroupByCellView : UITableViewCell {
    NSString*   m_caseLotId;
    NSString*   m_starter;
    NSString*   m_starterUserNo;
    NSString*   m_totalAmt;
    NSString*   m_safeAmt;
    NSString*   m_buyAmt;
    NSString*   m_progressInfo;
    NSString*   m_safeRate;
    NSString*   m_lotNo;
    NSString*   m_lotName;
    NSString*   m_endTime;
    NSString*   m_batchCode;
    
    //金冠，金杯，金钻，金星，灰冠，灰杯，灰钻，灰星
    NSInteger   m_graygoldStar;
    NSInteger   m_graydiamond;
    NSInteger   m_graycup;
    NSInteger   m_graycrown;
    
    NSInteger   m_goldStar;
    NSInteger   m_diamond;
    NSInteger   m_cup;
    NSInteger   m_crown;
    
    
    NSString*   m_isTop;
    
    UILabel*    m_lotNameLable;
    UILabel*    m_starterLabel;
    UILabel*    m_progressInfoLabel;
    UILabel*    m_totalAmtLabel;
//    UILabel*    m_buyAmtLabel;
    CGPoint     m_beganTouchPt;
 
    NSInteger   icoHeightIndex;
    HMDTGroupByViewController* m_superViewController;
    
    
    
    //新布局的属性
    UILabel *_titleLabel;
    UILabel *_nameLabel;
    UILabel *_progressNumLabel;
    UILabel *_schemeTextLabel;
}

@property (nonatomic, retain) NSString* caseLotId;
@property (nonatomic, retain) NSString* starter;

@property (nonatomic, retain) NSString* starterUserNo;
@property (nonatomic, retain) NSString* totalAmt;
@property (nonatomic, retain) NSString* safeAmt;
@property (nonatomic, retain) NSString* buyAmt;
@property (nonatomic, retain) NSString* progressInfo;
@property (nonatomic, retain) NSString* lotNo;
@property (nonatomic, retain) NSString* batchCode;
@property (nonatomic, retain) NSString* lotName;
@property (nonatomic, retain) NSString* safeRate;
@property (nonatomic, retain) NSString* endTime;

@property (nonatomic, assign) NSInteger graygoldStar;
@property (nonatomic, assign) NSInteger graydiamond;
@property (nonatomic, assign) NSInteger graycup;
@property (nonatomic, assign) NSInteger graycrown;
@property (nonatomic, assign) NSInteger goldStar;
@property (nonatomic, assign) NSInteger diamond;
@property (nonatomic, assign) NSInteger cup;
@property (nonatomic, assign) NSInteger crown;

@property (nonatomic, retain) NSString* isTop;

@property (nonatomic, retain) HMDTGroupByViewController* superViewController;

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *progressNumLabel;
@property (nonatomic, retain) UILabel *schemeTextLabel;

- (void)refreshView;

@end
