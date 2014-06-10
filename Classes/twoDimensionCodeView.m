//
//  TwoDimensionCodeView.m
//  Boyacai
//
//  Created by wangxr on 14-6-9.
//
//

#import "TwoDimensionCodeView.h"
@interface TwoDimensionCodeView ()
@property (nonatomic,assign) UIViewController * viewC;
@end
@implementation TwoDimensionCodeView

- (id)initWithView:(UIViewController*)viewC
{
    self = [super init];
    if (self) {
        // Initialization code
        self.viewC = viewC;
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, viewC.view.frame.size.height, viewC.view.frame.size.width, viewC.view.frame.size.height);
        [viewC.view addSubview:self];
        UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-320, self.frame.size.width, 320)];
        whiteView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        [self addSubview:whiteView];
        [whiteView release];
        UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(60, 40, 200, 200)];
        image.image = [UIImage imageNamed:@"TwoDimensionCode"];
        [whiteView addSubview:image];
        UIView * lineV = [[UIView alloc]initWithFrame:CGRectMake(0, whiteView.frame.size.height - 50, 320, 1)];
        lineV.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
        [whiteView addSubview:lineV];
        [lineV release];
        UIButton* cancleB = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancleB setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [cancleB setTitle:@"取消" forState:UIControlStateNormal];
        cancleB.frame = CGRectMake(0, whiteView.frame.size.height - 50, 320, 50);
        [cancleB addTarget:self action:@selector(canclesharePlatformView) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:cancleB];
        
        UIButton* cancelB = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelB.frame = CGRectMake(0, 0, 320, self.frame.size.height - whiteView.frame.size.height);
        [cancelB addTarget:self action:@selector(canclesharePlatformView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelB];
    }
    return self;
}
-(void)showSharePlatformView
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
                     }
     ];
}
-(void)canclesharePlatformView
{
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0,  self.frame.size.height, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }
     ];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
