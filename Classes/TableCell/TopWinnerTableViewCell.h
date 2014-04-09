//
//  TopWinnerTableViewCell.h
//  RuYiCai
//
//  Created by  on 12-1-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopWinnerTableViewCell : UITableViewCell
{
    UIImageView   *numImage;
    int           num;
    NSString      *winName;
    NSString      *winNum;
    
    UILabel       *numLabel;
    UILabel       *winNameLabel;
    UILabel       *winNumLabel;
    UIImageView *_backGroundImageView;
}

@property (nonatomic, retain)UIImageView   *numImage;
@property (nonatomic, retain)NSString      *winName;
@property (nonatomic, assign)int           num;
@property (nonatomic, retain)NSString      *winNum;
@property (nonatomic, retain)UILabel       *numLabel;
@property (nonatomic, retain)UILabel       *winNameLabel;
@property (nonatomic, retain)UILabel       *winNumLabel;
@property (nonatomic, retain) UIImageView *backGroundImageView;

- (void)refresh;

@end
