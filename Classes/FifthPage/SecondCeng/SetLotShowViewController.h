//
//  SetLotShowViewController.h
//  RuYiCai
//
//  Created by  on 12-9-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetLotShowViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    UITableView*     m_myTableView;
    
    NSMutableArray*  m_lotArray;//彩种名字记录数组
    NSMutableArray*  m_stateSwitchArr;//总共15个，1表示开，0表示关
    
    NSMutableArray*  m_showLotArray;//显示的彩种数组
    NSInteger             m_openLotNum;
}

@property (nonatomic, retain) NSMutableArray*  lotArray;
@property (nonatomic, retain) NSMutableArray* stateSwitchArr;
@property (nonatomic, retain) NSMutableArray* showLotArray;

- (void)setRecordArray;

@end
