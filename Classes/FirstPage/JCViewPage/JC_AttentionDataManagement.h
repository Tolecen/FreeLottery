//
//  JC_AttentionDataManagement.h
//  RuYiCai
//
//  Created by huangxin on 13-6-28.
//
//

#import <Foundation/Foundation.h>

@interface JC_AttentionDataManagement : NSObject
{
    NSString *m_mark;
    
    int       dateIndex;//纪录存在这个日期时对应字典的位置
    
}
@property(nonatomic,retain) NSString* mark;
//单例
+ (JC_AttentionDataManagement*) shareManager;

//通过关键字获取保存的数据
- (NSArray*)getSaveData;

//往关键字对应的数据中添加一条数据
- (void) addDataWithEvent:(NSString*) event;

//根据Event获取日期
- (NSString*) getDateWithEvent:(NSString*)event;

//判断是否存在这个日期
- (BOOL) isPresentTheDate:(NSString*)date;

//传进来一个Date获取这个Date对应字典的位置
- (int) getIndexWithDate:(NSString*) date;

//判断是否存在这个Event
- (BOOL) isPresentTheEvent:(NSString*) event;

//获取当前保存的所有日期
- (NSMutableArray*) getAllDate;

//获得当前所有的Event，并且Event是按日期排好序的
- (NSMutableArray*) getAllEvent;

//把当前正在进行的比赛的Event提前
- (NSMutableArray *) sortEventWithCompetingEvent:(NSMutableArray*) eventArray;

//给日期排序,最新的日期排前面
-(void)selectSortWithDateArray:(NSMutableArray *)dateArray;

//删除一个日期下的所有Event
- (void) removeEventWithDate:(NSString*)date;

//通过Event删除一条数据
- (void) removeEventWithEvent:(NSString*)event;


@end
