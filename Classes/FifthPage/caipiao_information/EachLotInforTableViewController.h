//
//  EachLotInforTableViewController.h
//  RuYiCai
//
//  Created by  on 12-9-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "RespForWeChatViewController.h"

@interface EachLotInforTableViewController : UITableViewController <RespForWeChatViewDelegate,WXApiDelegate>
{
    NSMutableArray           *m_typeIdArray;
    enum WXScene _scene;
}
@property (nonatomic, retain) NSString*  lotNo;
@property (nonatomic, retain) NSMutableArray     *typeIdArray;

- (void)getInformationOK:(NSNotification *)notification;
- (void)getInformationContentOK:(NSNotification *)notification;

@end
