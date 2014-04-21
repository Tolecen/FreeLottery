//
//  TitleViewButtonItemUtils.m
//  Boyacai
//
//  Created by 纳木 那咔 on 13-4-22.
//
//

#import "TitleViewButtonItemUtils.h"
#import "CollectionMenuViewUtil.h"
#import "ColorUtils.h"


@interface TitleViewButtonItemUtils ()<CollectionMenuViewUtilDelegate>

@property (nonatomic, retain) UIImageView *triangleTagImgView;
@property (nonatomic, retain) UILabel *titleLable;

@end

@interface TitleViewButtonItemUtils (private)
-(CGSize)getFontSize:(NSString *)content;//更具字体大小计算宽度

@end

@implementation TitleViewButtonItemUtils
@synthesize openMenu;
@synthesize triangleTagImgView;
@synthesize menuView = _menuView;
@synthesize titleLable = _titleLable;
@synthesize delegate = _delegate;

-(void)dealloc{
    [triangleTagImgView release];
    [_menuView release];
    [_titleLable release];
    [super dealloc];
}

-(CGSize)getFontSize:(NSString *)content{
    CGSize size7 = CGSizeZero; //初始化size7
    NSString *label7String = content;
    
    UIFont *font = [UIFont boldSystemFontOfSize:20]; //指定字符串的大小
    CGSize titleSize = [label7String sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, 44)]; //获取字符串的实际大小
    size7 = titleSize;//保存字符串的大小（也就是label的大小）用来指定相邻的label8的位置
    return size7;
}

- (id) initWithDelfaultTitleViewForUIViewController:(UIViewController *) viewController menuTitle:(NSArray*)array delegate:(id)delegate{
    
    self = [super initWithFrame:CGRectMake(0, 0, 160, 44)];
    if (self) {
        
        
        
        
        self.menuView = [[[CollectionMenuViewUtil alloc]initWithFrame:CGRectMake(0, 64, 320, [UIScreen mainScreen].bounds.size.height) withNameArray:array]autorelease];
        [self.menuView setBackgroundColor:[UIColor clearColor]];
        self.menuView.delegate = self;
        
        CGSize size = [self getFontSize:[array objectAtIndex:0]];
        UIButton *groupButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat LabelX = (self.frame.size.width - size.width)/2;
        self.titleLable = [[UILabel alloc]initWithFrame:CGRectMake(LabelX, 0, size.width  ,44)];
        self.titleLable.text = [array objectAtIndex:0];
        UIFont *font = [UIFont boldSystemFontOfSize: 20.0f];
        self.titleLable.font = font;
        [self.titleLable setTextAlignment:UITextAlignmentCenter];
        [self.titleLable setShadowColor:[UIColor darkGrayColor]];
        [self.titleLable setShadowOffset:CGSizeMake(0 , -1)];
        [self.titleLable setTextColor:[UIColor whiteColor]];
        [self.titleLable setBackgroundColor:[UIColor clearColor]];
        [groupButton addSubview:_titleLable];
        
        openMenu = NO;//默认为关闭
        
        UIImage *triangleTagImg = [UIImage imageNamed:@"button_down_triangle1.png"];
        CGFloat triangleTagImgX = self.titleLable.frame.origin.x + self.titleLable.frame.size.width + 5.0f;
        CGFloat triangleTagImgY = (self.frame.size.height - triangleTagImg.size.height)/2 + 3.0f;
        self.triangleTagImgView = [[[UIImageView alloc]initWithFrame:CGRectMake(triangleTagImgX, triangleTagImgY, triangleTagImg.size.width/2, triangleTagImg.size.height/2)]autorelease];
        [self.triangleTagImgView setImage:triangleTagImg];
        [groupButton addSubview:self.triangleTagImgView];
        
        groupButton.frame = CGRectMake(0, 0, 300, 44);
        [groupButton addTarget:self action:@selector(changeMenuView) forControlEvents:UIControlEventTouchUpInside];
        [self setBackgroundColor:[UIColor clearColor]];
        [self addSubview:groupButton];
        self.delegate = delegate;
    }
    return self;
    
}


