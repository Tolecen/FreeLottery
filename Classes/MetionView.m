//
//  MetionView.m
//  Boyacai
//
//  Created by wangxr on 14-6-10.
//
//

#import "MetionView.h"
@interface MetionView ()
@property (nonatomic,assign) UIViewController * viewC;
@property (nonatomic,retain) UITextView * InfoTextView;
@end
@implementation MetionView
- (void)dealloc
{
    [_InfoTextView release];
    [super dealloc];
}
- (id)initWithView:(UIViewController*)viewC
{
    self = [super init];
    if (self) {
        // Initialization code
        self.viewC = viewC;
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, viewC.view.frame.size.height, viewC.view.frame.size.width, viewC.view.frame.size.height);
        [viewC.view addSubview:self];
        
        UIView * whiteV = [[UIView alloc] initWithFrame:CGRectMake(20, 40, 280, 320)];
        [whiteV setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:whiteV];
        UIImageView * topBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, 44)];
        [topBG setImage:[UIImage imageNamed:@"bottom_redbg"]];
        [whiteV addSubview:topBG];
        [topBG release];
        UILabel * tishiL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 44)];
        [tishiL setText:@"温馨提示"];
        [tishiL setBackgroundColor:[UIColor clearColor]];
        [tishiL setTextColor:[UIColor whiteColor]];
        [tishiL setTextAlignment:NSTextAlignmentCenter];
        [whiteV addSubview:tishiL];
        [tishiL release];
        UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureBtn setFrame:CGRectMake(20, 270, 240, 40)];
        [sureBtn setBackgroundImage:[UIImage imageNamed:@"redbg"] forState:UIControlStateNormal];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTintColor:[UIColor whiteColor]];
        [whiteV addSubview:sureBtn];
        [sureBtn addTarget:self action:@selector(canclesharePlatformView) forControlEvents:UIControlEventTouchUpInside];
        
        self.InfoTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 45, 270, 265-45)];
        [_InfoTextView setBackgroundColor:[UIColor clearColor]];
        _InfoTextView.editable = NO;
        _InfoTextView.font = [UIFont systemFontOfSize:16];
        [whiteV addSubview:_InfoTextView];
        [_InfoTextView release];
        
    }
    return self;
}
- (void)showInfoText:(NSString*)infoString
{
    _InfoTextView.text =infoString;
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
