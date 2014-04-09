//
//  KS_PickNumberViewController.h
//  Boyacai
//
//  Created by 纳木 那咔 on 13-8-13.
//
//

#import <UIKit/UIKit.h>
#import "KS_PickNumberMainViewController.h"
#import "TitleViewButtonItemUtils.h"

typedef NSInteger controllerBePushFirstOrOther;
enum{
    first = 0,
    otherCount,
    selfSelectedNumber,
    changeSelectedNumber,
};

@class HXBX_KSBet_ViewController;
@class KSLotterysModel;

@interface KS_PickNumberViewController : UIViewController
{
    UIView *bottomView;
    TitleViewButtonItemUtils * titleMenuView;
}
@property (nonatomic, retain) KS_PickNumberMainViewController *ksPNVC;
@property (nonatomic,retain)NSMutableArray *lotterysArray;
@property (nonatomic) controllerBePushFirstOrOther controllerBePushFirstOrOtherType;
@property (nonatomic) PickNumType pickType;
@property (nonatomic,retain)HXBX_KSBet_ViewController * betViewController;
@property (nonatomic) controllerBePushFirstOrOther playType;

@property (nonatomic,retain) NSIndexPath * indexPath;
@property (nonatomic,assign) KSLotterysModel * lotterysModel;

-(void)setIndexPath:(NSIndexPath *)indexPath withKSLotterysModel:(KSLotterysModel *)lotterysModel;
-(void) changePlayGUI;

@end
