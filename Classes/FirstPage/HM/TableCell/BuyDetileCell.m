//
//  BuyDetileCell.m
//  RuYiCai
//
//  Created by qiushi on 13-1-23.
//
//

#import "BuyDetileCell.h"
#import "ColorUtils.h"

@implementation BuyDetileCell
@synthesize buyTextFiled = m_buyTextFiled;
@synthesize comBottomFiled = m_comBottomFiled;
@synthesize priceLable     = m_priceLable;
@synthesize bestlitLable   =m_bestlitLable;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}


- (void)dealloc
{
    [m_bestlitLable release];
    [m_buyTextFiled release];
    [m_priceLable release];
    [m_comBottomFiled release];
    [super dealloc];
}


@end
