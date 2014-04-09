    //
//  Custom_tabbar.m
//  RuYiCai
//
//  Created by haojie on 11-11-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Custom_tabbar.h"
#import "RuYiCaiNetworkManager.h"
#import "AdaptationUtils.h"
@interface Custom_tabbar (internal)
- (void)joinCustomBar_usercenter:(NSNotification*)notification;
@end


@implementation Custom_tabbar
@synthesize tabBarView;

static Custom_tabbar *s_tabbar = NULL;

- (void)init_tab
{
	backgroud_image = [[NSArray alloc]initWithObjects:
                       @"menu_gcdt.png",
                       @"menu_hmdt.png",
                       @"menu_kjzx.png",
                       @"menu_yhzx.png",
                       @"menu_gd.png",nil];
	select_image = [[NSArray alloc]initWithObjects:
                    @"menu_gcdt_hov.png",
                    @"menu_hmdt_hov.png",
                    @"menu_kjzx_hov.png",
                    @"menu_yhzx_hov.png",
                    @"menu_gd_hov.png",nil];
    //kaijiang_normal.png
    //kaijiang_click.png
    //chongzhi_normal.png
    //chongzhi_click.png
	tab_bar_bg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"diBuBeiJing.png"]];
    
    float startY = [[UIScreen mainScreen] bounds].size.height;
    tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, startY - 50, 320, 50)];
    
    //记得移除 消息---用于tabbar 跳转到 用户中心 之前的判断是否登陆 
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(joinCustomBar_usercenter:) name:@"joinCustomBar_usercenter" object:nil];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//	[super viewWillAppear:animated];
//	[self init_tab];
//	[self when_tabbar_is_unselected];
//	[self add_custom_tabbar_elements];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [self init_tab];
	[self when_tabbar_is_unselected];
	[self add_custom_tabbar_elements];
}

- (void)when_tabbar_is_unselected
{
	for(UIView *view in self.view.subviews)
	{
		if([view isKindOfClass:[UITabBar class]])
		{
			view.hidden = YES;
			break;
		}
	}
}

- (void)add_custom_tabbar_elements
{
	int tab_num = 5;
	
    float startY = [[UIScreen mainScreen] bounds].size.height;
	UIImageView *tabbar_bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, startY - 50, 320, 50)];
    [tabbar_bg setImage:tab_bar_bg.image];
	[tabBarView addSubview:tabbar_bg];
	[self.view addSubview:tabBarView];
	
	tab_btn = [[NSMutableArray alloc] initWithCapacity:0];
	for(int i = 0; i< tab_num; i++)
	{
		btn = [UIButton buttonWithType:UIButtonTypeCustom];
		[btn setFrame:CGRectMake(i*64, 0, 64, 50)];
		NSString *back_image = [backgroud_image objectAtIndex:i];
		NSString *selected_image = [select_image objectAtIndex:i]; 
		[btn setBackgroundImage:[UIImage imageNamed:back_image] forState:UIControlStateNormal];
		[btn setBackgroundImage:[UIImage imageNamed:selected_image] forState:UIControlStateSelected];
		btn.backgroundColor = [UIColor clearColor];
		[btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
		if(i == 0)
		{
			[btn setSelected:YES];
		}
		[btn setTag:i];
		[tab_btn addObject:btn];
		[tabBarView addSubview:btn];
		[btn addTarget:self action:@selector(button_clicked_tag:) forControlEvents:UIControlEventTouchUpInside];
		//[btn release];
	}
}

- (void)button_clicked_tag:(id)sender
{
	int tagNum = [sender tag];
	[self when_tabbar_is_selected:tagNum];
}

