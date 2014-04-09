//
//  CustomColorButton.m
//  Boyacai
//
//  Created by qiushi on 13-11-13.
//
//

#import "CustomColorButtonUtils.h"
#import "ColorUtils.h"

@interface CustomColorButtonUtils ()

@property (nonatomic, strong) NSString  *normalColorString;
@property (nonatomic, strong) NSString  *higheColorString;

@end


@implementation CustomColorButtonUtils


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}
- (id)initWithSize:(CGSize)size normalColor:(NSString *)normalColorStr higheColor:(NSString*)higheColorStr{
  if (self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)]) {
    self.normalColorString = normalColorStr;
    self.higheColorString  = higheColorStr;
    [self setBackgroundColor:[ColorUtils parseColorFromRGB:normalColorStr]];
    [self addTarget:self action:@selector(selfTouchDown) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(selfTouchOutside) forControlEvents:UIControlEventTouchUpOutside];
    [self addTarget:self action:@selector(selfTouchCancel) forControlEvents:UIControlEventTouchCancel];
  }
  return self;
}


- (id)initWithRect:(CGRect)frame normalColor:(NSString *)normalColorStr higheColor:(NSString*)higheColorStr{
    if (self = [super initWithFrame:frame]) {
        self.normalColorString = normalColorStr;
        self.higheColorString  = higheColorStr;
        [self setBackgroundColor:[ColorUtils parseColorFromRGB:normalColorStr]];
        [self addTarget:self action:@selector(selfTouchDown) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(selfTouchOutside) forControlEvents:UIControlEventTouchUpOutside];
        [self addTarget:self action:@selector(selfTouchCancel) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


//按钮点击的效果制作
- (void)selfTouchDown
{
    [self setBackgroundColor:[ColorUtils parseColorFromRGB:self.higheColorString]];
}
- (void)selfTouchOutside
{
    [self setBackgroundColor:[ColorUtils parseColorFromRGB:self.normalColorString]];
}

- (void)selfTouchCancel
{
    [self setBackgroundColor:[ColorUtils parseColorFromRGB:self.normalColorString]];
}


@end
