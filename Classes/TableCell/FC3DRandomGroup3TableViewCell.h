//
//  FC3DRandomGroup3TableViewCell.h
//  RuYiCai
//
//  Created by LiTengjie on 11-9-8.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRandomBallWidth   (32)
#define kRandomBallHeight  (32)
#define kRandomLeftOffset  (2)
#define kRandomRightOffset (4)
#define kRandomTopOffset   (4)

@interface FC3DRandomGroup3TableViewCell : UITableViewCell {
    int             m_redMax;
    int             m_redNum;
    NSMutableArray *m_randomData;
    NSIndexPath    *m_indexPath;
	BOOL           m_isSort;
}

@property (nonatomic, retain) NSIndexPath* indexPath;
@property (nonatomic, retain) NSMutableArray* randomData;

- (void)setSort:(BOOL)isSort;
- (void)createRandomData;
- (void)setRedNum:(int)redNum inRedMax:(int)redMax dxds:(BOOL)dxds;

@end
