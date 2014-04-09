    //
//  Line_5_LabelTableViewCell.m
//  RuYiCai
//
//  Created by ruyicai on 09-4-6.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Line_5_LabelTableViewCell.h"


@implementation Line_5_LabelTableViewCell

@synthesize text1;
@synthesize text2;
@synthesize text3;
@synthesize text4;
@synthesize text5;

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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
	
	if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
		
		text1 = [[UILabel alloc] initWithFrame:CGRectMake(7, 6, 320, 15)];
		text1.font = [UIFont systemFontOfSize:14];
        text1.text = @"彩票编号:";
		
		text2 = [[UILabel alloc] initWithFrame:CGRectMake(7, 23, 320, 15)];
		text2.font = [UIFont systemFontOfSize:14];
		text2.text = @"彩票编号:";
		
		text3 = [[UILabel alloc] initWithFrame:CGRectMake(7, 40, 320, 15)];
		text3.font = [UIFont systemFontOfSize:14];
		text3.text = @"彩票编号:";
		
		text4 = [[UILabel alloc] initWithFrame:CGRectMake(7, 57, 320, 15)];
		text4.font = [UIFont systemFontOfSize:14];
		text4.text = @"彩票编号:";
		
		text5 = [[UILabel alloc] initWithFrame:CGRectMake(7, 74, 320, 15)];
		text5.font = [UIFont systemFontOfSize:14];
		text5.text = @"彩票编号:";
		
		[self.contentView addSubview:text1];
		[self.contentView addSubview:text2];
		[self.contentView addSubview:text3];
		[self.contentView addSubview:text4];
		[self.contentView addSubview:text5];
		
	}
	return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

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

//- (void)didReceiveMemoryWarning {
//    // Releases the view if it doesn't have a superview.
//    [super didReceiveMemoryWarning];
//    
//    // Release any cached data, images, etc. that aren't in use.
//}
//
//- (void)viewDidUnload {
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//    // e.g. self.myOutlet = nil;
//}


- (void)dealloc {
    [super dealloc];
	[text1 release];
	[text2 release];
	[text3 release];
	[text4 release];
	[text5 release];
}


@end
