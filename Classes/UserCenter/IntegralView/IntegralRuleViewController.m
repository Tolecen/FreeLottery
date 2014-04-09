//
//  IntegralRuleViewController.m
//  RuYiCai
//
//  Created by haojie on 12-10-25.
//
//

#import "IntegralRuleViewController.h"
#import "RuYiCaiNetworkManager.h"
#import "AdaptationUtils.h"

@interface IntegralRuleViewController ()

@end

@implementation IntegralRuleViewController

@synthesize requestDic;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"querySampleNetOK" object:nil];
    
    [requestDic release], requestDic = nil;
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
    [AdaptationUtils adaptation:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(querySampleNetOK:) name:@"querySampleNetOK" object:nil];
    
    requestDic = [[NSMutableDictionary alloc] initWithCapacity:1];
    
//    NSMutableDictionary*  tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
//    [tempDic setObject:@"information" forKey:@"command"];
//    [tempDic setObject:@"scoreRule" forKey:@"newsType"];
//    
}

- (void)requestDate
{
    [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_BASE;
    [[RuYiCaiNetworkManager sharedManager] querySampleLotNetRequest:requestDic isShowProgress:YES];
}

- (void)querySampleNetOK:(NSNotification*)notification
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[CommonRecordStatus commonRecordStatusManager].sampleNetStr];
    [jsonParser release];
    
    NSString* content = [parserDict objectForKey:@"content"];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 70)];
    textView.text = content;
    textView.editable = NO;
    [textView setTextColor:[UIColor blackColor]];
    [textView setFont:[UIFont systemFontOfSize:14]];
    [textView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:textView];
    [textView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
