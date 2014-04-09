//
//  SwitchTableViewCell.h
//  RuYiCai
//
//  Created by ruyicai on 09-3-30.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SwitchTableViewCell : UITableViewCell {
	
	UILabel *textView;
	UISwitch *switchView;

}
@property (nonatomic,retain)UILabel *textView;
@property (nonatomic,retain)UISwitch *switchView;

@end
