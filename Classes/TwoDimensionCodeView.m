//
//  TwoDimensionCodeView.m
//  Boyacai
//
//  Created by wangxr on 14-6-9.
//
//

#import "TwoDimensionCodeView.h"
#import "UIWindow+YzdHUD.h"
@interface TwoDimensionCodeView ()<UIActionSheetDelegate>
{
//    BDKNotifyHUD* bdkHUD;
}
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
        image.userInteractionEnabled = YES;
        [whiteView addSubview:image];
        UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        [image addGestureRecognizer:longPress];
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
-(void)longPress:(UILongPressGestureRecognizer*)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        UIActionSheet* act = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: @"保存",nil];
        [act showInView:_viewC.view];
    }
}
#pragma mark - actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        UIImageWriteToSavedPhotosAlbum([UIImage imageNamed:@"TwoDimensionCode"], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    if(error != NULL){
        [self performSelector:@selector(showAud:) withObject:@"0" afterDelay:0.5];
    }else{
        [self performSelector:@selector(showAud:) withObject:@"1" afterDelay:0.5];
    }
}
-(void)showAud:(NSString *)uu
{
//    NSString * ui = @"";
    if ([uu isEqualToString:@"0"]) {
//        ui = @"保存失败，请允许访问您的相册";
        [self.window showHUDWithText:@"保存失败，请允许访问您的相册" Type:ShowPhotoNo Enabled:YES];
        
    }
    else
    {
//        ui = @"保存图片成功";
        [self.window showHUDWithText:@"保存图片成功" Type:ShowPhotoYes Enabled:YES];
        
    }
//    BDKNotifyHUD * bdkHUD = [BDKNotifyHUD notifyHUDWithImage:[UIImage imageNamed:@"Checkmark.png"] text:ui];
//    
//    
//    
//    bdkHUD.center = CGPointMake([UIApplication sharedApplication].keyWindow.center.x, [UIApplication sharedApplication].keyWindow.center.y - 20);
//    [[UIApplication sharedApplication].keyWindow addSubview:bdkHUD];
//    [bdkHUD presentWithDuration:0.8f speed:0.3f inView:nil completion:^{
//        [bdkHUD removeFromSuperview];
//    }];
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
