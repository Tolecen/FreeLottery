//
//  RankingViewController.h
//  Boyacai
//
//  Created by qiushi on 13-3-18.
//
//

#import <UIKit/UIKit.h>
//#import "CustomSegmentedControl.h"
#import "SchiebenViewUitils.h"
#import "RuYiCaiAppDelegate.h"


@interface RankingViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,SchiebenViewUitilsDelegate>

{
    NSArray                         *m_topWinArray;
    SchiebenViewUitils              *m_schiebenView;
    UITableView                     *m_winTableView;
    int                             topWay;
    UIScrollView                    *m_rankingScorollView;
    UILabel                         *m_refreshLabel;
    BOOL                            isRefresWinner;
    BOOL                            isLoading;
    BOOL                            isDragging;
    UIImageView                     *m_refreshImagView;
    UIView                          *m_refreshHeaderView;
    UIActivityIndicatorView         *m_refreshSpinner;
    UILabel                         *m_refreshDate;
    RuYiCaiAppDelegate              *m_delegate;
}
@property (nonatomic, retain) UILabel                         *refreshDate;
@property (nonatomic, retain) UIActivityIndicatorView         *refreshSpinner;
@property (nonatomic, retain) UIView                          *refreshHeaderView;
@property (nonatomic, retain) UIImageView                     *refreshImagView;
@property (nonatomic, retain) UILabel                         *refreshLabel;
@property (nonatomic, retain) UIScrollView                    *rankingScorollView;
@property (nonatomic, retain) SchiebenViewUitils          *schiebenView;
@property (nonatomic, retain) NSArray                         *topWinArray;
@property (nonatomic, retain) UITableView                     *winTableView;

- (void)topWinnerOK:(NSNotification*)notification;
- (void)addPullToRefreshHeader;

@end
