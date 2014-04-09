    //
//  SwitchTableViewCell.m
//  RuYiCai
//
//  Created by ruyicai on 09-3-30.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SwitchTableViewCell.h"


@implementation SwitchTableViewCell

@synthesize textView;
@synthesize switchView;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
	if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
		
		textView = [[UILabel alloc] initWithFrame:CGRectMake(14, 6, 60, 29)];
		textView.font = [UIFont systemFontOfSize:14];
		textView.backgroundColor = [UIColor clearColor];
		textView.textAlignment = UITextAlignmentRight;
		
		switchView = [[UISwitch alloc] initWithFrame:CGRectMake(200, 8, 230, 20)];
		[self.contentView addSubview:textView];
		[self.contentView addSubview:switchView];
		
	}
	return self;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)dealloc {
	[textView release];
	[switchView release];
    [super dealloc];
}


@end