- (id) initWithDelfaultTitleViewForUIViewController:(UIViewController *) viewController menuTitles:(NSArray*)titles menuImages:(NSArray*)menuImages  menuSelectedImages:(NSArray*)selectedImages delegate:(id)delegate{
    
    self = [super initWithFrame:CGRectMake(0, 0, 160, 44)];
    if (self) {
        
        self.menuView = [[CollectionMenuViewUtil alloc]initWithFrame:CGRectMake(0, 64, 320, [UIScreen mainScreen].bounds.size.height) withTitles:titles Images:menuImages selectedImages:selectedImages];
        [self.menuView setBackgroundColor:[UIColor clearColor]];
        self.menuView.delegate = self;
        
        UIButton *groupButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        
        CGSize size = [self getFontSize:[titles objectAtIndex:0]];
        
        CGFloat LabelX = (self.frame.size.width - size.width)/2;
        self.titleLable = [[UILabel alloc]initWithFrame:CGRectMake(LabelX, 0, size.width  ,44)];
        self.titleLable.text = [titles objectAtIndex:0];
        UIFont *font = [UIFont boldSystemFontOfSize: 20.0f];
        self.titleLable.font = font;
        [self.titleLable setTextAlignment:UITextAlignmentCenter];
        [self.titleLable setShadowColor:[UIColor darkGrayColor]];
        [self.titleLable setShadowOffset:CGSizeMake(0 , -1)];
        [self.titleLable setTextColor:[ColorUtils parseColorFromRGB:@"#fcdcdc"]];
        [self.titleLable setBackgroundColor:[UIColor clearColor]];
        [groupButton addSubview:_titleLable];
        
        openMenu = NO;//默认为关闭
        
        UIImage *triangleTagImg = [UIImage imageNamed:@"button_down_triangle1.png"];
        CGFloat triangleTagImgX = self.titleLable.frame.origin.x + self.titleLable.frame.size.width + 5.0f;
        CGFloat triangleTagImgY = (self.frame.size.height - triangleTagImg.size.height)/2 + 3.0f;
        self.triangleTagImgView = [[[UIImageView alloc]initWithFrame:CGRectMake(triangleTagImgX, triangleTagImgY, triangleTagImg.size.width/2, triangleTagImg.size.height/2)]autorelease];
        [self.triangleTagImgView setImage:triangleTagImg];
        [groupButton addSubview:self.triangleTagImgView];
        
        groupButton.frame = CGRectMake(0, 0, 300, 44);
        [groupButton addTarget:self action:@selector(changeMenuView) forControlEvents:UIControlEventTouchUpInside];
        [self setBackgroundColor:[UIColor clearColor]];
        [self addSubview:groupButton];
        self.delegate = delegate;
    }
    return self;
    
}

+(void)addTitleViewForController:(UIViewController *)controller menuTitle:(NSArray*)array delegate:(id)delegate{
    if (controller) {
        TitleViewButtonItemUtils *costomView = [[TitleViewButtonItemUtils alloc] initWithDelfaultTitleViewForUIViewController:controller menuTitle:(NSArray*)array delegate:delegate];
        controller.navigationItem.titleView = costomView;
        
    }
}

+(void)addTitleViewForController:(UIViewController *)controller menuTitles:(NSArray*)titles menuImages:(NSArray*)menuImages  menuSelectedImages:(NSArray*)selectedImages delegate:(id)delegate{
    if (controller) {
        
        TitleViewButtonItemUtils *costomView =[[[TitleViewButtonItemUtils alloc] initWithDelfaultTitleViewForUIViewController:controller menuTitles:titles menuImages:menuImages menuSelectedImages:selectedImages delegate:delegate]autorelease];
        
        controller.navigationItem.titleView = costomView;
        
        
    }
}


