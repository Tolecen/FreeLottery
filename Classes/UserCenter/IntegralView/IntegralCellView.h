//
//  IntegralCellView.h
//  RuYiCai
//
//  Created by  on 12-3-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntegralCellView : UITableViewCell
{
    UILabel       *titleLabel;
    UILabel       *scoreLabel;
    UILabel       *timeLabel;
    
    NSString      *m_title;
    NSString      *m_score;
    NSString      *m_time;
    NSString      *m_blsign;
}
@property (nonatomic, retain)NSString      *title;
@property (nonatomic, retain)NSString      *score;
@property (nonatomic, retain)NSString      *time;
@property (nonatomic, retain)NSString      *blsign;

- (void)refreshView;

@end
