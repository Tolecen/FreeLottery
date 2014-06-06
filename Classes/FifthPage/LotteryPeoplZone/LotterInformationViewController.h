//
//  LotterInformationViewController.h
//  Boyacai
//
//  Created by 纳木 那咔 on 13-4-19.
//
//

#import <UIKit/UIKit.h>
#import "RuYiCaiAppDelegate.h"

typedef enum _SegmentType{
    caiMinQuWen = 0,
    zhuanJiaTuiJian,
    zuQiuTianDi,
    zhanNeiGongGao
}SegmentType;

@interface LotterInformationViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    RuYiCaiAppDelegate *m_delegate;
    
    UITableView       *m_tableView;
    
    NSMutableDictionary           *m_typeIdDicArray;
    SegmentType _segmentType;
//    enum WXScene _scene;
    
}

@property (nonatomic, retain) UITableView        *tableView;
@property (nonatomic, retain) NSMutableDictionary     *typeIdDicArray;
@property (nonatomic, assign) SegmentType segmentType;

@end
