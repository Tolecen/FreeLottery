//
//  HelpViewTitleViewController.h
//  RuYiCai
//
//  Created by  on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _HelpType{
    TypeOfGongNengZhiYin = 1,
    TypeOfCaiPiaoWanFa = 3,
    TypeOfChangJianWenTi = 4,
    TypeOfCaiPiaoShuYu = 5
} HelpType;

@interface HelpViewTitleViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    UITableView*    m_myTableView;
    NSMutableArray  *m_titleArr;
    
    HelpType       m_helpType;
    UINavigationController *_navigationController;
}

@property (nonatomic, retain)UITableView*    myTableView;
@property (nonatomic, retain)NSMutableArray  *titleArr;
@property (nonatomic, assign)HelpType       helpType;
@property (nonatomic, retain)UINavigationController *navigationController;

- (id)initWithHelpType:(HelpType) type;
- (void)queryHelpTitleOK:(NSNotification*)notification;

@end
