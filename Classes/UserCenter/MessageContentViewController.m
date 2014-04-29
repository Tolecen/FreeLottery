//
//  MessageContentViewController.m
//  Boyacai
//
//  Created by wangxr on 14-4-29.
//
//

#import "MessageContentViewController.h"
#import "AdaptationUtils.h"
#import "RuYiCaiNetworkManager.h"
@interface MessageContentViewController ()
@property (nonatomic,retain)UITextView * textView;
@end

@implementation MessageContentViewController
- (void)dealloc
{
    [_messageId release];
    [_textView release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    self.textView = [[UITextView alloc]initWithFrame:self.view.frame];
    _textView.editable = NO;
    _textView.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:_textView];
    if ([_messageId intValue] == 0) {
        _textView.text = @"新版本在老版本的基础上修改了一些页面，对账户体系进行了升级，同事增加了很多有趣的活动，给你更多赚豆机会。如你在使用新版过程中有什么建议和意见，请告诉我们。我们的联系方式:\n电话：400-856-1000   \nQQ：2492831607";
    }else
    {
        [[RuYiCaiNetworkManager sharedManager] getMessageDetailWithID:_messageId];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessageDetailOK:) name:@"WXRGetMessageDetailOK" object:nil];
    }
    
}
- (void)getMessageDetailOK:(NSNotification*)notification
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
