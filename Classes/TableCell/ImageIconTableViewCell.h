//
//  ImageIconTableViewCell.h
//  RuYiCai
//
//  Created by LiTengjie on 11-9-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageIconTableViewCell : UITableViewCell {
    UIImageView*  m_icoImageView;
    UILabel*      m_titleLabel;
    NSString*     m_iconImageName;
    NSString*     m_titleName;
}

@property (nonatomic, retain) NSString* iconImageName;
@property (nonatomic, retain) NSString* titleName;

- (void)refresh;

@end