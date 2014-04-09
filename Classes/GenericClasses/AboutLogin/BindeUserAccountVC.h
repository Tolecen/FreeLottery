//
//  BindeUserAccountVC.h
//  Boyacai
//
//  Created by qiushi on 13-11-13.
//
//

#import <UIKit/UIKit.h>
#import "CustomColorButtonUtils.h"

@interface BindeUserAccountVC : UIViewController<UITextFieldDelegate>


@property (nonatomic, retain) CustomColorButtonUtils *bindUseButton;
@property (nonatomic, retain) IBOutlet UIButton    *alreadyButton;
@property (nonatomic, retain) IBOutlet UIButton    *noAlreadyButton;
@property (nonatomic, retain) IBOutlet UIView      *loginUserView;
@property (nonatomic, retain) IBOutlet UITextField *alreadyNameTextField;
@property (nonatomic, retain) IBOutlet UITextField *alreadyPsdTextField;
@property (nonatomic, retain) IBOutlet UIView      *registerUserView;

@property (nonatomic, retain) IBOutlet UITextField *registerNameTextField;
@property (nonatomic, retain) IBOutlet UITextField *registerPsdTextField;
@property (nonatomic, retain) IBOutlet UITextField *surePsdTextField;

@property (nonatomic, retain) IBOutlet UIView      *layoutView;
- (IBAction)alreadyButtonClick:(id)sender;
- (IBAction)noAlreadyButtonClick:(id)sender;

@end
