//
//  FC3DRandomTableViewCell.h
//  RuYiCai
//
//  Created by LiTengjie on 11-8-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRandomBallWidth   (32)
#define kRandomBallHeight  (32)
#define kRandomLeftOffset  (2)
#define kRandomRightOffset (4)
#define kRandomTopOffset   (4)

#define kLuckBallWidth   (28)
#define kLuckBallHeight  (28)

@interface FC3DRandomTableViewCell : UITableViewCell {
    int             m_redMax;
    int             m_redNum;
    int             m_redMin;
    NSMutableArray *m_randomData;
    NSIndexPath    *m_indexPath;
    
    BOOL           isLuckView;//是否是幸运选号产生的（球小，没有删除按钮）
    
    BOOL           isSort;//是否对号码排序
}

@property (nonatomic, retain) NSIndexPath* indexPath;
@property (nonatomic, retain) NSMutableArray* randomData;
@property (nonatomic, assign) BOOL isLuckView;

- (void)createRandomData;
- (void)createDataWithStartNum:(int)startNum inRedMax:(int)redMax num:(int)redNum isSort:(BOOL)_isSort;
- (void)setRedNum:(int)redNum inRedMax:(int)redMax dxds:(BOOL)dxds;
- (void)setSort:(BOOL)sort;
@end
