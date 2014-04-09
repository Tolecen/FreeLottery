//
//  LotteryBetWarnViewController.m
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 12-11-29.
//
//

#import "LotteryBetWarnViewController.h"
#import "RuYiCaiCommon.h"
#import "CommonRecordStatus.h"
#import "NSLog.h"
#import "BackBarButtonItemUtils.h"
#import "ColorUtils.h"
#import "BuyRemindCell.h"
#import "AdaptationUtils.h"

#define SwitchStartTag  342

@interface LotteryBetWarnViewController ()

- (void)pressSwitch:(id)sender;
- (void)setLocalNotification;
- (void)setLocalNotification;

@end

@implementation LotteryBetWarnViewController

@synthesize myTableView = m_myTableView;
@synthesize recodeSwitchDic = m_recodeSwitchDic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    m_selectDateView.delegate = nil;//防止“魔鬼访问”，一定要在页面销毁前把delegate置空
    [m_selectDateView release];
    [m_myTableView release], m_myTableView = nil;
    [m_recodeSwitchDic release], m_recodeSwitchDic = nil;
    
    [super dealloc];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] setObject:self.recodeSwitchDic forKey:kLotteryBetWarnKey];
    [[NSUserDefaults standardUserDefaults] synchronize];//同步
    
    [self setLocalNotification];//刷新一次
    
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self];
    
    self.view.backgroundColor = [ColorUtils parseColorFromRGB:@"#efede9"];

    NSMutableDictionary* mutableDic = [[NSUserDefaults standardUserDefaults] objectForKey:kLotteryBetWarnKey];
    NSLog(@"dfaf %@", [[NSUserDefaults standardUserDefaults] objectForKey:kLotteryBetWarnKey]);
    if(!mutableDic)
    {
        [[CommonRecordStatus commonRecordStatusManager] setLottoryBetWarnDic];
        NSMutableDictionary* newMutableDic = [[NSUserDefaults standardUserDefaults] objectForKey:kLotteryBetWarnKey];
        m_recodeSwitchDic = [[NSMutableDictionary alloc] initWithDictionary:newMutableDic];
    }
    else
        m_recodeSwitchDic = [[NSMutableDictionary alloc] initWithDictionary:mutableDic];
    
    m_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
    m_myTableView.delegate = self;
    m_myTableView.dataSource = self;
    m_myTableView.backgroundColor = [UIColor clearColor];
    m_myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:m_myTableView];
    
    m_selectDateView = [[DatePickView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 320, [UIScreen mainScreen].bounds.size.height)];
    m_selectDateView.delegate = self;
    [self.view addSubview:m_selectDateView];
}


#pragma mark dateSelect
- (void)cancelPickView:(DatePickView*)randomPickerView
{
}

