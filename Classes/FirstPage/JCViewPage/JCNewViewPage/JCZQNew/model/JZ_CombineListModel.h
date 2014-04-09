//
//  JZ_CombineListModel.h
//  Boyacai
//
//  Created by qiushi on 13-9-6.
//
//

#import <Foundation/Foundation.h>

@interface JZ_CombineListModel : NSObject

@end

/*
 X串Y
 */
@class JZ_CombineList;
@interface JZ_CombineListArray : NSObject {
    NSMutableArray                          *m_combineListArray;//存放的从N场比赛选出来X场的 比赛组合
}
@property (nonatomic,retain) NSMutableArray* combineListArray;
-(void) appendListArray:(JZ_CombineList*) listArray;
@end
@class JZ_CombineBase;
@interface JZ_CombineList : NSObject {
    NSMutableArray                          *m_combineList; //存放的每个X
}
@property (nonatomic,retain) NSMutableArray* combineList;
-(void) appendList:(JZ_CombineBase*) list;
@end
@interface JZ_CombineBase : NSObject {
    NSMutableArray                          *m_combineBase_SP;//每场比赛
    NSMutableArray                          *m_combineBase_SP_confusion;//内存四个数组，分别代表混合过关的四种玩法
    BOOL                                    m_isDan;
    int                                     m_gameCount;//每场比赛的选择count
}
@property (nonatomic,retain) NSMutableArray* combineBase_SP;
@property (nonatomic,retain) NSMutableArray* combineBase_SP_confusion;

@property (nonatomic,assign) BOOL isDan;
@property (nonatomic,assign) NSInteger gameCount;


@end

void jzcombine( int a[], int n, int m,  int b[], const int M,JZ_CombineListArray *ListArraybase,JZ_CombineList* data);//函数 范围--二次修改

void jzcombine_List( int a[], int n, int m,  int b[], const int M,JZ_CombineList *listbase,JZ_CombineList* data);//在n个数中选取m ---三次修改
//
void jzcombine_SP(float a[], int n, int m, int b[], const int M ,JZ_CombineListArray *ListArraybase,JZ_CombineList* data);
void jzcombine_SP_List(float a[], int n, int m, int b[], const int M ,JZ_CombineList *listbase,JZ_CombineList* data);

//void jzcombine_SP_confusion(float (*result)[100],float  (*data)[100] ,int curr,int count);

void jzcombine_SP_confusion(NSMutableArray* result,NSArray* data,int curr,int count,NSMutableArray* temp_baseArray);

NSMutableArray*                     m_tempBase_stringArray;//存放临时的下标值

//void show(char* result,const char** data, int curr,int count);

