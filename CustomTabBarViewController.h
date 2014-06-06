//
//  CustomTabBarViewController.h
//  Boyacai
//
//  Created by viviya on 13-9-28.
//
//

#import <UIKit/UIKit.h>
#import "FirstPageViewController.h"
#import "HMDTGroupByViewController.h"
#import "DrawLotteryPageViewController.h"
#import "FourthPageViewController.h"
#import "FifthPageViewController.h"
#import "ExchangeLotteryViewController.h"
#import "ActivitiesViewController.h"
@interface CustomTabBarViewController : UIViewController
{
    NSArray * btnArray;
}

@property (retain, nonatomic) UINavigationController *firstNavController;
@property (retain, nonatomic) UINavigationController *secondNavController;
@property (retain, nonatomic) UINavigationController *thirdNavController;
@property (retain, nonatomic) UINavigationController *fourthNavController;
@property (retain, nonatomic) UINavigationController *fifthNavController;

@property (retain, nonatomic) IBOutlet UIView  *customTabView;
@property (retain, nonatomic) IBOutlet UIButton *homeButton;
@property (retain, nonatomic) IBOutlet UIButton *secondButton;
@property (retain, nonatomic) IBOutlet UIButton *thirdButton;
@property (retain, nonatomic) IBOutlet UIButton *forthbutton;
@property (retain, nonatomic) IBOutlet UIButton *fifthButton;


-(id)initViewController;

- (IBAction)customTabTapped:(id)sender;
- (void)selectTabTapped;
- (void)customTabSelected:(int)currentTag;

@end
