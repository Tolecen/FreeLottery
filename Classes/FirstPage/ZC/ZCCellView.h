//
//  ZCCellView.h
//  RuYiCai
//
//  Created by haojie on 11-12-2.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZCCellView : UIView 
{
	NSMutableArray *m_ballState;
	UILabel     *m_indexLabel;
	UILabel     *m_hTeamLabel;
	UILabel     *m_vTeamLabel;
	UILabel     *m_sortLabel;
	
	UIButton    *m_thereButton;
	UIButton    *m_oneButton;
	UIButton    *m_zeroButton;
	UIButton    *m_fenxiButton;
	
	NSString    *m_index;
	NSString    *m_hTeam;
	NSString    *m_vTeam;
	NSString    *m_avgOdds;
	NSString    *m_cDate;
	NSString    *m_sort;
	
	BOOL        m_isPress;
}

@property(nonatomic, retain)UILabel     *indexLabel;
@property(nonatomic, retain)UILabel     *hTeamLabel;
@property(nonatomic, retain)UILabel     *vTeamLabel;
@property(nonatomic, retain)UILabel     *sortLabel;
@property(nonatomic, retain)UIButton    *thereButton;
@property(nonatomic, retain)UIButton    *oneButton;
@property(nonatomic, retain)UIButton    *zeroButton;
@property(nonatomic, retain)UIButton    *fenxiButton;
@property(nonatomic, retain)NSString    *index;
@property(nonatomic, retain)NSString    *hTeam;
@property(nonatomic, retain)NSString    *vTeam;
@property(nonatomic, retain)NSString    *avgOdds;
@property(nonatomic, retain)NSString    *cDate;
@property(nonatomic, retain)NSString    *m_sort;
@property(nonatomic, assign)BOOL        m_isPress;

- (void)pressedBallButton:(UIButton*)ballButton;
- (void)refreshView;
- (void)pressedFenxiButton;
- (void)clearBallState;
- (NSMutableArray*)selectedBallsArray;
- (BOOL)haveBallPress;

@end
