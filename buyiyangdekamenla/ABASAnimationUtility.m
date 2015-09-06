//
//  ABASAnimationUtility.m
//  aBaStory
//
//  Created by joyce on 15/7/8.
//
//

#import <Foundation/Foundation.h>
#import "ABASAnimationUtility.h"


@implementation UINavigationController(ABASAnimationUtility)

- (void) pushViewControllerFromBottom:(UIViewController *)viewController
{
    CGRect frame = viewController.view.frame;
    viewController.view.frame = CGRectMake(frame.origin.x, frame.origin.y + frame.size.height, frame.size.width, frame.size.height);
//    [self.navigationController pushViewController:viewController animated:NO];
    [self.navigationController.view addSubview:viewController.view];
    [UIView animateWithDuration:5.0f
                     animations:^{
                         viewController.view.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void) popViewControllerToBottom:(UIViewController *)viewController
{
    CGRect frame = viewController.view.frame;
    [self.navigationController popViewControllerAnimated:NO];
    //    [self.navigationController addSubview:viewController.view];
    [UIView animateWithDuration:.15f
                     animations:^{
                         viewController.view.frame = CGRectMake(frame.origin.x, frame.origin.y + frame.size.height, frame.size.width, frame.size.height);
                     }
                     completion:^(BOOL finished) {
                     }];
}

@end
