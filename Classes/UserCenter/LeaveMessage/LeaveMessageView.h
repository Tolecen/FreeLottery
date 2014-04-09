//
//  LeaveMessageView.h
//  RuYiCai
//
//  Created by  on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaveMessageView : UITableViewCell
{
    UILabel      *timeLabel;
    UILabel      *contentLabel;
    
    NSString     *creatTime;
    NSString     *content;
}

@property(nonatomic, retain) NSString     *creatTime;
@property(nonatomic, retain) NSString     *content;

- (void)refreshView;

@end
