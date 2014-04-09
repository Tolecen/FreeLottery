//
//  UIButtonEx.m
//  Boyacai
//
//  Created by 纳木 那咔 on 13-9-3.
//
//

#import "UIButtonEx.h"

@interface UIButtonEx ()
{
    id exTarget;
    SEL exAction;
}

@end
@implementation UIButtonEx

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setSelected:(BOOL)n{

    if (n != self.selected) {
        if ([exTarget respondsToSelector:exAction]) {
            [exTarget performSelector:exAction withObject:self];
        }
    }
    [super setSelected:n];
}

-(void)setTargetWhenSelectedChange:(id)target action:(SEL)action{
    exTarget = target;
    exAction =action;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
