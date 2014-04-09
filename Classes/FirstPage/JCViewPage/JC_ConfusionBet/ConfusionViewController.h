//
//  ConfusionViewController.h
//  RuYiCai
//
//  Created by ruyicai on 13-3-4.
//
//

#import <UIKit/UIKit.h>

#import "JCLQ_PickGameViewController.h"
#import "JCZQ_PickGameViewController.h"
@interface ConfusionViewController : UIViewController<UIScrollViewDelegate>  {
    BOOL                        m_isJCLQView;
    NSInteger                   m_playTypeTag;
    UIScrollView               *m_scollView;
    UIBarButtonItem            *m_rightTitleBarItem;
    
    
    NSMutableArray             *m_selectScore;
    
    JCLQ_PickGameViewController *m_JCLQ_parentController;
    JCZQ_PickGameViewController *m_JCZQ_parentController;
    NSString                    *m_team;
    NSIndexPath                 *m_indexPath;
    NSMutableArray              *m_buttonText;
}
@property (nonatomic, assign) int playTypeTag;
@property (nonatomic, assign) BOOL isJCLQView;
@property (nonatomic, retain) UIScrollView *scollView;

//篮球 跟足球共用数据
@property (nonatomic, retain) NSMutableArray *selectScore;
@property (nonatomic, retain) NSMutableArray *buttonText;

@property (nonatomic, retain) NSString *team;
@property (nonatomic, retain) NSIndexPath *indexPath;

@property(nonatomic, retain) JCLQ_PickGameViewController* JCLQ_parentController;
@property(nonatomic, retain) JCZQ_PickGameViewController* JCZQ_parentController;
-(void) appendButtonText:(NSArray*)buttonText;

-(void) appendSelectScoreText:(NSMutableArray *)scoreText;

@end