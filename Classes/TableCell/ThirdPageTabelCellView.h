//
//  ThirdPageTabelCellView.h
//  RuYiCai
//
//  Created by  on 12-4-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import <QuartzCore/QuartzCore.h>
@interface ThirdPageTabelCellView : UITableViewCell {
    EGOImageView*  m_icoImageView;
    UILabel*      m_titleLabel;
    UILabel*      m_littleTitleLabel;
    UILabel*      m_oneLabel;
    
    NSString*     m_iconImageName;
    NSString*     m_titleName;
    NSString*     m_littleTitleName;
}
@property (nonatomic, retain) UILabel * titleLabel;
@property (nonatomic, retain) UILabel * littleTitleLabel;
@property (nonatomic, retain) NSString* iconImageName;
@property (nonatomic, retain) NSString* titleName;
@property (nonatomic, retain) NSString* littleTitleName;

- (void)refresh;

@end
