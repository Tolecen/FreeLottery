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
#import "ThirdPageTabelCellView.h"
#import "AwardCardDetailViewController.h"
@interface AwardCardViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    int curPageIndex;
    int totalPageCount;
}
@property (nonatomic,retain)UITableView * tableV;
@property (nonatomic,retain)NSArray * dataArray;
@end
