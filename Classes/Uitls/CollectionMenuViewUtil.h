//
//  CollectionMenuViewUtil.h
//  Boyacai
//
//  Created by 纳木 那咔 on 13-4-22.
//
//

#import <UIKit/UIKit.h>

@protocol CollectionMenuViewUtilDelegate <NSObject>

-(void)menuButton:(UIButton *)button numberOfRowsInMenu:(NSInteger)num;
-(void)menuButton:(UIButton *)button numberOfRowsInMenu:(NSInteger)num menuTitle:(NSString *)title;
-(void)cancelMenu;
@end


@interface CollectionMenuViewUtil : UIView
{
    id<CollectionMenuViewUtilDelegate> delegate;
    NSMutableArray *_buttons;

}
@property(nonatomic,retain) id<CollectionMenuViewUtilDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *buttons;

- (id)initWithFrame:(CGRect)frame withNameArray:(NSArray*)array;
- (id)initWithFrame:(CGRect)frame withTitles:(NSArray *)titles Images:(NSArray*)images selectedImages:(NSArray *)selectedImages;
-(IBAction)menuImageButtonAction:(id)sender;
@end
