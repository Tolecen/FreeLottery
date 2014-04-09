//
//  WinNoView.h
//  RuYiCai
//
//  Created by LiTengjie on 11-9-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WinNoView : UIView {
    NSMutableArray* m_buttonsArray;
	UILabel *winNumLabel;
    
    UILabel* tryCodeLabel;
    UILabel* tryCodeBatchCodeLabel;
}

- (void)showWinNo:(NSString*)winNo ofType:(NSString*)type withTryCode:(NSString*)tryCode;

- (void)showFC3DWinNo:(NSString*)winNo ofType:(NSString*)type withTryCode:(NSString*)tryCode withTryCodeBatchCode:(NSString*)batchCode;

@end
