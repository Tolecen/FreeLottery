//
//  UnionPayViewController.h
//  RuYiCai
//
//  Created by  on 12-4-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "LTInterface.h"

@interface UnionPayViewController : UIViewController
//@interface UnionPayViewController : UIViewController
{
    UITextField*        m_amountTextField;
}

@property(nonatomic, retain) UITextField *amountTextField;

@property(nonatomic, retain) NSString * lotNo;

@end
