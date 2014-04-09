//
//  JCLQ_PlayChooseViewCell.h
//  RuYiCai
//
//  Created by ruyicai on 12-4-26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
 
@class JCLQ_PickGameViewController;
@interface JCLQ_PlayChooseViewCell : UIView {
    NSString                                *m_SFTitle;
    NSString                                *m_LetPointTitle;
    NSString                                *m_SFCTitle;
    NSString                                *m_BigAndSmallTitle;
    NSString                                *m_SFTitle_DanGuan;
    NSString                                *m_LetPointTitle_DanGuan;
    NSString                                *m_SFCTitle_DanGuan;
    NSString                                *m_BigAndSmallTitle_DanGuan;
    NSString                                *m_hunheTitle;
    
    UIButton                                *m_SFButton;
    UIButton                                *m_LetPointButton;
    UIButton                                *m_SFCButton;
    UIButton                                *m_BigAndSmallButton;

    UIButton                                *m_hunheButton;
    
    UIButton                                *m_SFButton_DanGuan;
    UIButton                                *m_LetPointButton_DanGuan;
    UIButton                                *m_SFCButton_DanGuan;
    UIButton                                *m_BigAndSmallButton_DanGuan;
    
    int                                     m_PlayTypeTag;
    JCLQ_PickGameViewController            *m_parentController;
}
@property (nonatomic,retain) NSString* SFTitle;
@property (nonatomic,retain) NSString* LetPointTitle;
@property (nonatomic,retain) NSString* SFCTitle;
@property (nonatomic,retain) NSString* BigAndSmallTitle;

@property (nonatomic,retain) NSString* SFTitle_DanGuan;
@property (nonatomic,retain) NSString* LetPointTitle_DanGuan;
@property (nonatomic,retain) NSString* SFCTitle_DanGuan;
@property (nonatomic,retain) NSString* BigAndSmallTitle_DanGuan;
@property (nonatomic,retain) NSString* hunheTitle;
 

@property (nonatomic,retain) JCLQ_PickGameViewController* parentController;
@property (nonatomic,assign) int PlayTypeTag;

-(void) RefreshCellView;
@end
