//
//  OnlyHaveTextViewTableCell.m
//  RuYiCai
//
//  Created by  on 12-8-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OnlyHaveTextViewTableCell.h"

@implementation OnlyHaveTextViewTableCell

@synthesize textString;

- (void)dealloc
{
    [textView release];
    
    [super dealloc];  
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 2, 292, 116)];
        textView.textColor = [UIColor blackColor];
        textView.backgroundColor = [UIColor clearColor];
        textView.font = [UIFont systemFontOfSize:15.0f];
        textView.editable = NO;
        [self addSubview:textView];
        
        self.textString = @"";
    }
    return self;
}

- (void)refreshCell
{
    textView.text = self.textString;
}

@end
