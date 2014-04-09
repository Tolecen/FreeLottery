//
//  FuWuSetViewController.h
//  RuYiCai
//
//  Created by  on 12-6-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FuWuSetViewController :  UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    UITableView*     m_myTableView;
    
    NSMutableArray*  m_stateSwitchArr;//总共9个，1表示开，0表示关,前三个是记录head的开关
    NSMutableArray*  m_idSwitchArr;//每个开关的id，跟state存储顺序一样
    
    NSMutableArray*  m_startStateArr;//服务器返回的数据，跟这次保存时相比，改动才上传
}
@property (nonatomic, retain)NSMutableArray* stateSwitchArr;
@property (nonatomic, retain)NSMutableArray* idSwitchArr;
@property (nonatomic, retain)UITableView*    myTableView;

- (void)pressSwitch:(id)sender;
- (void)okClick;
- (void)queryMessageSettingOK:(NSNotification*)notification;
- (void)messageSettingOK:(NSNotification*)notification;

@end
