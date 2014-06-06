//
//  ASettingViewController.h
//  Boyacai
//
//  Created by Tolecen on 14-3-10.
//
//

#import <UIKit/UIKit.h>
#import "AdaptationUtils.h"
#import "UINavigationBarCustomBg.h"
#import "BackBarButtonItemUtils.h"
#import "NewVersionIntroduction.h"
#import "RuYiCaiNetworkManager.h"
#import "ADIntroduceViewController.h"
#import "NewFuctionIntroductionView.h"
#import "FeedBackViewController.h"
#import "ChangePassViewController.h"
@interface ASettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSArray * titleArrayOne;
    NSArray * titleArrayTwo;
    NSArray * titleArrayThree;
}
@property(nonatomic, retain)UITableView * listTableV;
@end
