//
//  ActivitiesViewController.h
//  Boyacai
//
//  Created by Tolecen on 14-3-27.
//
//

#import <UIKit/UIKit.h>
#import "AdaptationUtils.h"
#import "UINavigationBarCustomBg.h"
#import "BackBarButtonItemUtils.h"
#import "ActivityTypeOneCell.h"
#import "ActivityTypeTwoCell.h"
#import "RuYiCaiCommon.h"
#import "ActivityView.h"
@class RuYiCaiAppDelegate;
@interface ActivitiesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    RuYiCaiAppDelegate  *m_delegate;
    NSMutableArray * typeArray;
    
    NSMutableArray * actsArray;
//    NSString * timeStr;
}
@property(nonatomic, retain)UITableView * listTableV;
@property(nonatomic, retain)NSString * timeStr;
@end
