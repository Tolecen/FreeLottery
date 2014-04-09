//
//  CustomSegmentedControl.h
//  42qu
//
//  Created by Alex Rezit on 12-6-16.
//  Copyright (c) 2012年 Seymour Dev. All rights reserved.
//
//  替代系统的Segmented控件 实现Segmented的自定义效果

#import <UIKit/UIKit.h>

@class CustomSegmentedControl;

@protocol CustomSegmentedControlDelegate <NSObject>

- (void)customSegmentedControl:(CustomSegmentedControl *)customSegmentedControl didSelectItemAtIndex:(NSUInteger)index;

@end

typedef enum {
    SegmentedControlAnimationTypeFade = 0,
    SegmentedControlAnimationTypeMove
} SegmentedControlAnimationType;

typedef enum{
    SegmentedImageType = 0,
    SegmentedTitleType
}SegmentedType;
@interface CustomSegmentedControl : UIView{
    NSInteger _segmentedIndex;
    NSInteger _numberOfSegments;
}

@property (nonatomic, assign) NSInteger segmentedIndex;
@property (nonatomic, assign) NSInteger numberOfSegments;
@property (nonatomic, assign) id<CustomSegmentedControlDelegate> delegate;

@property (nonatomic, assign) SegmentedControlAnimationType animationType;
@property (nonatomic, assign) SegmentedType segmentType;

@property (nonatomic, retain) NSArray *buttons;

@property (nonatomic, retain) NSArray *titles;
@property (nonatomic, retain) NSArray *highlightedTitles;
@property (nonatomic, retain) NSArray *selectedTitles;
@property (nonatomic, retain) UIImage *dividerImage;
@property (nonatomic, retain) UIImage *highlightedBackgroundImage;
@property (nonatomic, retain) UIImage *selectedBackgroundImage;

@property (nonatomic, retain) UIImage *leftNormalImage;
@property (nonatomic, retain) UIImage *righNormalImage;
@property (nonatomic, retain) UIImage *leftHighlightedBackgroundImage;
@property (nonatomic, retain) UIImage *rightHighlightedBackgroundImage;
@property (nonatomic, retain) UIImage *leftSelectedBackgroundImage;
@property (nonatomic, retain) UIImage *rightSelectedBackgroundImage;

@property (nonatomic, retain) UIImageView *highlightedBackgroundImageView;
@property (nonatomic, retain) UIImageView *selectedBackgroundImageView;

@property (nonatomic, retain) NSArray *normalImgs;
@property (nonatomic, retain) NSArray *highlightedImgs;
@property (nonatomic, retain) NSArray *selectImgs;

//自定义 segmengted 根据titles 长度设置按钮个数 图片样式参数参考使用
- (id)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles andHighlightedTitles:(NSArray *)highlightedTitles andSelectedTitles:(NSArray *)selectedTitles andBackgroundImage:(UIImage *)backgroundImage andDividerImage:(UIImage *)dividerImage andHighlightedBackgroundImage:(UIImage *)highlightedBackgroundImage andSelectedBackgroundImage:(UIImage *)selectedBackgroundImage;

//自定义 segmengted 根据image 文件名 自动生成按钮 可以设置默认 高亮 和 选中3种效果
- (id)initWithFrame:(CGRect)frame andNormalImages:(NSArray *)normalImgs andHighlightedImages:(NSArray *)highlightedImgs andSelectImage:(NSArray *)selectImages;

@end
