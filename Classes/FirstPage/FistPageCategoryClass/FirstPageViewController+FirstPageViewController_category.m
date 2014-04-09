//
//  FirstPageViewController+FirstPageViewController_category.m
//  RuYiCai
//
//  Created by  on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FirstPageViewController.h"
#import "LuckViewController.h"
#import "Custom_tabbar.h"
#import "NSLog.h"

@implementation FirstPageViewController (FirstPageViewController_category)

- (void)pushLUCkView
{
//    [MobClick event:@"main_luck_button"];
    
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    
	[self setHidesBottomBarWhenPushed:YES];
	LuckViewController *pickNumberView = [[LuckViewController alloc]init];
	pickNumberView.navigationItem.title = @"幸运选号";
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
	[self.navigationController pushViewController:pickNumberView animated:YES];
    [pickNumberView release];
}

@end
