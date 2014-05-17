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
#import <AVFoundation/AVFoundation.h>
@interface AnimationView ()<iCarouselDataSource,iCarouselDelegate,AVAudioPlayerDelegate>
{
    BOOL needStop;
    int integer;
}
@property (nonatomic,retain)AVAudioPlayer*getcoinAudio;
@property (nonatomic, copy) void (^completion)(void);
@property (nonatomic, retain)iCarousel *carousel;
@property (nonatomic, retain)UIImageView * shakeTop;
@property (nonatomic, retain)UIImageView * shakeBottom;
@end
@implementation AnimationView
static SystemSoundID shake_sound_male_id = 0;
static SystemSoundID shake_match_id = 1;
- (void)dealloc
{
    [_getcoinAudio release];
    [_shakeTop release];
    [_shakeBottom release];
    [_carousel release];
    [_subviewsArray release];
    [super dealloc];
}
- (void)initSound
{
    NSString *path_shake_sound_male = [[NSBundle mainBundle] pathForResource:@"shake_sound_male" ofType:@"wav"];
    if (path_shake_sound_male) {
        //注册声音到系统
        AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path_shake_sound_male],&shake_sound_male_id);
    }
    NSString *path_shake_match_id = [[NSBundle mainBundle] pathForResource:@"shake_match" ofType:@"wav"];
    if (path_shake_match_id) {
        //注册声音到系统
        AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path_shake_match_id],&shake_match_id);
    }
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initSound];
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
    
    if (_sound) {
        AudioServicesPlaySystemSound(shake_match_id);
    }
    
}
- (void)starAnimation
{
    _animation = YES;
    self.hidden = NO;
    if (_sound) {
         AudioServicesPlaySystemSound(shake_sound_male_id);
    }
    [_carousel reloadData];
    [UIView animateWithDuration:1 animations:^{
        _carousel.hidden = NO;
        if (_shakeTop.center.y == self.frame.size.height/3-2) {
            CGPoint top = _shakeTop.center ;
            CGPoint bottom = _shakeBottom.center;
            _shakeTop.center = CGPointMake(160, top.y-70);
            _shakeBottom.center = CGPointMake(160, bottom.y+70);
        }
    } completion:^(BOOL finished) {
        if (_sound) {
            [self soundPlay];
        }
        [self pickAutoScroll:0];
    }];
}
- (void)pickAutoScroll:(int)i
{
    NSLog(@"%d",i);
    if (i>_subviewsArray.count*2) {
        i = 0;
    }
    [_carousel scrollToItemAtIndex:i duration:0.07 completion:^{
        if (needStop&&i==integer) {
            _animation = NO;
            [_getcoinAudio stop];
            _completion();
        }else{
            [self pickAutoScroll:i+1];
        }
    }];
}
- (void)setNeedStop: (BOOL)stop
{
    needStop = stop;
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
- (void)soundPlay
{
    NSString * stringUrl3 = [[NSBundle mainBundle] pathForResource:@"shake_playing" ofType:@"wav"];
    NSURL * url3 = [NSURL fileURLWithPath:stringUrl3];
    self.getcoinAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:url3 error:nil];
    _getcoinAudio.delegate = self;
    [_getcoinAudio prepareToPlay];
    [_getcoinAudio play];
    [_getcoinAudio release];
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [_getcoinAudio play];
}
@end
