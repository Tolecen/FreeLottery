//
//  UserCenterAutoOrderDetailView.h
//  RuYiCai
//
//  Created by ruyicai on 12-11-19.
//
//

#import <UIKit/UIKit.h>

@interface UserCenterAutoOrderDetailView : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    UITableView           *m_myTableView;
    NSMutableArray        *m_contentArray;
    
    NSDictionary*          m_zhanjiDic;
}

@property(nonatomic, retain) NSMutableArray        *contentArray;
@property(nonatomic, retain) UITableView           *myTableView;
@property(nonatomic, retain) NSDictionary          *zhanjiDic;
- (void)setUpTopView;

@end
