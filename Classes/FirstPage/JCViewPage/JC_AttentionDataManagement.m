//
//  JC_AttentionDataManagement.m
//  RuYiCai
//
//  Created by huangxin on 13-6-28.
//
//

#import "JC_AttentionDataManagement.h"

@implementation JC_AttentionDataManagement
@synthesize mark = m_mark;

static JC_AttentionDataManagement *shareDataManager = nil;

- (void) dealloc
{
    
    [super dealloc];
}

- (id) init
{
    if (self = [super init]) {
    }
    return self;
}

#pragma mark shanreManager
+ (JC_AttentionDataManagement*) shareManager
{
    
    if (shareDataManager == nil) {
        
        shareDataManager = [[JC_AttentionDataManagement alloc] init];
    }
    return shareDataManager;
}

//通过关键字获取保存的数据
- (NSArray*)getSaveData
{
    return (NSArray*)[[NSUserDefaults standardUserDefaults] objectForKey:self.mark];
}

#pragma mark 添加
//往关键字对应的数据中添加一条数据
- (void) addDataWithEvent:(NSString*) event
{
    NSMutableArray *userData_copy = [NSMutableArray arrayWithArray:[self getSaveData]];
    NSString *date_ = [self getDateWithEvent:event];
    //首先判断日期是否存在
    if ([self isPresentTheDate:date_]) {
        
        //ruo存在，判断event是否存在
        if (![self isPresentTheEvent:event]) {
            
            NSMutableDictionary*  timeDict  = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)[[self getSaveData] objectAtIndex:dateIndex]];
            
            NSMutableArray *eventArray = [NSMutableArray arrayWithArray:[timeDict objectForKey:date_]];
            [eventArray addObject:event];
            [timeDict setObject:eventArray forKey:date_];
            [userData_copy replaceObjectAtIndex:dateIndex withObject:timeDict];
            
            //写入文件
            [[NSUserDefaults standardUserDefaults] setValue:userData_copy forKey:self.mark];
            [[NSUserDefaults standardUserDefaults] synchronize];//tongbu
        }
    }
    //若日期不存在
    else
    {
        NSMutableDictionary *timeDict = [NSMutableDictionary dictionary];
        NSMutableArray* eventArray = [NSMutableArray array];
        [eventArray addObject:event];
        [timeDict setObject:eventArray forKey:date_];
        
        [userData_copy addObject:timeDict];
        
        //写入文件
        [[NSUserDefaults standardUserDefaults] setValue:userData_copy forKey:self.mark];
        [[NSUserDefaults standardUserDefaults] synchronize];//tongbu
    }
}

//根据Event获取日期
- (NSString*) getDateWithEvent:(NSString*)event
{
    if (event) {
        NSArray *array = [event componentsSeparatedByString:@"_"];
        if ([self.mark isEqualToString:@"instantScore_BJDC"]) {
            
            return [array objectAtIndex:0];
        }
        else
        {
            return [array objectAtIndex:1];
        }
    }
    else
    {
        return @"";
    }
}

//判断是否存在这个日期
- (BOOL) isPresentTheDate:(NSString*)date
{
    BOOL isHave = false;
    NSArray *userDataArray = [self getSaveData];
    
    //如果之前没有保存关注
    if ([userDataArray count] <= 0) {
        isHave = false;
    }
    else//保存了关注
    {
        for (int i = 0; i < [userDataArray count]; i++) {
            
            if ([[userDataArray objectAtIndex:i] objectForKey:date] != nil)
            {
                isHave = true;
                dateIndex = i;
                break;
            }
        }
    }
    return isHave;
}


//判断是否存在这个Event
- (BOOL) isPresentTheEvent:(NSString*) event
{
    BOOL isHave = false;
    NSArray *userDataArray = [self getSaveData];
    
    NSString *date_ = [self getDateWithEvent:event];
    
    if ([self isPresentTheDate:date_]) {
        
        NSArray *eventArray = [(NSDictionary*)[userDataArray objectAtIndex:dateIndex] objectForKey:date_];
        for(NSString *temp in eventArray)
        {
            if ([event isEqualToString:temp]) {
                
                isHave = true;
                break;
            }
        }
    }
    return isHave;
}


//获取当前保存的所有日期
- (NSMutableArray*) getAllDate
{
    NSMutableArray *dateArr = [NSMutableArray arrayWithCapacity:1];
    NSArray *dataArray = [self getSaveData];
    
    //获得所有的日期
    for (int i = 0; i < [dataArray count]; i++) {
        [dateArr addObject:[[(NSDictionary*)[dataArray objectAtIndex:i] allKeys] objectAtIndex:0]];
    }
    
    return dateArr;
}

#pragma mark 排序
//获得当前所有的Event，并且Event是按日期排好序的
- (NSMutableArray*) getAllEvent
{
    NSMutableArray *sortArray = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
    NSArray *dataArray = [self getSaveData];//所有的数据
    NSMutableArray *dateArr = [self getAllDate];//所有的日期
    //给日期排序
    [self selectSortWithDateArray:dateArr];
    
    //通过日期按顺序获得Event
    for (int j = 0; j < [dateArr count]; j++) {
        int index = [self getIndexWithDate:[dateArr objectAtIndex:j]];
        if (index >= 0) {
            [sortArray addObjectsFromArray:[(NSDictionary*)[dataArray objectAtIndex:index] objectForKey:[dateArr objectAtIndex:j]]];
        }
    }
    
    return sortArray;
}


