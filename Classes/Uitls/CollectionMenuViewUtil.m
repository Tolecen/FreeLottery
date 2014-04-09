//
//  CollectionMenuViewUtil.m
//  Boyacai
//
//  Created by 纳木 那咔 on 13-4-22.
//
//

#import "CollectionMenuViewUtil.h"
#import "RYCImageNamed.h"
#import "ColorUtils.h"
#import "KSCutomerControl.h"

@interface CollectionMenuViewUtil ()
{
    NSArray *_nameArray;
    NSArray *_imagesArray;
    NSArray *_selectedimagesArray;
    
}

@property (nonatomic, retain) NSArray *nameArray;
@property (nonatomic, retain) NSArray *imagesArray;
@property (nonatomic, retain) NSArray *selectedimagesArray;
@end

@interface CollectionMenuViewUtil (private)

@end
@implementation CollectionMenuViewUtil
@synthesize delegate;
@synthesize nameArray = _nameArray;
@synthesize imagesArray = _imagesArray;
@synthesize selectedimagesArray = _selectedimagesArray;
@synthesize buttons = _buttons;

- (id)initWithFrame:(CGRect)frame withNameArray:(NSArray*)array
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _nameArray = [NSArray arrayWithArray:array];
        //背景事件
        UIButton *backGroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backGroundBtn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [backGroundBtn setBackgroundColor:[UIColor clearColor]];
        [backGroundBtn addTarget:self action:@selector(cancelMenu:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backGroundBtn];
        //设置按钮
        for (int i = 0; i<[_nameArray count]; i++) {
            UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            CGFloat butttonX = (i%3)*100 + 10.0f;
            CGFloat butttonY = (i/3)*38;
            
            menuButton.frame = CGRectMake(butttonX, butttonY, 100, 38);
            [menuButton setBackgroundImage:RYCImageNamed(@"menu_list_button_normal.png") forState:UIControlStateNormal];
            [menuButton setBackgroundImage:RYCImageNamed(@"menu_list_button_highlight.png") forState:UIControlStateHighlighted];
            [menuButton setTitle:[_nameArray objectAtIndex:i] forState:UIControlStateNormal];
            menuButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
            [menuButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
            [menuButton addTarget:self action:@selector(menuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [menuButton setTag:i];
            [self addSubview:menuButton];
            
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withTitles:(NSArray *)titles Images:(NSArray*)images selectedImages:(NSArray *)selectedImages
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.nameArray = [NSArray arrayWithArray:titles];
        self.imagesArray = [NSArray arrayWithArray:images];
        self.selectedimagesArray = [NSArray arrayWithArray:selectedImages];
        self.buttons = [NSMutableArray array];
        //背景事件
        UIButton *backGroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backGroundBtn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [backGroundBtn setBackgroundColor:[UIColor clearColor]];
        [backGroundBtn addTarget:self action:@selector(cancelMenu:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backGroundBtn];
        
        CGFloat backGroundViewHight = (([self.imagesArray count]-1)/3 + 1)*(71+17) + 10 ;
        UIView *backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, backGroundViewHight)];
        [backGroundView setBackgroundColor:[ColorUtils parseColorFromRGB:@"#004642"]];
        [self addSubview:backGroundView];
        
        [KSCutomerControl superView:backGroundView subViewColor:[ColorUtils parseColorFromRGB:@"#002321"] lineWith:2];
        
        //设置按钮
        for (int i = 0; i<[self.imagesArray count]; i++) {
            UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            CGFloat butttonX = (i%3)*(95+7) + 10 ;
            CGFloat butttonY = (i/3)*(71+17) + 15;
            if (i == 0) {
                menuButton.selected = YES;
            }else{
                menuButton.selected = NO;
            }
            
            menuButton.frame = CGRectMake(butttonX, butttonY, 95, 71);
            [menuButton setBackgroundImage:RYCImageNamed([self.imagesArray objectAtIndex:i]) forState:UIControlStateNormal];
            [menuButton setBackgroundImage:RYCImageNamed([self.selectedimagesArray objectAtIndex:i]) forState:UIControlStateHighlighted];
            [menuButton setBackgroundImage:RYCImageNamed([self.selectedimagesArray objectAtIndex:i]) forState:UIControlStateSelected];
            menuButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
            [menuButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
            [menuButton addTarget:self action:@selector(menuImageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [menuButton setTag:i];
            [self.buttons addObject:menuButton];
            [self addSubview:menuButton];
            
        }
    }
    return self;
}

-(IBAction)menuButtonAction:(id)sender{
    
    
    UIButton *btn = (UIButton *)sender;
    
    [self cancelMenu:sender];
    
    if (self.delegate  && [self.delegate respondsToSelector:@selector(menuButton:numberOfRowsInMenu:)]) {
        [self.delegate menuButton:btn numberOfRowsInMenu:btn.tag];
    }
}
-(IBAction)menuImageButtonAction:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    
    for (UIButton *oneButton in _buttons) {
        if (btn == oneButton) {
            oneButton.selected = YES;
        } else {
            oneButton.selected = NO;
        }
    }
    
    NSLog(@"menuImageButtonAction:%@",[self.nameArray objectAtIndex:btn.tag]);
    
    [self cancelMenu:sender];
    
    if (self.delegate  && [self.delegate respondsToSelector:@selector(menuButton:numberOfRowsInMenu:menuTitle:)]) {
        [self.delegate menuButton:btn numberOfRowsInMenu:btn.tag menuTitle:[self.nameArray objectAtIndex:btn.tag]];
    }
}

-(IBAction)cancelMenu:(id)sender{
    NSLog(@"cancelMenu");
    
    if (self.delegate  && [self.delegate respondsToSelector:@selector(cancelMenu)]) {
        [self.delegate cancelMenu];
    }
    
    
}
-(void)dealloc{
    
    [_nameArray release];
    [_selectedimagesArray release];
    [_imagesArray release];
    [super dealloc];
    
    
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
