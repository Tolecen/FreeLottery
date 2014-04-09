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
@class RuYiCaiAppDelegate;
@interface ActivitiesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    RuYiCaiAppDelegate  *m_delegate;
    NSMutableArray * typeArray;
}
@property(nonatomic, retain)UITableView * listTableV;
@end
