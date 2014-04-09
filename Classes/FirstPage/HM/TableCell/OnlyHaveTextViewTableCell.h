//
//  OnlyHaveTextViewTableCell.h
//  RuYiCai
//
//  Created by  on 12-8-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnlyHaveTextViewTableCell : UITableViewCell
{
    UITextView  *textView;
    
}

@property(nonatomic, retain) NSString*    textString;

- (void)refreshCell;

@end
