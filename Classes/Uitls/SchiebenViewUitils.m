//
//  SchiebenViewUitils.m
//  Boyacai
//
//  Created by qiushi on 13-5-9.
//
//

#import "SchiebenViewUitils.h"


@implementation SchiebenViewUitils
@synthesize titiles = m_titiles;
@synthesize delegate = _delegate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles andFontSize:(CGFloat)fontSize
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.titiles = titles;
        
        redTag = 0;
        self.bounds = CGRectMake(0, 0, 320, 40);
        UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
        topImageView.image = [UIImage imageNamed:@"scroller_Bg_Button.png"];
        
        [self addSubview:topImageView];
        
        UIImageView *bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 35, 320, 5)];
        bottomImageView.image = [UIImage imageNamed:@"red_bg_down.png"];
        [self addSubview:bottomImageView];
        
        UIImageView *redBottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 35, 320/[self.titiles count], 5)];
        redBottomImageView.image = [UIImage imageNamed:@"red_bg_up.png"];
        redBottomImageView.tag = 1010;
        [self addSubview:redBottomImageView];
        
        //根据标题数组动态创建按钮
        for (int i =0; i<[self.titiles count]; i++)
        {
            UIButton *btn = [[UIButton alloc] init];
            btn.frame = CGRectMake(i*320/[self.titiles count], 0, 320/[self.titiles count], 35);
            btn.tag = 100+i;
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:fontSize] ;
            [btn setTitle:[self.titiles objectAtIndex:i] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            if (btn.tag ==100+redTag)
            {
                [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }else
            {
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            
        }
        
    }
    return self;
}
- (void)topBtnClick:(id)sender
{
    
    UIButton *currentBtn = (UIButton *)sender;
    int j = currentBtn.tag-100;
    //    UIButton *vorherBtn =(UIButton *)[self viewWithTag:(redTag+100)];
    //    UIImageView *redBottomImageView = (UIImageView *)[self viewWithTag:1010];
    //那个按钮被点击了，代理出去
    [self.delegate schiebenSegmentedControl:self didSelectItemAtIndex:j];
    
    //被点击原来变红，原来的变黑色
    //    if (redTag != j)
    //    {
    //        redTag = j;
    //
    //        [vorherBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //        [currentBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    //        [UIView beginAnimations:nil context:nil];
    //        [UIView setAnimationDuration:.3];
    //        redBottomImageView.frame =CGRectMake(currentBtn.frame.origin.x, 35, currentBtn.frame.size.width, 5);
    //        [UIView commitAnimations];
    //
    //    }
    
    
    
    
}

-(void)gotoPage:(NSInteger)index AddAnimation:(BOOL)type{
    UIButton *currentBtn = (UIButton *)[self viewWithTag:(index+100)];
    UIButton *vorherBtn =(UIButton *)[self viewWithTag:(redTag+100)];
    UIImageView *redBottomImageView = (UIImageView *)[self viewWithTag:1010];
    
    //被点击原来变红，原来的变黑色
    if (redTag != index)
    {
        redTag = index;
        
        [vorherBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [currentBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.2];
        redBottomImageView.frame =CGRectMake(currentBtn.frame.origin.x, 35, currentBtn.frame.size.width, 5);
        [UIView commitAnimations];
        
    }
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
