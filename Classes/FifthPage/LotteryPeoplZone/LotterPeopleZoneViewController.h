//
//  LotterPeopleZoneViewController.h
//  Boyacai
//
//  Created by 纳木 那咔 on 13-4-18.
//
//
#import "WXApi.h"
#import "RespForWeChatViewController.h"

#import <UIKit/UIKit.h>

@interface LotterPeopleZoneViewController:UIViewController<WXApiDelegate,RespForWeChatViewDelegate>
{
    enum WXScene _scene;
}


@end
