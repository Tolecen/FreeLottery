//
//  ZCJinQiuCaiView.h
//  RuYiCai
//
//  Created by haojie on 11-12-2.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZCJinQiuCaiView : UIView
{
	NSMutableArray *m_ballState;
	UILabel     *m_indexLabel;
	UILabel     *m_hTeamLabel;
	UILabel     *m_vTeamLabel;

	UIButton    *m_fenxiButton;
	
	NSString    *m_index;
	NSString    *m_hTeam;
	NSString    *m_vTeam;
	NSString    *m_avgOdds;
	NSString    *m_cDate;
}

@property(nonatomic, retain)UILabel     *indexLabel;
@property(nonatomic, retain)UILabel     *hTeamLabel;
@property(nonatomic, retain)UILabel     *vTeamLabel;
@property(nonatomic, retain)UIButton    *fenxiButton;
@property(nonatomic, retain)NSString    *index;
@property(nonatomic, retain)NSString    *hTeam;
@property(nonatomic, retain)NSString    *vTeam;
@property(nonatomic, retain)NSString    *avgOdds;
@property(nonatomic, retain)NSString    *cDate;

- (void)refreshView;
- (void)pressedBallButton:(UIButton*)ballButton;
- (void)pressedFenxiButton;
- (NSArray*)selectedIndexArray;
- (NSArray*)selectedFirstLineArray;
- (NSArray*)selectedSecondLineArray;
- (void)clearBallState;

@end
