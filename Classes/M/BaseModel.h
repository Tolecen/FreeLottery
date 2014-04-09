//
//  BaseModel.h
//  Boyacai
//
//  Created by 纳木 那咔 on 13-9-3.
//
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject <NSCoding, NSCopying, NSMutableCopying> {
    
}

-(id) initWithDictionary:(NSDictionary *)dictionaryObject;

@end
