//
//  AwardCardViewController.h
//  Boyacai
//
//  Created by Tolecen on 14-5-14.
//
//

#import <UIKit/UIKit.h>
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"
#import "RuYiCaiNetworkManager.h"
#import "ActivityTypeOneCell.h"
#import "AwardCardDetailViewController.h"
@interface AwardCardViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property (nonatomic,retain)UITableView * tableV;
@property (nonatomic,retain)NSArray * dataArray;
@end
