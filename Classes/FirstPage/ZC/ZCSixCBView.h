//
//  ZCSixCBView.h
//  RuYiCai
//
//  Created by haojie on 11-12-5.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZCSixCBView : UIView
{
	NSMutableArray *m_ballState;
	UILabel     *m_indexLabel;
	UILabel     *m_hTeamLabel;
	UILabel     *m_vTeamLabel;
	UILabel     *m_sortLabelOne;
	UILabel     *m_sortLabelTwo;
		
	NSString    *m_index;
	NSString    *m_hTeam;
	NSString    *m_vTeam;
	NSString    *m_avgOdds;
	NSString    *m_sort;
}

@property(nonatomic, retain)UILabel     *indexLabel;
@property(nonatomic, retain)UILabel     *hTeamLabel;
@property(nonatomic, retain)UILabel     *vTeamLabel;
@property(nonatomic, retain)UILabel     *sortLabelOne;
@property(nonatomic, retain)UILabel     *sortLabelTwo;
@property(nonatomic, retain)NSString    *index;
@property(nonatomic, retain)NSString    *hTeam;
@property(nonatomic, retain)NSString    *vTeam;
@property(nonatomic, retain)NSString    *avgOdds;
@property(nonatomic, retain)NSString    *m_sort;

- (void)refreshView;
- (NSArray*)selectedIndexArray;
- (void)pressedBallButton:(UIButton*)ballButton;
- (NSArray*)selectedFirstLineArray;
- (NSArray*)selectedSecondLineArray;
- (void)clearBallState;

@end
