//
//  KSPlayingStyleSupperViewController.m
//  Boyacai
//
//  Created by 纳木 那咔 on 13-9-10.
//
//

#import "KSPlayingStyleSupperViewController.h"
#import "ColorUtils.h"
#import "RuYiCaiCommon.h"
#import "RNAssert.h"
#import "NSLog.h"



@interface KSPlayingStyleSupperViewController ()
{
    
}

@end

@implementation KSPlayingStyleSupperViewController
@synthesize chooseLotteryDelegate = _chooseLotteryDelegate;
@synthesize lotteryModelDic = _lotteryModelDic;
//@synthesize ksBettingModel = _ksBettingModel;

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
    NSLog(@"%@===",[self class]);
    
    self.lotteryModelDic = [NSMutableDictionary dictionary];
//    self.ksBettingModel = [KSBettingModel new];
    [self setupChooseLotterView];
    if([_chooseLotteryDelegate conformsToProtocol:@protocol(KSChooseLotteryDelegate)]){
        [_chooseLotteryDelegate performSelector:@selector(notifyObserverRemoveObjects)];
    }
    [self setupLotterMap];
    NSLog(@"%d....%d",((KSLotteryModel *)[self.lotteryModelDic objectForKey:@"3458"]).retainCount,self.lotteryModelDic.count);
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
//-(void)notifyLotteryHasChange:(KSLotterysModel *)ksLotterysModel{
//    if([_chooseLotteryDelegate conformsToProtocol:@protocol(KSChooseLotteryDelegate)]){
//        [_chooseLotteryDelegate performSelector:@selector(notifyObserverLotteryHasChange:) withObject:ksLotterysModel];
//    }
//}
//-(void)notifyCombinationLotteryHasChange:(KSLotterysModel *)ksLotterysModel{
//    if([_chooseLotteryDelegate conformsToProtocol:@protocol(KSChooseLotteryDelegate)]){
//        [_chooseLotteryDelegate performSelector:@selector(notifyObserverCombinationLotteryHasChange:) withObject:ksLotterysModel];
//    }
//}
-(void)notifyNoramlAndCombinationLotteryHasChange:(KSLotterysModel *)ksLotterysModel andKSBettingModel:(KSBettingModel *)ksBettingModel{
    if([_chooseLotteryDelegate conformsToProtocol:@protocol(KSChooseLotteryDelegate)]){
        [_chooseLotteryDelegate performSelector:@selector(notifyObserverNormalAndCombinationLotteryHasChange:andKSBettingModel:) withObject:ksLotterysModel withObject:ksBettingModel];
    }
}
-(void)notifyLotteryBasketHasChange:(KSBettingModel *)ksBettingModel{
    if([_chooseLotteryDelegate conformsToProtocol:@protocol(KSChooseLotteryDelegate)]){
        [_chooseLotteryDelegate performSelector:@selector(notifyLotteryBasketHasChange:) withObject:ksBettingModel];
    }
}
-(void)setupLotterMap{
    NSTrace();
}
-(void)setupChooseLotterView{
    NSTrace();
}
-(void)changeFrameByIsYiLou:(BOOL)yilou{
    NSTrace();
}


#pragma mark -KSBettingLotteryDelegate
-(void)bettingLotteryViewShowYiLou:(BOOL)isShow{
    NSTrace();
    [self changeFrameByIsYiLou:isShow];
}
#pragma mark -KSBettingLotteryDelegate 摇一摇实现
-(void)bettingLotteryViewMotionEnded{
    NSTrace();
    
}
#pragma mark -清空号码蓝 cleanUpLotteryBasket delegate
-(void)cleanUpLotteryBasket{
    NSTrace();
}

#pragma mark - 
#pragma mark -更新数据元 cleanUpLotteryBasket delegate
-(void)changeKsBetingModelData{
    NSTrace();
}

#pragma mark -
#pragma mark -处理遗漏值
- (void)getMissNumber:(NSString *)parserString{
    NSTrace();
}
@end
