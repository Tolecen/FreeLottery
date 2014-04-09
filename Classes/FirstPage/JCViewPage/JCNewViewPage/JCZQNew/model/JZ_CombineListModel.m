//
//  JZ_CombineListModel.m
//  Boyacai
//
//  Created by qiushi on 13-9-6.
//
//

#import "JZ_CombineListModel.h"

@implementation JZ_CombineListModel

@end

@implementation JZ_CombineListArray
@synthesize combineListArray = m_combineListArray;

- (id)init {
    self = [super init];
    if (self)
    {
        //初始化 数组
        m_combineListArray = [[NSMutableArray alloc] init];
    }
    return self;
}
-(void) appendListArray:(JZ_CombineList*) listArray
{
    [m_combineListArray addObject:listArray];
}
- (void)dealloc {
    [m_combineListArray removeAllObjects];
    [m_combineListArray release];
    [super dealloc];
}
@end


@implementation JZ_CombineList
@synthesize combineList = m_combineList;

- (id)init {
    self = [super init];
    if (self)
    {
        //初始化 数组
        m_combineList = [[NSMutableArray alloc] init];
    }
    return self;
}
-(void) appendList:(JZ_CombineBase*) listbase
{
    [m_combineList addObject:listbase];
}
- (void)dealloc {
    [m_combineList removeAllObjects];
    [m_combineList release];
    [super dealloc];
}
@end

@implementation JZ_CombineBase
@synthesize combineBase_SP = m_combineBase_SP;
@synthesize combineBase_SP_confusion = m_combineBase_SP_confusion;
@synthesize isDan = m_isDan;
@synthesize gameCount = m_gameCount;

- (id)init{
    self = [super init];
    if (self)
    {
        //初始化 数组
        m_combineBase_SP = [[NSMutableArray alloc] init];
        
        self.combineBase_SP_confusion = [[NSMutableArray alloc] initWithCapacity:4];
        
        NSMutableArray* array1 = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
        NSMutableArray* array2 = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
        NSMutableArray* array3 = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
        NSMutableArray* array4 = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
        NSMutableArray* array5 = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
        
        [self.combineBase_SP_confusion addObject:array1];
        [self.combineBase_SP_confusion addObject:array2];
        [self.combineBase_SP_confusion addObject:array3];
        [self.combineBase_SP_confusion addObject:array4];
        [self.combineBase_SP_confusion addObject:array5];
        
    }
    return self;
}

- (void)dealloc {
    [m_combineBase_SP_confusion removeAllObjects];
    [m_combineBase_SP_confusion release];
    
    [m_combineBase_SP removeAllObjects];
    [m_combineBase_SP release];
    [super dealloc];
}
@end