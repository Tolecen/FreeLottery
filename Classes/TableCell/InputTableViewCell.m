    //
//  InputTableViewCell.m
//  RuYiCai
//
//  Created by ruyicai on 09-3-30.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "InputTableViewCell.h"


@implementation InputTableViewCell

@synthesize text1;
@synthesize textField;

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
		
		text1 = [[UILabel alloc] initWithFrame:CGRectMake(14, 6, 60, 29)];
		text1.font = [UIFont systemFontOfSize:14];
		text1.backgroundColor = [UIColor clearColor];
		text1.textAlignment = UITextAlignmentRight;
		
		textField = [[UITextField alloc] initWithFrame:CGRectMake(84, 12, 216, 20)];
		textField.returnKeyType = UIReturnKeyDone;
		[textField addTarget:self action:@selector(closekeyboard) forControlEvents:UIControlEventEditingDidEndOnExit];
		textField.clearButtonMode = UITextFieldViewModeWhileEditing;
		textField.font = [UIFont systemFontOfSize:14];
		[self.contentView addSubview:text1];
		[self.contentView addSubview:textField];
		
	}
	return self;
}

- (void)closekeyboard{

	[textField resignFirstResponder];

}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
- (void)dealloc {
	[text1 release];
	[textField release];
    [super dealloc];
}


@end
