//
//  ADIntroduceViewController.h
//  Boyacai
//
//  Created by Tolecen on 14-3-7.
//
//

#import <UIKit/UIKit.h>
#import "AdaptationUtils.h"
#import "UINavigationBarCustomBg.h"
#import "BackBarButtonItemUtils.h"
typedef enum _TextType {
	TextTypeAdIntro = 0,
    TextTypeCommonQuestion = 1,
    TextTypeAdwallImportantInfo = 2,
    TextTypeShaiZiRule
} TextType;
@interface ADIntroduceViewController : UIViewController
@property (assign) TextType theTextType;
@property (assign,nonatomic) BOOL shouldShowTabbar;
@end
