//
//  NSString+Additions.m
//  Boyacai
//
//  Created by qiushi on 13-3-29.
//
//

#import "NSString+Additions.h"

@implementation NSString(Additions)
//判断是否为汉字
+ (BOOL)containOtherString:(NSString *)aString
{
    for(int i=0; i< [aString length];i++){
        int a = [aString characterAtIndex:i];
        if( a <= 0x4e00 || a >= 0x9fff)
        {
            
            return YES;

        }
    }
    
    return NO;
}

-(BOOL)containString:(NSString *)aString
{
    return ([self rangeOfString:aString].location != NSNotFound );
}

//-(BOOL)containStringIsnull:(NSString *)aString
//{
//    return ([self rangeOfString:aString].location != NSNotFound );
//}

@end