- (void)when_tabbar_is_selected:(int)tabID
{
	switch (tabID)
	{
		case 0:
			[[tab_btn objectAtIndex:0]setSelected:true];
			[[tab_btn objectAtIndex:1]setSelected:false];
			[[tab_btn objectAtIndex:2]setSelected:false];
			[[tab_btn objectAtIndex:3]setSelected:false];
            [[tab_btn objectAtIndex:4]setSelected:false];
//            [RuYiCaiNetworkManager sharedManager].isHideTabbar = YES;
//            [MobClick event:@"tabBar_gouCai"];
			break;
		case 1:
			[[tab_btn objectAtIndex:0]setSelected:false];
			[[tab_btn objectAtIndex:1]setSelected:true];
			[[tab_btn objectAtIndex:2]setSelected:false];
			[[tab_btn objectAtIndex:3]setSelected:false];
            [[tab_btn objectAtIndex:4]setSelected:false];
//            [RuYiCaiNetworkManager sharedManager].isHideTabbar = YES;
//            [MobClick event:@"tabBar_kaiJiang"];

			break;
		case 2:
			[[tab_btn objectAtIndex:0]setSelected:false];
			[[tab_btn objectAtIndex:1]setSelected:false];
			[[tab_btn objectAtIndex:2]setSelected:true];
			[[tab_btn objectAtIndex:3]setSelected:false];
            [[tab_btn objectAtIndex:4]setSelected:false];
//            [RuYiCaiNetworkManager sharedManager].isHideTabbar = NO;
//            [MobClick event:@"tabBar_chongZhi"];

			break;
            
        case 3:
        {
//            if ([RuYiCaiNetworkManager sharedManager].hasLogin) 
//            {
                [[tab_btn objectAtIndex:0]setSelected:false];
                [[tab_btn objectAtIndex:1]setSelected:false];
                [[tab_btn objectAtIndex:2]setSelected:false];
                [[tab_btn objectAtIndex:3]setSelected:true];
                [[tab_btn objectAtIndex:4]setSelected:false];
//                [RuYiCaiNetworkManager sharedManager].isHideTabbar = YES;   
//            }
//            else
//            {
//                [RuYiCaiNetworkManager sharedManager].netAppType =NET_APP_JOIN_CUSTOMBAR_USER_CENTER;
//                [[RuYiCaiNetworkManager sharedManager] showLoginAlertView];
//                return;
//            }
//            [MobClick event:@"tabBar_userCenter"];

			break;
        }
        case 4:
            [[tab_btn objectAtIndex:0]setSelected:false];
			[[tab_btn objectAtIndex:1]setSelected:false];
			[[tab_btn objectAtIndex:2]setSelected:false];
			[[tab_btn objectAtIndex:3]setSelected:false];
            [[tab_btn objectAtIndex:4]setSelected:true];
//            [RuYiCaiNetworkManager sharedManager].isHideTabbar = YES;
//            [MobClick event:@"tabBar_morePage"];

			break;
            
		default:
			break;
	}
	self.selectedIndex = tabID;
}

- (void)hideTabBar:(BOOL) hidden
{	
	if(hidden)
	{
		self.tabBarView.hidden = YES;
	}
	else
	{
		self.tabBarView.hidden = NO;
	}
}

+ (Custom_tabbar*)showTabBar
{
    @synchronized(self) 
    {
		if (s_tabbar == nil) 
		{
			//s_tabbar = [[self alloc] init];  //assignment not done here
		}
	}
	return s_tabbar;
}

+ (id)allocWithZone:(NSZone *)zone 
{
	@synchronized(self) 
	{
		if (s_tabbar == nil) 
		{
			s_tabbar = [super allocWithZone:zone];
			return s_tabbar;  //assignment and return on first allocation
		}
	}	
	return nil;  //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone 
{
	return self;
}

- (id)retain 
{
	return self;
}

- (unsigned)retainCount 
{
	return UINT_MAX;  //denotes an object that cannot be released
}

- (oneway void)release 
{
	//do nothing
}

- (id)autorelease 
{
	return self;
}

- (void)dealloc 
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"joinCustomBar_usercenter" object:nil];
	[backgroud_image release];
	[select_image release];
	[tab_bar_bg release];
	[tab_btn release];
	[tabBarView release];
    [super dealloc];
}

//- (void)joinCustomBar_usercenter:(NSNotification*)notification
//{
//    [[tab_btn objectAtIndex:0]setSelected:false];
//    [[tab_btn objectAtIndex:1]setSelected:false];
//    [[tab_btn objectAtIndex:2]setSelected:false];
//    [[tab_btn objectAtIndex:3]setSelected:true];
//    [[tab_btn objectAtIndex:4]setSelected:false];
//    [RuYiCaiNetworkManager sharedManager].isHideTabbar = YES;  
//    self.selectedIndex = 3;
//}

@end
