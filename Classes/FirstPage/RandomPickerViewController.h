//
//  RandomPickerViewController.h
//  RuYiCai
//
//  Created by LiTengjie on 11-8-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _PickerType 
{
	SSQ_RANDOM_NUM = 0,
	FC3D_GROUP = 1,
    BANK_GROUP = 2,
    PHONE_CARD_TYPE_GROUP = 3,
    PHONE_CARD_AMOUNT_GROUP = 4,
    GAME_CARD_TYPE_GROU = 5,
    GET_CASH_BANK_NAME = 6,
	P11X5_TYPE = 7,
    LUCK_PLAY_TYPE = 8,
    LUCK_LOT_TYPE = 9,
    LUCK_NUM = 10,
    DRAG11X5_TYPE = 11,
    DRAG11YDJ_TYPE = 12,
    RANDOM_TYPE_BASE,//自定数值
} PickerType;

@protocol RandomPickerDelegate;

@interface RandomPickerViewController: UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
	id<RandomPickerDelegate> delegate;
	BOOL            m_isMove;
	NSMutableArray *m_pickerNumArray;
	UIPickerView   *m_randomPicker;
	int             m_pickerType;
	int             m_pickerMinNum;
    int             m_pickerMaxNum;
	int             m_selectPickerRow;
}

@property (nonatomic, assign) id<RandomPickerDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *pickerNumArray;
@property (nonatomic, assign) int pickerType;

- (UIView *)mainView;
- (void)presentModalView:(UIView *)subView setPickerType:(int)type;
- (void)dismissModalView:(UIView *)subView;
- (void)setPickerNum:(int)num withMinNum:(int)minNum andMaxNum:(int)maxNum;
- (int)currentPickerType;
- (void)setPickerDataArray:(NSArray*)otherArray;

@end

@protocol RandomPickerDelegate
//（1）@optional预编译指令：表示可以选择实现的方法
//（2）@required预编译指令：表示必须强制实现的方法
- (void)randomPickerView:(RandomPickerViewController*)randomPickerView selectRowNum:(int)num;

@end

