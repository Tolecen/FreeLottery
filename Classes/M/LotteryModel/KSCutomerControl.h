//
//  MyControl.h
//  Boyacai
//
//  Created by fengyuting on 13-10-28.
//
//

#import <Foundation/Foundation.h>

@interface KSCutomerControl : NSObject
+(UILabel *)customLabel:(CGRect)frame title:(NSString *)labelTitle textColor:(UIColor *)textColor alignment:(NSTextAlignment *)alignmentType backgroundColor:(UIColor *)color font:(UIFont *)font;

+(UIButton *)customButton:(CGRect)frame title:(NSString *)buttonTitle textColor:(UIColor *)textColor backgroundColor:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)method;

+(void)superView:(UIView *)superView subViewColor:(UIColor *)color lineWith:(float)width;

+(UIView *)creatViewColorString:(NSString *)colorString frame:(CGRect)frame;

+ (UIImage *) imageFromView: (UIView *)theView;
@end
