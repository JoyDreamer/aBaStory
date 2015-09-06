//
//  ABASPListUtility.h
//  aBaStory
//
//  Created by joyce on 15/7/7.
//
//

#ifndef aBaStory_ABASPListUtility_h
#define aBaStory_ABASPListUtility_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define ABASGetPListColor(key) \
    [ABASPListUtility getPListColor:key];

@interface ABASPListUtility : NSObject

+(UIColor*) getPListColor:(NSString*) key;

@end

#endif
