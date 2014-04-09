//
//  MyButton.h
//  TextClass
//
//  Created by bys adm on 5/17/12.
//  Copyright 2012 beijing. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyButton : UIButton {
    UILabel *upLabel;
    UILabel *downLabel;
    int width;
    int height;
    BOOL *m_isSelect;
}
@property(nonatomic,retain) UILabel *upLabel;
@property(nonatomic,retain) UILabel *downLabel;

@property(nonatomic,assign) BOOL isSelect;
-(void)setMyButton:(UIImage*)_Image  UPLABEL:(NSString*)upLabelText DOWNLABEL:(NSString *)downLabelText;
@end
