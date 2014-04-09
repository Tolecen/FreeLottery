//
//  RYCProcessView.h
//  RuYiCai
//
//  Created by LiTengjie on 11-8-7.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface RYCProcessView : UIAlertView {
	ASIHTTPRequest *m_request;
}

@property (nonatomic, retain) ASIHTTPRequest *request;

- (void)cancel;

@end
