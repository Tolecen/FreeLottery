//
//  ADWallViewController.h
//  Boyacai
//
//  Created by Tolecen on 14-2-28.
//
//

#import <UIKit/UIKit.h>
#import <immobSDK/immobView.h>

#define LiMeiAdID     @"2ccba7d7614fbdc10c1c532c822205ca"
typedef enum _ADWallType {
	ADWallTypeLiMei = 0,
    ADWallTypeDuoMeng = 1
} ADWallType;
@interface ADWallViewController : UIViewController<immobViewDelegate>
{
     NSString * theUserID;
}
@property (assign) ADWallType adWallType;
@property (nonatomic,retain) UIButton * backBtn;

/**********力美********/
@property (nonatomic, retain)immobView *adView_adWall;
-(void)enterLiMeiAdWall;
-(void)QueryScore;
-(void)ReduceScore;
@end
