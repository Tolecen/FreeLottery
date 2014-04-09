//
//  JC_MyButton.h
//  Boyacai
//
//  Created by qiushi on 13-8-19.
//
//

#import <UIKit/UIKit.h>
@interface JC_MyButton : UIButton {
    UILabel *downLabel;
    int width;
    int height;
    BOOL *m_isSelect;
}
@property(nonatomic,retain) UILabel *downLabel;

@property(nonatomic,assign) BOOL isSelect;
-(void)setMyButton:(UIImage*)_Image  UPLABEL:(NSString*)upLabelText DOWNLABEL:(NSString *)downLabelText;
@end