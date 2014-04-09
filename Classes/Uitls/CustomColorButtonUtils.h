//
//  CustomColorButton.h
//  Boyacai
//
//  Created by qiushi on 13-11-13.
//
//

#import <UIKit/UIKit.h>

@interface CustomColorButtonUtils : UIButton

//创建一个可以设置颜色的按钮，并且自己内部管理颜色效果
- (id)initWithSize:(CGSize)size normalColor:(NSString *)normalColorStr higheColor:(NSString*)higheColorStr;


- (id)initWithRect:(CGRect)frame normalColor:(NSString *)normalColorStr higheColor:(NSString*)higheColorStr;

@end
