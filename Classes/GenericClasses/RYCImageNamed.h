//
//  RYCImageNamed.h
//  RuYiCai
//
//  Created by LiTengjie on 11-8-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kWangWeiKey  @"WangWei"
#define kQianWeiKey  @"QianWei"
#define kBaiWeiKey   @"BaiWei"

#if __cplusplus
extern "C" {
#endif
    
    UIImage* RYCImageNamed(NSString* name);
    double lnChoose(int n, int m);
    int RYCChoose(int m, int n);
    int NumberOfDirectSum(NSArray* indexArray);
    int NumberOfGroup3Sum(NSArray* indexArray);
    int NumberOfGroup6Sum(NSArray* indexArray);
	int NumberOf2XingSum(NSArray* indexArray);

    UIImageView*  tableBgImage(CGRect topFrame, CGRect middleFrame, CGRect lineFrame);
    
    int numZhuZhiWithDic(NSDictionary* tempDic);

#if __cplusplus
}
#endif