//
//  TopAnimationView.m
//  Boyacai
//
//  Created by qiushi on 13-8-13.
//
//

#import "TopAnimationView.h"
#import "RuYiCaiCommon.h"
#import "ColorUtils.h"

//按钮间距
#define BTLOGHWIDTH 10
#define BTLOGHHEIGH 10

//按钮宽高

#define VIEWWIDTH  80
#define VIEWHEIGH  35


@interface TopAnimationView ()
{

        NSInteger _numberOfSegments;
        
}
@property (nonatomic, assign) NSInteger numberOfSegments;
@property (nonatomic, retain) NSArray *buttons;

@property (nonatomic, retain) NSArray *normalTitles;

@end

@implementation TopAnimationView

@synthesize normalTitles = _normalTitles;
@synthesize buttons      = _buttons;
@synthesize numberOfSegments;
@synthesize delegate = _delegate;


- (void)buttonTouchDown:(UIButton *)button
{
    for (UIButton *oneButton in _buttons)
    {
        if (oneButton.tag!=button.tag) {
            oneButton.selected = NO;
            [oneButton setBackgroundColor:[ColorUtils parseColorFromRGB:@"#efe4d5"]];
        }
    }
    button.selected = YES;
    [button setBackgroundColor:[ColorUtils parseColorFromRGB:@"#d52322"]];
    
}


- (void)buttonTouchUpInside:(UIButton *)button
{
    for (UIButton *oneButton in _buttons)
    {
        if (oneButton.tag!=button.tag) {
            oneButton.selected = NO;
            [oneButton setBackgroundColor:[ColorUtils parseColorFromRGB:@"#efe4d5"]];
        }
    }
    button.selected = YES;
    [button setBackgroundColor:[ColorUtils parseColorFromRGB:@"#d52322"]];
    if ([self.delegate respondsToSelector:@selector(topAnimationView: didSelectItemAtIndex:)]) {
        [self.delegate topAnimationView:self didSelectItemAtIndex:button.tag];
    }
    NSLog(@"button%d",button.tag);
}




- (void)dealloc
{
    [_normalTitles release];
    [_buttons release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andNormalTitles:(NSArray *)normalTitles{
    self = [super initWithFrame:frame];
    if (self) {
        self.normalTitles = normalTitles;
        self.numberOfSegments  = [normalTitles count];
    }
    return self;
}

- (void)setUpSegmentedImage{
    
  
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:_normalTitles.count];
    
    
    for (int i=0; i< self.numberOfSegments/3+1; i++)
    {
        for (int j= 0; j<3; j++)
        {
            if (i*3+j < self.numberOfSegments)
            {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(BTLOGHWIDTH*(j+1)+j*100, BTLOGHHEIGH*(i+1)+i*40, VIEWWIDTH, VIEWHEIGH);
            if (_normalTitles.count) {
                [btn setTitle:[_normalTitles objectAtIndex:(i*3+j)] forState:UIControlStateNormal];
            }
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [btn setBackgroundColor:[ColorUtils parseColorFromRGB:@"#efe4d5"]];
                
                
                
            [btn addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
                [btn addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
            
                btn.tag = (i*3+j+1);
                [self addSubview:btn];
             [buttons addObject:btn];
            
        }
        }
    }
       self.buttons = buttons;
    [buttons release];
    
}

- (void)thatButtonSelect:(int)index
{
    UIButton *seleBtn = (UIButton *)[self viewWithTag:index];
    seleBtn.selected = YES;
    
    
    for (UIButton *oneButton in _buttons)
    {
        if (oneButton.tag!=seleBtn.tag) {
            oneButton.selected = NO;
            [oneButton setBackgroundColor:[ColorUtils parseColorFromRGB:@"#efe4d5"]];
        }
    }
    [seleBtn setBackgroundColor:[ColorUtils parseColorFromRGB:@"#d52322"]];
}
- (void)willMoveToSuperview:(UIView *)newSuperview
{
        [self setUpSegmentedImage];
    
}



@end




