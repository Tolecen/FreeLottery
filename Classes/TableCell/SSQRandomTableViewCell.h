//
//  SSQRandomTableViewCell.h
//  RuYiCai
//
//  Created by LiTengjie on 11-8-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRandomBallWidth   (25)
#define kRandomBallHeight  (25)
#define kRandomLeftOffset  (2)
#define kRandomRightOffset (2)
#define kRandomTopOffset   (2)

#define kLuckBallWidth   (25)
#define kLuckBallHeight  (25)

@interface SSQRandomTableViewCell : UITableViewCell {
    int             m_redMax;
    int             m_blueMax;
    int             m_redNum;
    int             m_blueNum;
    NSMutableArray *m_randomData;  //存储随机数, redNum + blueNum（个）
    NSIndexPath    *m_indexPath;
	BOOL           isSort;//是否排序
    
    BOOL           isLuckView;//是否是幸运选号产生的（球小，没有删除按钮）
}

@property (nonatomic, retain) NSIndexPath* indexPath;
@property (nonatomic, retain) NSMutableArray* randomData;
@property (nonatomic, assign) BOOL isSort;
@property (nonatomic, assign) BOOL isLuckView;

- (void)createRandomData;
- (void)setRedNum:(int)redNum inRedMax:(int)redMax andBlueNum:(int)blueNum inBlueMax:(int)blueMax;

@end