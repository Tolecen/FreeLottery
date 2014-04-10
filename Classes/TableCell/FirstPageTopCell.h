//
//  FirstPageTopCell.h
//  Boyacai
//
//  Created by Tolecen on 14-3-13.
//
//

#import <UIKit/UIKit.h>
#import "ColorUtils.h"
#import "RuYiCaiNetworkManager.h"
@interface FirstPageTopCell : UITableViewCell
@property (nonatomic,retain) UILabel * caidouYuELabel;
@property (nonatomic,retain) UILabel * tishiLabel;
@property (nonatomic,retain) UILabel * moreTimesLabel;
-(void)updateLogInStatus;
-(void)setRemainingBuyTimes:(int)theTime;
@end
