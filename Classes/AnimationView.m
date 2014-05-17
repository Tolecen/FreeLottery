//
//  AnimationView.m
//  Boyacai
//
//  Created by wangxr on 14-5-13.
//
//

#import "AnimationView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "iCarousel.h"
@interface AnimationView ()<iCarouselDataSource,iCarouselDelegate>
{
    BOOL needStop;
    int integer;
}
@property (nonatomic, copy) void (^completion)(void);
@property (nonatomic, retain)iCarousel *carousel;
@property (nonatomic, retain)UIImageView * shakeTop;
@property (nonatomic, retain)UIImageView * shakeBottom;
@end
@implementation AnimationView
- (void)dealloc
{
    [_subviewsArray release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        needStop = NO;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 152)];
        imageV.tag = 100;
        imageV.image = [UIImage imageNamed:@"animationBG"];
        imageV.center = CGPointMake(160, frame.size.height/3+20);
        [self addSubview:imageV];
        [imageV release];
        self.carousel = [[iCarousel alloc]initWithFrame:CGRectMake(0, 0, 320, 152)];
        _carousel.center =CGPointMake(160, frame.size.height/3+20);
        _carousel.delegate = self;
        _carousel.dataSource = self;
        _carousel.type = iCarouselTypeRotary;
        [self addSubview:_carousel];
        _carousel.hidden = YES;
        _carousel.userInteractionEnabled = NO;
        
        self.shakeTop = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 45)];
        _shakeTop.center = CGPointMake(160, frame.size.height/3-2);
        _shakeTop.image = [UIImage imageNamed:@"yao-top"];
        [self addSubview: _shakeTop];
        self.shakeBottom = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 104, 47)];
        _shakeBottom.center = CGPointMake(160, frame.size.height/3+43);
        _shakeBottom.image = [UIImage imageNamed:@"yao_bottom"];
        [self addSubview: _shakeBottom];
        
        self.hidden = YES;
        _animation = NO;
    }
    return self;
}
- (void)showCardWithTitle:(NSString*)title content:(NSString*)content Target:(id)target action:(SEL)action
{
    self.carousel.hidden = YES;
    [self viewWithTag:100].hidden = YES;
    UIImageView* tishiIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 284, 236)];
    tishiIV.image = [UIImage imageNamed:@"get_backGround"];
    tishiIV.center = _carousel.center;
    [self addSubview:tishiIV];
    tishiIV.userInteractionEnabled = YES;
    [tishiIV release];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 284, 40)];
    label.text = title;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [tishiIV addSubview:label];
    [label release];
    
    UITextView * textV = [[UITextView alloc]initWithFrame:CGRectMake(10, 40, 300, 120)];
    textV.editable = NO;
    textV.text = content;
    textV.font = [UIFont systemFontOfSize:14];
    textV.backgroundColor = [UIColor clearColor];
    [tishiIV addSubview:textV];
    [textV release];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"get_normal"] forState:UIControlStateNormal];
    [button setTitle:@"领取" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(68, 180, 143, 35.5);
    [tishiIV addSubview:button];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)starAnimation
{
    _animation = YES;
    self.hidden = NO;
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [_carousel reloadData];
    [UIView animateWithDuration:0.3 animations:^{
        _carousel.hidden = NO;
        CGPoint top = _shakeTop.center ;
        CGPoint bottom = _shakeBottom.center;
        _shakeTop.center = CGPointMake(160, top.y-70);
        _shakeBottom.center = CGPointMake(160, bottom.y+70);
    } completion:^(BOOL finished) {
        [self pickAutoScroll:0];
    }];
}
- (void)pickAutoScroll:(int)i
{
    if (i>_subviewsArray.count*2) {
        i = 0;
    }
    [_carousel scrollToItemAtIndex:i duration:0.07 completion:^{
        if (needStop&&i==integer) {
            _animation = NO;
            _completion();
        }else{
            [self pickAutoScroll:i+1];
        }
    }];
}

- (void)stopAnimationWithSubviewsLocation:(NSInteger)location completion:(void (^)(void))completion
{
    needStop = YES;
    integer = location;
    self.completion = completion;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#pragma mark -

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return _subviewsArray.count*2;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    UIView *view = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"card_%d",index%4]]] autorelease];
    
    view.frame = CGRectMake(0, 0, 93.5, 63);
    UILabel*label = [[[UILabel alloc]initWithFrame:view.frame] autorelease];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:14];
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    label.text = _subviewsArray[index%_subviewsArray.count];
    return view;
}
- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return 100;
}
- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    return YES;
}
@end
