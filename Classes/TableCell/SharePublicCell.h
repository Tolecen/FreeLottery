//
//  UserCenterTableViewCell.h
//  RuYiCai
//
//  Created by  on 12-2-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SharePublicCell : UITableViewCell
{
    UIImageView   *imageView;
    UIButton      *imageViewRight;
    NSString      *title;
    UILabel       *titleLabel;
    UIImageView   *cellimageView;
}

@property (nonatomic, retain)  UIImageView *cellimageView;
@property (nonatomic, retain) UIImageView *imageView;

@property (nonatomic, retain) UIButton    *imageViewRight;
@property (nonatomic, retain) NSString    *imageName;
@property (nonatomic, retain) NSString    *title;
@property (nonatomic, retain) UILabel     *titleLabel;
@property (nonatomic, assign) BOOL        isHaveImageRight;
- (void)refresh;

@end
