//
//  ABASPListUtility.m
//  aBaStory
//
//  Created by joyce on 15/7/7.
//
//

#import "ABASPListUtility.h"

@implementation ABASPListUtility

+(UIColor*) getPListColor:(NSString*) key
{
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"kameilaConfig" ofType:@"plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        plistPath = [[NSBundle mainBundle] pathForResource:@"kameilaConfig" ofType:@"plist"];
    }
    NSDictionary* root = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSDictionary* rgba = [root objectForKey:key];
    NSNumber* red = [rgba objectForKey:@"red"];
    NSNumber* green = [rgba objectForKey:@"green"];
    NSNumber* blue = [rgba objectForKey:@"blue"];
    NSNumber* alpha = [rgba objectForKey:@"alpha"];
    return [UIColor colorWithRed:[red floatValue]/255.0 green:[green floatValue]/255.0 blue:[blue floatValue]/255.0 alpha:[alpha floatValue]];
}

@end
