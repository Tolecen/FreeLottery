//
//  TitleViewButtonItemUtils.h
//  Boyacai
//
//  Created by 纳木 那咔 on 13-4-22.
//
//

#import <UIKit/UIKit.h>
@class CollectionMenuViewUtil;
@protocol TitleViewButtonItemUtilsDelegate <NSObject>

-(void)menuNumberOfRowsInMenu:(NSInteger)num;
@end


@interface TitleViewButtonItemUtils : UIView
{
    id<TitleViewButtonItemUtilsDelegate> _delegate;
    bool openMenu;
}
@property (nonatomic) bool openMenu;
@property (nonatomic, assign) id<TitleViewButtonItemUtilsDelegate> delegate;
@property (nonatomic, retain) CollectionMenuViewUtil *menuView;

+(void)shutDownMenu;
+(void)addTitleViewForController:(UIViewController *)controller menuTitle:(NSArray*)array delegate:(id)delegate;

+(void)addTitleViewForController:(UIViewController *)controller menuTitles:(NSArray*)titles menuImages:(NSArray*)menuImages  menuSelectedImages:(NSArray*)selectedImages delegate:(id)delegate;
-(void)changeMenuView;
+(TitleViewButtonItemUtils *)addTitleMenuViewForController:(UIViewController *)controller menuTitles:(NSArray*)titles menuImages:(NSArray*)menuImages  menuSelectedImages:(NSArray*)selectedImages delegate:(id)delegate;
+(void)addTitleViewForController:(UIViewController *)controller title:(NSString *)title font:(UIFont *)font textColor:(UIColor *)color;

@end
