//
//  CaipiaoInformationViewController.h
//  RuYiCai
//
//  Created by LiTengjie on 11-9-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RuYiCaiAppDelegate.h"
#import "CustomSegmentedControl.h"
#import "WXApi.h"
#import "RespForWeChatViewController.h"

@interface CaipiaoInformationViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,CustomSegmentedControlDelegate,WXApiDelegate,RespForWeChatViewDelegate> {
    UISegmentedControl *m_segmented;
    CustomSegmentedControl *_cusSegmented;
    UILabel            *m_loginStatus; //登录状态
    UIBarButtonItem    *m_button_Login;//登录
    RuYiCaiAppDelegate *m_delegate;
    
    UITableView       *m_tableView;
       
    NSMutableDictionary           *m_typeIdDicArray;
    enum WXScene _scene;
    
}

@property (nonatomic, retain) UISegmentedControl* segmented;
@property (nonatomic, retain) CustomSegmentedControl *cusSegmented;
@property (nonatomic, retain) UITableView        *tableView;
@property (nonatomic, retain) NSMutableDictionary     *typeIdDicArray;

@end
