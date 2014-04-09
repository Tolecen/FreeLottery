//
//  AnimationTabView.h
//  RuYiCai
//
//  Created by  on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimationTabView : UIView
{
    UIImageView*                m_backImage_white;
    int                         m_selectButtonTag;
    
    NSMutableArray*                    m_buttonNameArray;
}

@property(nonatomic, assign) int           selectButtonTag;
@property(nonatomic, retain) UIImageView*  backImage_white;
@property(nonatomic, retain) NSMutableArray*      buttonNameArray;

- (void)setMainButton;
- (void) changeImage;
- (void) buttonSelect:(id)sender;

@end