+(TitleViewButtonItemUtils *)addTitleMenuViewForController:(UIViewController *)controller menuTitles:(NSArray*)titles menuImages:(NSArray*)menuImages  menuSelectedImages:(NSArray*)selectedImages delegate:(id)delegate{
    
    TitleViewButtonItemUtils *costomView =[[[TitleViewButtonItemUtils alloc] initWithDelfaultTitleViewForUIViewController:controller menuTitles:titles menuImages:menuImages menuSelectedImages:selectedImages delegate:delegate]autorelease];
        
    controller.navigationItem.titleView = costomView;
        
    return costomView;
}



+(void)addTitleViewForController:(UIViewController *)controller title:(NSString *)title font:(UIFont *)font textColor:(UIColor *)color{
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    label.text = title;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = color;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = font;
    controller.navigationItem.titleView = label;
    [label release];
}



-(void)changeMenuView{
    if (openMenu) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancelMenu" object:nil];
        [self.menuView removeFromSuperview];
        [self.triangleTagImgView setImage:[UIImage imageNamed:@"button_down_triangle1.png"]];
        openMenu = NO;
        
    }else{
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelMenu) name:@"cancelMenu" object:nil];
        [[[UIApplication sharedApplication] keyWindow] addSubview:self.menuView];
        [self.triangleTagImgView setImage:[UIImage imageNamed:@"button_up_triangle.png"]];
        openMenu = YES;
        
    }
}

#pragma mark -CollectionMenuViewUtilDelegate
-(void)menuButton:(UIButton *)button numberOfRowsInMenu:(NSInteger)num{
    
    NSLog(@"%d",num);
    CGSize size = [self getFontSize:button.titleLabel.text];
    CGFloat LabelX = (self.frame.size.width - size.width)/2;
    self.titleLable.frame =CGRectMake(LabelX, 0, size.width,44);
    self.titleLable.text = button.titleLabel.text;
    
    UIImage *triangleTagImg = [UIImage imageNamed:@"button_down_triangle1.png"];
    CGFloat triangleTagImgX = self.titleLable.frame.origin.x + self.titleLable.frame.size.width + 5.0f;
    CGFloat triangleTagImgY = (self.frame.size.height - triangleTagImg.size.height)/2 + 3.0f;
    self.triangleTagImgView.frame = CGRectMake(triangleTagImgX, triangleTagImgY, triangleTagImg.size.width/2, triangleTagImg.size.height/2);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(menuNumberOfRowsInMenu:)]) {
        [self.delegate menuNumberOfRowsInMenu:num];
    }
    
}
-(void)menuButton:(UIButton *)button numberOfRowsInMenu:(NSInteger)num menuTitle:(NSString *)title{
    NSLog(@"%d",num);
    CGSize size = [self getFontSize:title];
    CGFloat LabelX = (self.frame.size.width - size.width)/2;
    self.titleLable.frame =CGRectMake(LabelX, 0, size.width,44);
    self.titleLable.text = [NSString stringWithFormat:@"%@",title];
    
    UIImage *triangleTagImg = [UIImage imageNamed:@"button_down_triangle1.png"];
    CGFloat triangleTagImgX = self.titleLable.frame.origin.x + self.titleLable.frame.size.width + 5.0f;
    CGFloat triangleTagImgY = (self.frame.size.height - triangleTagImg.size.height)/2 + 3.0f;
    self.triangleTagImgView.frame = CGRectMake(triangleTagImgX, triangleTagImgY, triangleTagImg.size.width/2, triangleTagImg.size.height/2);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(menuNumberOfRowsInMenu:)]) {
        [self.delegate menuNumberOfRowsInMenu:num];
    }
}
-(void)cancelMenu{
    if (openMenu) {
        [self changeMenuView];
    }
    
}

+(void)shutDownMenu{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelMenu" object:nil];
}
@end