- (void)randomPickerView:(DatePickView*)randomPickerView selectDate:(NSDate*)selectDate
{
    //2012-11-30 07:01:00 +0000
//    NSLog(@"ssss %@", selectDate);
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [comps setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
	NSInteger unitFlags = NSEraCalendarUnit |
	NSYearCalendarUnit |
	NSMonthCalendarUnit |
	NSDayCalendarUnit |
	NSHourCalendarUnit |
	NSMinuteCalendarUnit |
	NSSecondCalendarUnit |
	NSWeekCalendarUnit |
	NSWeekdayCalendarUnit |
	NSWeekdayOrdinalCalendarUnit |
	NSQuarterCalendarUnit;

	comps = [calendar components:unitFlags fromDate:selectDate];
	int hour = [comps hour];
	int min = [comps minute];

    NSString *tempTimeStr = [NSString stringWithFormat:@"%02d:%02d", hour, min];
//    self.timeStr = tempTimeStr;
    NSLog(@"time :%@", tempTimeStr);
    [self.recodeSwitchDic setObject:tempTimeStr forKey:kLotteryBetWarnTimeKey];
    
    [self.myTableView reloadData];

    [pool release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark 保存设置，制定本地消息

- (void)cancelLocalNotification
{
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for(UILocalNotification *notification in localNotifications)
    {
        NSLog(@"old localNotification:%@", [notification fireDate]);
        
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
    }
}

- (void)setLocalNotificationWithWeek:(NSString*)localWeek withContent:(NSString*)content
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSMutableDictionary* mutableDic = [[NSUserDefaults standardUserDefaults] objectForKey:kLotteryBetWarnKey];
    if(!mutableDic)
    {
        return;
    }
    NSArray *clockTimeArray = [[mutableDic objectForKey:kLotteryBetWarnTimeKey] componentsSeparatedByString:@":"];
	NSDate *dateNow = [NSDate date];
	NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
    //    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    //    [comps setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
	NSInteger unitFlags = NSEraCalendarUnit |
	NSYearCalendarUnit |
	NSMonthCalendarUnit |
	NSDayCalendarUnit |
	NSHourCalendarUnit |
	NSMinuteCalendarUnit |
	NSSecondCalendarUnit |
	NSWeekCalendarUnit |
	NSWeekdayCalendarUnit |
	NSWeekdayOrdinalCalendarUnit |
	NSQuarterCalendarUnit;
	
	comps = [calendar components:unitFlags fromDate:dateNow];
	[comps setHour:[[clockTimeArray objectAtIndex:0] intValue]];
	[comps setMinute:[[clockTimeArray objectAtIndex:1] intValue]];
	[comps setSecond:0];
	
	//------------------------------------------------------------------------
    //    NSString* clockMode = @"一、五";
	Byte weekday = [comps weekday];
	NSArray *array = [localWeek componentsSeparatedByString:@"、"];
	Byte i = 0;
	Byte j = 0;
	int days = 0;
	int	temp = 0;
	Byte count = [array count];
	Byte clockDays[7];
	
	NSArray *tempWeekdays = [NSArray arrayWithObjects:@"日", @"一", @"二", @"三", @"四", @"五", @"六", nil];
	//查找设定的周期模式
	for (i = 0; i < count; i++) {
		for (j = 0; j < 7; j++) {
			if ([[array objectAtIndex:i] isEqualToString:[tempWeekdays objectAtIndex:j]]) {
				clockDays[i] = j + 1;
				break;
			}
		}
	}
	
	for (i = 0; i < count; i++) {
	    temp = clockDays[i] - weekday;
		days = (temp >= 0 ? temp : temp + 7);
		NSDate *newFireDate = [[calendar dateFromComponents:comps] dateByAddingTimeInterval:3600 * 24 * days];
		
		UILocalNotification *newNotification = [[UILocalNotification alloc] init];
		if (newNotification) {
			newNotification.fireDate = newFireDate;
			newNotification.alertBody = content;//设置弹出对话框的消息内容
            if([[mutableDic objectForKey:kLotteryBetWarnSongKey] isEqualToString:@"1"])
                newNotification.soundName = UILocalNotificationDefaultSoundName;//设置声音
			newNotification.alertAction = @"确定";//设置弹出对话框的按钮
			newNotification.repeatInterval = NSWeekCalendarUnit;//周期为 每星期
            newNotification.applicationIconBadgeNumber = 1;//设置BadgeNumber
            
			NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"1" forKey:@"betLotteryWarnClock"];
			newNotification.userInfo = userInfo;
			[[UIApplication sharedApplication] scheduleLocalNotification:newNotification];//记录
		}
		NSLog(@"Post new localNotification:%@", [newNotification fireDate]);
		[newNotification release];
	}
    [pool release];
}

- (void)setLocalNotification//刷新本地消息
{
    NSMutableDictionary* tempDic = [[NSUserDefaults standardUserDefaults] objectForKey:kLotteryBetWarnKey];
    NSLog(@"hahaha %@", [[NSUserDefaults standardUserDefaults] objectForKey:kLotteryBetWarnKey]);
    if(!tempDic)
    {
        return;
    }
    [self cancelLocalNotification];//删除所有本地通知
    
    for(int i = 0; i < 7; i++)//从周日到。。周六
    {
        NSString* contentStr = @"今天是";
        NSString* weekStr;
        NSInteger  tempLotCount = 0;
        switch (i)
        {
            case 0://周日
            {
                weekStr = @"日";
                if([[tempDic objectForKey:kLotTitleSSQ] isEqualToString:@"1"])//打开
                {
                    if(tempLotCount != 0)
                        contentStr = [contentStr stringByAppendingString:@"、双色球"];
                    else
                        contentStr = [contentStr stringByAppendingString:@"双色球"];
                    tempLotCount ++;
                }
                if([[tempDic objectForKey:kLotTitleQXC] isEqualToString:@"1"])//打开
                {
                    if(tempLotCount != 0)
                        contentStr = [contentStr stringByAppendingString:@"、七星彩"];
                    else
                        contentStr = [contentStr stringByAppendingString:@"七星彩"];
                    tempLotCount ++;
                }
            }break;
            case 1:
            {
                weekStr = @"一";
                if([[tempDic objectForKey:kLotTitleDLT] isEqualToString:@"1"])//打开
                {
                    if(tempLotCount != 0)
                        contentStr = [contentStr stringByAppendingString:@"、大乐透"];
                    else
                        contentStr = [contentStr stringByAppendingString:@"大乐透"];
                    tempLotCount ++;
                }
                if([[tempDic objectForKey:kLotTitleQLC] isEqualToString:@"1"])//打开
                {
                    if(tempLotCount != 0)
                        contentStr = [contentStr stringByAppendingString:@"、七乐彩"];
                    else
                        contentStr = [contentStr stringByAppendingString:@"七乐彩"];
                    tempLotCount ++;
                }
            }break;
            case 2:
            {
                weekStr = @"二";
                if([[tempDic objectForKey:kLotTitleSSQ] isEqualToString:@"1"])//打开
                {
                    if(tempLotCount != 0)
                        contentStr = [contentStr stringByAppendingString:@"、双色球"];
                    else
                        contentStr = [contentStr stringByAppendingString:@"双色球"];
                    tempLotCount ++;
                }
                if([[tempDic objectForKey:kLotTitleQXC] isEqualToString:@"1"])//打开
                {
                    if(tempLotCount != 0)
                        contentStr = [contentStr stringByAppendingString:@"、七星彩"];
                    else
                        contentStr = [contentStr stringByAppendingString:@"七星彩"];
                    tempLotCount ++;
                }
            }break;
            case 3:
            {
                weekStr = @"三";
                if([[tempDic objectForKey:kLotTitleDLT] isEqualToString:@"1"])//打开
                {
                    if(tempLotCount != 0)
                        contentStr = [contentStr stringByAppendingString:@"、大乐透"];
                    else
                        contentStr = [contentStr stringByAppendingString:@"大乐透"];
                    tempLotCount ++;
                }
                if([[tempDic objectForKey:kLotTitleQLC] isEqualToString:@"1"])//打开
                {
                    if(tempLotCount != 0)
                        contentStr = [contentStr stringByAppendingString:@"、七乐彩"];
                    else
                        contentStr = [contentStr stringByAppendingString:@"七乐彩"];
                    tempLotCount ++;
                }
            }break;
            case 4:
            {
                weekStr = @"四";
                if([[tempDic objectForKey:kLotTitleSSQ] isEqualToString:@"1"])//打开
                {
                    if(tempLotCount != 0)
                        contentStr = [contentStr stringByAppendingString:@"、双色球"];
                    else
                        contentStr = [contentStr stringByAppendingString:@"双色球"];
                    tempLotCount ++;
                }
            }break;
            case 5:
            {
                weekStr = @"五";
                if([[tempDic objectForKey:kLotTitleQXC] isEqualToString:@"1"])//打开
                {
                    if(tempLotCount != 0)
                        contentStr = [contentStr stringByAppendingString:@"、七星彩"];
                    else
                        contentStr = [contentStr stringByAppendingString:@"七星彩"];
                    tempLotCount ++;
                }
                if([[tempDic objectForKey:kLotTitleQLC] isEqualToString:@"1"])//打开
                {
                    if(tempLotCount != 0)
                        contentStr = [contentStr stringByAppendingString:@"、七乐彩"];
                    else
                        contentStr = [contentStr stringByAppendingString:@"七乐彩"];
                    tempLotCount ++;
                }
            }break;
            case 6:
            {
                weekStr = @"六";
                if([[tempDic objectForKey:kLotTitleDLT] isEqualToString:@"1"])//打开
                {
                    if(tempLotCount != 0)
                        contentStr = [contentStr stringByAppendingString:@"、大乐透"];
                    else
                        contentStr = [contentStr stringByAppendingString:@"大乐透"];
                    tempLotCount ++;
                }
            }break;
            default:
                break;
        }
        if([[tempDic objectForKey:kLotTitleFC3D] isEqualToString:@"1"])//打开
        {
            if(tempLotCount != 0)
                contentStr = [contentStr stringByAppendingString:@"、福彩3D"];
            else
                contentStr = [contentStr stringByAppendingString:@"福彩3D"];
            tempLotCount ++;
        }
        if([[tempDic objectForKey:kLotTitlePLS] isEqualToString:@"1"])//打开
        {
            if(tempLotCount != 0)
                contentStr = [contentStr stringByAppendingString:@"、排列三"];
            else
                contentStr = [contentStr stringByAppendingString:@"排列三"];
            tempLotCount ++;
        }
        if([[tempDic objectForKey:kLotTitlePL5] isEqualToString:@"1"])//打开
        {
            if(tempLotCount != 0)
                contentStr = [contentStr stringByAppendingString:@"、排列五"];
            else
                contentStr = [contentStr stringByAppendingString:@"排列五"];
            tempLotCount ++;
        }
        if([[tempDic objectForKey:kLotTitle22_5] isEqualToString:@"1"])//打开
        {
            if(tempLotCount != 0)
                contentStr = [contentStr stringByAppendingString:@"、22选5"];
            else
                contentStr = [contentStr stringByAppendingString:@"22选5"];
            tempLotCount ++;
        }
        if(tempLotCount != 0)
        {
            contentStr = [contentStr stringByAppendingString:@" 的开奖日，不要错过购买时间喔！"];
            [self setLocalNotificationWithWeek:weekStr withContent:contentStr];
        }
    }
}

//
//#pragma mark - Table view data source
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 2;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if(0 == section)
//    {
//        return 2;
//    }
//    else
//    {
//        return 8;
//    }
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

//- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if(0 == section)
//    {
//        return @"购彩定时提醒";
//    }
//    else
//    {
//        return @"彩种设置";
//    }
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    BuyRemindCell *cell = (BuyRemindCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[BuyRemindCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
          }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UISwitch*  swith = [[UISwitch alloc] initWithFrame:CGRectMake(215, 8, 79, 27)];
    if (indexPath.row==0) {
        [swith setHidden:YES];
    }else
    {
        [swith setHidden:NO];
    }
    if (indexPath.row==1)
    {
        cell.titleLable.frame =CGRectMake(10, 10, 100, 25);
    }else
    {
        cell.titleLable.frame =CGRectMake(10, 5, 100, 25);
    }
       switch (indexPath.row)
       {
               
           case 0:
           {
               cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
               cell.selectionStyle = UITableViewCellSelectionStyleGray;
               
               cell.titleLable.text = [self.recodeSwitchDic objectForKey:kLotteryBetWarnTimeKey];
               cell.subLable.text = @"设置提醒的时间";
               //            for(int i = 0; i < 9; i++)
               //            {
               //                [cell viewWithTag:SwitchStartTag + i].hidden = YES;
               //            }
               cell.accessoryView = nil;
           }
               
               break;
           case 1:
           {
               cell.accessoryType = UITableViewCellAccessoryNone;
               cell.titleLable.text = @"开启声音提醒";
               
               if([[self.recodeSwitchDic objectForKey:kLotteryBetWarnSongKey] isEqualToString:@"1"])
                   swith.on = YES;
               else
                   swith.on = NO;
           }
               break;
           case 2:
               if([[self.recodeSwitchDic objectForKey:kLotTitleSSQ] isEqualToString:@"1"])
                   swith.on = YES;
               else
                   swith.on = NO;
               cell.titleLable.text = @"双色球";
               cell.subLable.text = @"每周二、四、日提醒";
               break;
           case 3:
               if([[self.recodeSwitchDic objectForKey:kLotTitleFC3D] isEqualToString:@"1"])
                   swith.on = YES;
               else
                   swith.on = NO;
               cell.titleLable.text = @"福彩3D";
               cell.subLable.text = @"每天提醒";

               break;
           case 4:
               if([[self.recodeSwitchDic objectForKey:kLotTitleQLC] isEqualToString:@"1"])
                   swith.on = YES;
               else
                   swith.on = NO;
               cell.titleLable.text = @"七乐彩";
               cell.subLable.text = @"每周一、三、五提醒";
               break;
           case 5:
               if([[self.recodeSwitchDic objectForKey:kLotTitleDLT] isEqualToString:@"1"])
                   swith.on = YES;
               else
                   swith.on = NO;
               cell.titleLable.text = @"大乐透";
               cell.subLable.text = @"每周一、三、六提醒";
               break;
           case 6:
               if([[self.recodeSwitchDic objectForKey:kLotTitlePLS] isEqualToString:@"1"])
                   swith.on = YES;
               else
                   swith.on = NO;
               cell.titleLable.text = @"排列三";
               cell.subLable.text = @"每天提醒";
               break;
           case 7:
               if([[self.recodeSwitchDic objectForKey:kLotTitlePL5] isEqualToString:@"1"])
                   swith.on = YES;
               else
                   swith.on = NO;
               cell.titleLable.text = @"排列五";
               cell.subLable.text = @"每天提醒";
               break;
           case 8:
               if([[self.recodeSwitchDic objectForKey:kLotTitleQXC] isEqualToString:@"1"])
                   swith.on = YES;
               else
                   swith.on = NO;
               cell.titleLable.text = @"七星彩";
               cell.subLable.text = @"每周二、五、日提醒";
               break;
           default:
               break;
       }
       swith.tag = SwitchStartTag + indexPath.row-1;
       [swith addTarget:self action:@selector(pressSwitch:) forControlEvents:UIControlEventValueChanged];
       cell.accessoryView = swith;
       [swith release];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        BuyRemindCell *Aircell = (BuyRemindCell *)[tableView cellForRowAtIndexPath:indexPath];
        Aircell.accessoryImageView.image = [UIImage imageNamed:@"cell_c_gengduo_click.png"];
        
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
}
- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuyRemindCell *Aircell = (BuyRemindCell *)[tableView cellForRowAtIndexPath:indexPath];
    Aircell.accessoryImageView.image = [UIImage imageNamed:@"cell_c_gengduo.png"];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSIndexPath *currentSelectedIndexPath = [self.myTableView indexPathForSelectedRow];
    if (currentSelectedIndexPath != nil)
    {
        BuyRemindCell *Aircell = (BuyRemindCell *)[tableView cellForRowAtIndexPath:currentSelectedIndexPath];
        Aircell.accessoryImageView.image = [UIImage imageNamed:@"cell_c_gengduo.png"];
        [self.myTableView deselectRowAtIndexPath:currentSelectedIndexPath animated:NO];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        if(m_selectDateView.frame.origin.y == [UIScreen mainScreen].bounds.size.height)
            [m_selectDateView presentModalView:3];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)pressSwitch:(id)sender
{
    UISwitch *temp = (UISwitch *)sender;
	int temptag = temp.tag - SwitchStartTag;
    NSLog(@"index %d", temptag);
    switch (temptag)
    {
        case 0:
        {
            if([[self.recodeSwitchDic objectForKey:kLotteryBetWarnSongKey] isEqualToString:@"0"])
            {
                [self.recodeSwitchDic setObject:@"1" forKey:kLotteryBetWarnSongKey];
            }
            else
            {
                [self.recodeSwitchDic setObject:@"0" forKey:kLotteryBetWarnSongKey];
            }
        }break;
        case 1:
        {
            if([[self.recodeSwitchDic objectForKey:kLotTitleSSQ] isEqualToString:@"0"])
            {
                [self.recodeSwitchDic setObject:@"1" forKey:kLotTitleSSQ];
            }
            else
            {
                [self.recodeSwitchDic setObject:@"0" forKey:kLotTitleSSQ];
            }
        }break;
        case 2:
        {
            if([[self.recodeSwitchDic objectForKey:kLotTitleFC3D] isEqualToString:@"0"])
            {
                [self.recodeSwitchDic setObject:@"1" forKey:kLotTitleFC3D];
            }
            else
            {
                [self.recodeSwitchDic setObject:@"0" forKey:kLotTitleFC3D];
            }
        }break;
        case 3:
        {
            if([[self.recodeSwitchDic objectForKey:kLotTitleQLC] isEqualToString:@"0"])
            {
                [self.recodeSwitchDic setObject:@"1" forKey:kLotTitleQLC];
            }
            else
            {
                [self.recodeSwitchDic setObject:@"0" forKey:kLotTitleQLC];
            }
        }break;
        case 4:
        {
            if([[self.recodeSwitchDic objectForKey:kLotTitleDLT] isEqualToString:@"0"])
            {
                [self.recodeSwitchDic setObject:@"1" forKey:kLotTitleDLT];
            }
            else
            {
                [self.recodeSwitchDic setObject:@"0" forKey:kLotTitleDLT];
            }
        }break;
        case 5:
        {
            if([[self.recodeSwitchDic objectForKey:kLotTitlePLS] isEqualToString:@"0"])
            {
                [self.recodeSwitchDic setObject:@"1" forKey:kLotTitlePLS];
            }
            else
            {
                [self.recodeSwitchDic setObject:@"0" forKey:kLotTitlePLS];
            }
        }break;
        case 6:
        {
            if([[self.recodeSwitchDic objectForKey:kLotTitlePL5] isEqualToString:@"0"])
            {
                [self.recodeSwitchDic setObject:@"1" forKey:kLotTitlePL5];
            }
            else
            {
                [self.recodeSwitchDic setObject:@"0" forKey:kLotTitlePL5];
            }
        }break;
        case 7:
        {
            if([[self.recodeSwitchDic objectForKey:kLotTitleQXC] isEqualToString:@"0"])
            {
                [self.recodeSwitchDic setObject:@"1" forKey:kLotTitleQXC];
            }
            else
            {
                [self.recodeSwitchDic setObject:@"0" forKey:kLotTitleQXC];
            }
        }break;
        case 8:
        {
            if([[self.recodeSwitchDic objectForKey:kLotTitle22_5] isEqualToString:@"0"])
            {
                [self.recodeSwitchDic setObject:@"1" forKey:kLotTitle22_5];
            }
            else
            {
                [self.recodeSwitchDic setObject:@"0" forKey:kLotTitle22_5];
            }
        }break;
        default:
            break;
    }
}


@end
