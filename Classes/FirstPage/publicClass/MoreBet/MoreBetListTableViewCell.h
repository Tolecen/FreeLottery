//
//  MoreBetListTableViewCell.h
//  RuYiCai
//
//  Created by  on 12-7-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreBetListTableViewCell : UITableViewCell
{
    UILabel*  redLabel;
    UILabel*  blackLabel;
    UILabel*  blueLabel;
    
    UILabel*  inforLabel;
    
    NSString* betCodeStr;
    NSString* blueStr;
    NSString* inforStr;
}

@property(nonatomic, retain) NSString* betCodeStr;
@property(nonatomic, retain) NSString* inforStr;

- (void)refreshCell;

@end
