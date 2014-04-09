//
//  MyButton.m
//  TextClass
//
//  Created by bys adm on 5/17/12.
//  Copyright 2012 beijing. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton
@synthesize upLabel,downLabel,isSelect;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        width =  self.frame.size.width;
        height = self.frame.size.height;
    }
    return self;
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
    CGRect upFrame = CGRectMake(0, 0, width, height/2);//位于上部分的 图片 和 label的frame
    CGRect downFrame = CGRectMake(0, height/2, width, height/2);//位于下部分的 图片 和 label的frame
    
    if (_Image != nil) {
        [self setImage:_Image forState:UIControlStateNormal];//设置 未选中状态下 背景图片
    }
    
    upLabel = [[UILabel alloc] initWithFrame:upFrame];
    upLabel.backgroundColor = [UIColor clearColor];//label背景颜色置空，方便显示图片
    upLabel.textAlignment = 1;//文字位于中间
    [upLabel setText:upLabelText];
    upLabel.font = [UIFont systemFontOfSize:15];
    
    downLabel = [[UILabel alloc] initWithFrame:downFrame];
    downLabel.backgroundColor = [UIColor clearColor];
    downLabel.textAlignment = 1;
    [downLabel setText:downLabelText];
    downLabel.font = [UIFont systemFontOfSize:15];
    
    [self addSubview:upLabel];
    [self addSubview:downLabel];
    
    [upLabel release];
    [downLabel release];
}
- (void)dealloc
{
    [super dealloc];
}

@end
