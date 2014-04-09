//
//  InputTableViewCell.h
//  RuYiCai
//
//  Created by ruyicai on 09-3-30.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InputTableViewCell : UITableViewCell {
	
	UILabel *text1;
	UITextField *textField;

}

@property (nonatomic,retain)UILabel *text1;
@property (nonatomic,retain)UITextField *textField;

@end
