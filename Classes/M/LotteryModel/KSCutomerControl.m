//
//  MyControl.m
//  Boyacai
//
//  Created by fengyuting on 13-10-28.
//
//

#import "KSCutomerControl.h"
#import "ColorUtils.h"

@implementation KSCutomerControl
+(UILabel *)customLabel:(CGRect)frame title:(NSString *)labelTitle textColor:(UIColor *)textColor alignment:(NSTextAlignment *)alignmentType backgroundColor:(UIColor *)color font:(UIFont *)font{
    
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    
    label.text = labelTitle;
    
    label.textAlignment = alignmentType;
    
    label.textColor = textColor;
    
    label.backgroundColor = color;
    
    label.font = font;
    
    return [label autorelease];
}


+(UIButton *)customButton:(CGRect)frame title:(NSString *)buttonTitle textColor:(UIColor *)textColor backgroundColor:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)method{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = frame;
    
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    
    [button setTitleColor:textColor forState:UIControlStateNormal];
    
    button.backgroundColor = color;
    
    button.titleLabel.font = font;
    
    [button addTarget:target action:method forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}


+(void)superView:(UIView *)superView subViewColor:(UIColor *)color lineWith:(float)width{
    
    UIView * leftView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, width, superView.frame.size.height)] autorelease];
    leftView.backgroundColor = color;
    
    UIView * rightView = [[[UIView alloc] initWithFrame:CGRectMake(superView.frame.size.width - width, 0, width,superView.frame.size.height )] autorelease];
    rightView.backgroundColor = color;
    
    UIView * topView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, superView.frame.size.width, width)] autorelease];
    topView.backgroundColor = color;
    
    UIView * bottomView = [[[UIView alloc] initWithFrame:CGRectMake(0, superView.frame.size.height - width, superView.frame.size.width,width)] autorelease];
    bottomView.backgroundColor = color;
    
    [superView addSubview:leftView];
    [superView addSubview:rightView];
    [superView addSubview:topView];
    [superView addSubview:bottomView];
    
}


+ (UIImage *) imageFromView: (UIView *)theView {
    // draw a view's contents into an image context   UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef  context = UIGraphicsGetCurrentContext();
    
    [theView.layer  renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+(UIView *)creatViewColorString:(NSString *)colorString frame:(CGRect)frame {
    
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [ColorUtils parseColorFromRGB:colorString];
    view.frame = frame;
    return view;
}

@end
