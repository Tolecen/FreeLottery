//
//  UIPageControl+NomalStyle.m
//  Boyacai
//
//  Created by 纳木 那咔 on 13-4-16.
//
//

#import "UIPageControl+NormalStyle.h"


@implementation UIPageControl (NormalStyle)

- (void)drawRect:(CGRect)rect {
	int i;
	for(i=0;i<self.numberOfPages;i++) {
		
		UIImageView *pageIcon = [self.subviews objectAtIndex:i];
		
		/* check for class type, in case of upcomming OS changes */
		if([pageIcon isKindOfClass:[UIImageView class]]) {
			
            if(i==self.currentPage) {
				/* use the active image */
				pageIcon.image = [UIImage imageNamed: @"page_style_small_hight.png"];
			}
			else {
				/* use the inactive image */
                
				pageIcon.image = [UIImage imageNamed: @"page_style_small_gray.png"];
			}
		}
	}
}

/* you can alternatively add a methode swizzling, but i better not add the hackish code in case of a bad apple reviewer */
static int Spage = -1;
- (void)setCurrentPageBypass:(NSInteger)aPage {
    if (Spage != aPage) {
        Spage = aPage;
        [self setCurrentPage:aPage];
        [self setNeedsDisplay];
    }
	
}

- (NSInteger)currentPageBypass {
	return self.currentPage;
}


@end
