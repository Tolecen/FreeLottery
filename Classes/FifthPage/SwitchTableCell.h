//
//  SwitchTableCell.h
//  RuYiCai
//
//  Created by ruyicai on 12-6-1.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RuYiCaiAppDelegate;
@interface SwitchTableCell : UITableViewCell {
    UILabel                                 *m_titleLable;
    UISwitch                                *m_switchButton;
    
    NSString                                *m_lableString;
    BOOL                                    m_isYes;
    
    RuYiCaiAppDelegate*                     m_delegate;
    UIImageView                             *accessoryImageView;
}
@property (nonatomic, retain) UIImageView          *accessoryImageView;
@property (nonatomic, retain) NSString             *lableString;
@property (nonatomic, assign) BOOL isYes;

- (void) refreshData;
@end
