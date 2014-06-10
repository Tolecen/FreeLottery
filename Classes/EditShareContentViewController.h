//
//  EditShareContentViewController.h
//  PetGroup
//
//  Created by wangxr on 13-12-19.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  enum
{
    shareStyleSineWeiBo = 1,
    shareStyleTencentWeiBo,
    shareStylerenren
}shareStyle;
@protocol EditShareContentViewControllerDelegate <NSObject>
-(void)shareContentSuccess;
@end
@interface EditShareContentViewController : UIViewController
@property (nonatomic,retain)NSString* contentString;
@property (nonatomic,retain)NSString* url;
@property (nonatomic,assign)id<EditShareContentViewControllerDelegate>delegate;
@property (nonatomic,assign)shareStyle shareStyle;
@end