//把当前正在进行的比赛的Event提前
- (NSMutableArray *) sortEventWithCompetingEvent:(NSMutableArray*) eventArray
{
    NSMutableArray *sortArray = [self getAllEvent];//获得所有的Event
    //选出正在进行中的以关注的比赛
    NSMutableArray *m_eventArray = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < [eventArray count]; i++) {
        
        NSString *eventItem = [eventArray objectAtIndex:i];
        for (int j = 0; j < [sortArray count]; j++) {
            
            if ([eventItem isEqualToString:[sortArray objectAtIndex:j]]) {
                
                [m_eventArray addObject:eventItem];
            }
        }
    }
    //把正在比赛的日期放到数组的前面
    [sortArray removeObjectsInArray:m_eventArray];
    NSMutableArray *resultArray = [NSMutableArray arrayWithArray:eventArray];
    [resultArray addObjectsFromArray:sortArray];
    return resultArray;
}


//传进来一个Date获取这个Date对应字典的位置
- (int) getIndexWithDate:(NSString*) date
{
    int index = -1;
    NSArray *dataArray = [self getSaveData];
    for (int i = 0; i < [dataArray count]; i++) {
        NSDictionary *dic = [dataArray objectAtIndex:i];
        if ([dic objectForKey:date] != nil) {
            index = i;
            break;
        }
    }
    return index;
}


//给日期排序,最新的时间排前面
-(void)selectSortWithDateArray:(NSMutableArray *)dateArray
{
    if ([dateArray count] <= 0) {
        return ;
    }
    
    for (int i=0; i<[dateArray count]-1; i++)
    {
        int m =i;
        for (int j =i+1; j<[dateArray count]; j++)
        {
            if ([[dateArray objectAtIndex:j] doubleValue] > [[dateArray objectAtIndex:m] doubleValue])
            {
                m = j;
            }
        }
        if (m != i)
        {
            [self swapWithData:dateArray index1:m index2:i];
        }
    }
    NSLog(@"选择排序后的结果：%@",[dateArray description]);
}


-(void)swapWithData:(NSMutableArray *)aData index1:(NSInteger)index1 index2:(NSInteger)index2
{
    NSNumber *tmp = [aData objectAtIndex:index1];
    [aData replaceObjectAtIndex:index1 withObject:[aData objectAtIndex:index2]];
    [aData replaceObjectAtIndex:index2 withObject:tmp];
}


#pragma mark 删除
//删除一个日期下的所有Event
- (void) removeEventWithDate:(NSString*)date
{
    //首先判断是否存在这个Date
    if ([self isPresentTheDate:date]) {
        //获取Date对应字典的位置
        int index = [self getIndexWithDate:date];
        if (index >= 0) {
            
            NSArray *dataArray = [self getSaveData];
            NSMutableArray *dataArray_copy = [NSMutableArray arrayWithArray:dataArray];
            [dataArray_copy removeObjectAtIndex:index];
            
            //写入本地文件
            [[NSUserDefaults standardUserDefaults] setValue:dataArray_copy forKey:self.mark];
            [[NSUserDefaults standardUserDefaults] synchronize];//同步
            
            NSLog(@"[self getSaveData] = %@",[self getSaveData]);
        }
    }
    else
    {
        NSLog(@"不存在这个日期");
    }
}

//通过Event删除一条数据
- (void) removeEventWithEvent:(NSString*)event
{
    //存在这个Event
    if ([self isPresentTheEvent:event])
    {
        //通过Event获得Date
        NSString* tempDate = [self getDateWithEvent:event];
        //通过Date找到这个Date的位置
        int index = [self getIndexWithDate:tempDate];
        //备份
        NSMutableArray *userData_copy = [NSMutableArray arrayWithArray:[self getSaveData]];
        NSMutableDictionary *m_dictionary = [NSMutableDictionary dictionaryWithCapacity:1];
        
        NSArray *temp_array = [(NSDictionary*)[[self getSaveData] objectAtIndex:index] objectForKey:tempDate];
        NSMutableArray *m_array = [NSMutableArray arrayWithArray:temp_array];
        
        for(NSString *tempEvent in temp_array)
        {
            if ([tempEvent isEqualToString:event]) {
                [m_array removeObject:tempEvent];
                break;
            }
        }
        //如果这个数组里面没有数据则不存储空数组，把这个日期删除
        if ([m_array count] > 0) {
            [m_dictionary setObject:m_array forKey:tempDate];
            [userData_copy replaceObjectAtIndex:index withObject:m_dictionary];
        }
        else
        {
            [userData_copy removeObjectAtIndex:index];
        }
        [[NSUserDefaults standardUserDefaults] setValue:userData_copy forKey:self.mark];
        [[NSUserDefaults standardUserDefaults] synchronize];//同步
    }
    else
    {
        NSLog(@"不存在这个Event");
    }
}


@end
