//
//  LotteryTypeEditorViewController.h
//  Boyacai
//
//  Created by 纳木 那咔 on 13-3-21.
//
//

#import <UIKit/UIKit.h>


@interface LotteryTypeEditorViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    UITableView     *_tableView;
    NSMutableArray  *_stateSwitchArr;//总共15个，1表示开，0表示关
    
    NSMutableArray  *_showLotArray;//显示的彩种数组
    
    NSMutableArray *_showArray;
    NSMutableArray *_hidenArray;
    NSInteger       countStr;
}

@property (nonatomic, retain) NSMutableArray* stateSwitchArr;
@property (nonatomic, retain) NSMutableArray* showLotArray;

@property (nonatomic, retain) NSMutableArray* showArray;
@property (nonatomic, retain) NSMutableArray* hidenArray;



@end
