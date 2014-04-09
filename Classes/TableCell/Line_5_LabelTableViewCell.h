//
//  Line_5_LabelTableViewCell.h
//  RuYiCai
//
//  Created by ruyicai on 09-4-6.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Line_5_LabelTableViewCell : UITableViewCell {
	
	UILabel *text1;
	UILabel *text2;
	UILabel *text3;
	UILabel *text4;
	UILabel *text5;

}

@property (nonatomic,retain)IBOutlet UILabel *text1;
@property (nonatomic,retain)IBOutlet UILabel *text2;
@property (nonatomic,retain)IBOutlet UILabel *text3;
@property (nonatomic,retain)IBOutlet UILabel *text4;
@property (nonatomic,retain)IBOutlet UILabel *text5;

@end
