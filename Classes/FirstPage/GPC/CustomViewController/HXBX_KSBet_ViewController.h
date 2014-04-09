//
//  HXBX_KSBet_ViewController.h
//  Boyacai
//
//  Created by fengyuting on 13-10-28.
//
//

#import <UIKit/UIKit.h>
#import "KS_PickNumberMainViewController.h"


@interface HXBX_KSBet_ViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    
    UIView *bottomViewContainer;
    
    UIButton * backgroundButton;
}

@property (nonatomic,retain) UILabel * betLabel;

@property (nonatomic,retain) UILabel * moneyLabel;

@property (nonatomic,retain) UITextField * periodsTextField;

@property (nonatomic,retain) UITextField * multipleTextField;

@property (nonatomic,retain) UITableView * tableView;

@property (nonatomic,retain) NSArray * dataSource;

@property (nonatomic,assign) KS_PickNumberMainViewController * delegate;
@property (nonatomic,retain) NSString * amountString;
-(void)reloadTableViewData;
@end
