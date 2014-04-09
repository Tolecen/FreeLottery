//
//  SFCViewController.h
//  RuYiCai
//
//  Created by ruyicai on 12-5-17.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
 
#import "JCLQ_PickGameViewController.h"
#import "JCZQ_PickGameViewController.h"
#import "BJDC_pickNumViewController.h"

@interface SFCViewController : UIViewController<UIScrollViewDelegate>  {
    int                        m_isJCLQView;//1为篮球  2为北京单场  0为竞彩足球
    NSInteger                   m_playTypeTag;
    UIScrollView               *m_scollView;
    UIBarButtonItem            *m_rightTitleBarItem;
    
    
    NSMutableArray             *m_selectScore;

    JCLQ_PickGameViewController *m_JCLQ_parentController;
    JCZQ_PickGameViewController *m_JCZQ_parentController;
    BJDC_pickNumViewController* m_BJDC_parentController;
    
    NSString                    *m_team;
    NSIndexPath                 *m_indexPath;
    NSMutableArray              *m_buttonText;
}
@property (nonatomic, assign) int playTypeTag; 
@property (nonatomic, assign) int isJCLQView;
@property (nonatomic, retain) UIScrollView *scollView;
@property (nonatomic, retain) NSMutableArray *selectScore;

@property (nonatomic, retain) NSMutableArray *buttonText;

@property (nonatomic, retain) NSString *team;
@property (nonatomic, retain) NSIndexPath *indexPath;

@property(nonatomic, retain) JCLQ_PickGameViewController* JCLQ_parentController;
@property(nonatomic, retain) JCZQ_PickGameViewController* JCZQ_parentController;
@property(nonatomic, retain) BJDC_pickNumViewController*  BJDC_parentController;

-(void) appendButtonText:(NSString*)buttonText;

-(void) appendSelectScoreText:(NSString *)scoreText;

@end
