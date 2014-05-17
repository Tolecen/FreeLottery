//
//  AwardCardDetailViewController.h
//  Boyacai
//
//  Created by Tolecen on 14-5-15.
//
//

#import <UIKit/UIKit.h>
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"
#import "RuYiCaiNetworkManager.h"
@interface AwardCardDetailViewController : UIViewController
{
    UILabel * nameL;
    UILabel * timeL;
}
@property (retain,nonatomic) NSString * nameStr;
@property (retain,nonatomic) NSString * timeStr;
@property (retain,nonatomic) NSString * awardStr;
@property (retain,nonatomic) NSString * desStr;
@end
