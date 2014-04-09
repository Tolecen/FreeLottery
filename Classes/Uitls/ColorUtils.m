//
//  ColorUtils.m
//  mapper_ios
//
//  Created by zhaoqing huang on 12-1-18.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "ColorUtils.h"


#define RGB_N(v) (v) / 255.0f

@implementation ColorUtils

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

//颜色列表
+(NSMutableDictionary *)colorDictionary{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:@"#FFCC00" forKey:@"1"];
    [dictionary setValue:@"#FF9900" forKey:@"2"];
    [dictionary setValue:@"#FF6600" forKey:@"3"];
    [dictionary setValue:@"#FF3300" forKey:@"4"];
    [dictionary setValue:@"#993300" forKey:@"5"];
    [dictionary setValue:@"#FF3333" forKey:@"6"];
    [dictionary setValue:@"#CC0000" forKey:@"7"];
    [dictionary setValue:@"#330000" forKey:@"8"];
    [dictionary setValue:@"#663300" forKey:@"9"];
    [dictionary setValue:@"#99CC00" forKey:@"10"];
    [dictionary setValue:@"#333300" forKey:@"11"];
    [dictionary setValue:@"#006600" forKey:@"12"];
    [dictionary setValue:@"#00FFCC" forKey:@"13"];
    [dictionary setValue:@"#3399FF" forKey:@"14"];
    [dictionary setValue:@"#0000FF" forKey:@"15"];
    [dictionary setValue:@"#000066" forKey:@"16"];
    [dictionary setValue:@"#00CC00" forKey:@"17"];
    [dictionary setValue:@"#CC00FF" forKey:@"18"];
    [dictionary setValue:@"#660099" forKey:@"19"];
    [dictionary setValue:@"#0033FF" forKey:@"20"];

    return dictionary;
}

+(UIColor *)getRandomColor:(CGFloat)alpha
{
    //0-255之间的随机数
//    CGFloat randomRed = ((arc4random() % 501 / 2) + (arc4random() % 5))/255.0f; 
//    CGFloat randomGreen = ((arc4random() % 501 / 2) + (arc4random() % 5))/255.0f; 
//    CGFloat randomBlue = ((arc4random() % 501 / 2) + (arc4random() % 5))/255.0f; 
//    NSLog(@"%f",randomRed);
//    NSLog(@"%f",randomGreen);
//    NSLog(@"!!!!!!!@%d",arc4random());
     
    //1－20之间的随即数
    NSInteger randomColor = arc4random() % 41 / 2 ;
//    NSLog(@"!!!!!!!@%d",randomColor);
    if(randomColor <= 0){
        randomColor = 1;
    }
    if (randomColor > 21) {
        randomColor = 20;
    }
    NSMutableDictionary *dictionary = [self colorDictionary];
    NSString *colorName = [dictionary objectForKey:[NSString stringWithFormat:@"%d",randomColor]];
//    NSLog(@"%@",colorName);
    
    
    
    UIColor *color = [self parseColorFromRGBA:colorName Alpha:alpha];
//    UIColor *color = [UIColor colorWithRed:((arc4random() % 255) /255.0f) green:((arc4random() % 255) /255.0f) blue:((arc4random() % 255) /255.0f) alpha:alpha];
    return color;
    
}

+ (UIColor *)parseColorFromRGB:(NSString *)rgb{
    return [ColorUtils parseColorFromRGBA:rgb Alpha:1];
}

+ (UIColor *)parseColorFromRGBA:(NSString *)rgb Alpha:(float)alpha{
    const char *string = [rgb UTF8String];
    
    if (!strncmp(string, "#", 1)) {
		const char *hexString = string + 1;
		
		if (strlen(hexString) != 6) {
			return [UIColor blackColor];
		}
        
		else {
			char r[3], g[3], b[3];
			r[2] = g[2] = b[2] = '\0';
			
			strncpy(r, hexString, 2);
			strncpy(g, hexString + 2, 2);
			strncpy(b, hexString + 4, 2);
			
            return [UIColor colorWithRed:RGB_N(strtol(r, NULL, 16))
                                   green:RGB_N(strtol(g, NULL, 16))
                                    blue:RGB_N(strtol(b, NULL, 16))
                                   alpha:((alpha>1 || alpha<0) ? 1 : alpha)];
		}
	}
    return [UIColor blackColor];
}

+ (void)setDefaultAppBackgroundColorForView:(UIView *) view{
    static UIImage *bgImage;
    if (!bgImage) {
        bgImage = [[UIImage imageNamed:@"app_bg.png"] retain];
    }
    UIImageView *bg = [[UIImageView alloc] initWithImage:bgImage];
    bg.frame = view.bounds;

    if ([view isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView*) view;
        tableView.backgroundView = bg;
    }
    else{
        [view insertSubview:bg atIndex:0];
    }
    [bg release];
}

@end
