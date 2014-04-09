//
//  OtherActivityViewController.h
//  Boyacai
//
//  Created by Tolecen on 14-3-10.
//
//

#import <UIKit/UIKit.h>
#import "AdaptationUtils.h"
#import "UINavigationBarCustomBg.h"
#import "BackBarButtonItemUtils.h"
#import "ThirdPageTabelCellView.h"
@interface OtherActivityViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray * otherActivityArray;
    NSArray * notCompleteArray;
    NSArray * completeArray;
    NSArray * ifCompleteArray;
}
@property(nonatomic, retain)UITableView * listTableV;
@end
