//
//  SchiebenViewUitils.h
//  Boyacai
//
//  Created by qiushi on 13-5-9.
//
//

#import <UIKit/UIKit.h>

@class SchiebenViewUitils;

@protocol SchiebenViewUitilsDelegate <NSObject>

- (void)schiebenSegmentedControl:(SchiebenViewUitils *)schiebenSegmentedControl didSelectItemAtIndex:(NSUInteger)index;

@end

@interface SchiebenViewUitils : UIView
{
    int                 redTag;
    NSArray      *m_titiles;
}
@property (nonatomic,retain) NSArray      *titiles;
@property (nonatomic, assign) id<SchiebenViewUitilsDelegate> delegate;

- (id)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles andFontSize:(CGFloat)fontSize;

-(void)gotoPage:(NSInteger)index AddAnimation:(BOOL)type;
@end


