//
//  JC_MyButton.m
//  Boyacai
//
//  Created by qiushi on 13-8-19.
//
//

#import "JC_MyButton.h"
#import "ColorUtils.h"

@implementation JC_MyButton
@synthesize downLabel;
@synthesize isSelect;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *leftLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1, 30)];
        leftLine.backgroundColor = [ColorUtils parseColorFromRGB:@"#d9d6d1"];
        [self addSubview:leftLine];
        [leftLine release];
        
        UIImageView *upLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75,1)];
        upLine.backgroundColor = [ColorUtils parseColorFromRGB:@"#d9d6d1"];
        [self addSubview:upLine];
        [upLine release];
        
        UIImageView *rightLine = [[UIImageView alloc] initWithFrame:CGRectMake(74, 0, 1,30)];
        rightLine.backgroundColor = [ColorUtils parseColorFromRGB:@"#d9d6d1"];
        [self addSubview:rightLine];
        [rightLine release];
        
        UIImageView *downLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, 75,1)];
        downLine.backgroundColor = [ColorUtils parseColorFromRGB:@"#d9d6d1"];
        [self addSubview:downLine];
        [downLine release];
        
        width =  self.frame.size.width;
        height = self.frame.size.height;
        [self addTarget:self action:@selector(jcButtonTouchDown) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(jcButtonTouchOut) forControlEvents:UIControlEventTouchUpOutside];
        [self addTarget:self action:@selector(jcButtonTouchChanel) forControlEvents:UIControlEventTouchCancel];
        
        
        
        
    }
    return self;
}

- (void)jcButtonTouchChanel
{
    self.backgroundColor  = [ColorUtils parseColorFromRGB:@"#f4f2ee"];
    NSLog(@"shi");
}

- (void)jcButtonTouchDown
{
    self.backgroundColor  = [ColorUtils parseColorFromRGB:@"#d52322"];
    NSLog(@"he");
}



- (void)jcButtonTouchOut
{
    self.backgroundColor  = [ColorUtils parseColorFromRGB:@"#f4f2ee"];
    NSLog(@"shi");
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
-(void)setMyButton:(UIImage*)_Image  UPLABEL:(NSString*)upLabelText DOWNLABEL:(NSString *)downLabelText
{
    CGRect downFrame = CGRectMake(0, 5, 75, 30/2);//位于下部分的 图片 和 label的frame
    
    if (_Image != nil) {
        [self setImage:_Image forState:UIControlStateNormal];//设置 未选中状态下 背景图片
    }
      
    downLabel = [[UILabel alloc] initWithFrame:downFrame];
    downLabel.backgroundColor = [UIColor clearColor];
    downLabel.textAlignment = 1;
    downLabel.font = [UIFont systemFontOfSize:15];
    
    [self addSubview:downLabel];
    
    

    
}
- (void)dealloc
{
    [downLabel release];

    [super dealloc];
}

@end
