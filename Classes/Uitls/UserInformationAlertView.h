//
//  UserInformationAlertView.h
//  Boyacai
//
//  Created by qiushi on 13-5-13.
//
//
#import <UIKit/UIKit.h>

@protocol UserInformationAlertViewDelegate <NSObject>

@optional
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex save2File:(BOOL) save2File save2Album:(BOOL) save2Album;
@end


@interface UserInformationAlertView : UIAlertView

@property(nonatomic, assign) id<UserInformationAlertViewDelegate> userAlertDelegate;
@property(readwrite, retain) UIImage    *contentImage;
@property(nonatomic, retain) UILabel    *nameLable;
@property(nonatomic, retain) UILabel    *ceridLable;
@property(nonatomic, retain) NSString    *nameStr;
@property(nonatomic, retain) NSString    *ceridStr;


- (id)initWithImage:(UIImage *)image contentImage:(UIImage *)content;

@end