//
//  ABASRecorderViewController.h
//  aBaStory
//
//  Created by joyce on 15/7/9.
//
//

#ifndef aBaStory_ABASRecorderViewController_h
#define aBaStory_ABASRecorderViewController_h

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol ABASRecorderViewControllerDelegate <NSObject>
- (void) recordStarted;
- (void) recordPaused;
- (void) recordResumed;
- (void) recordStoped;

@end

@interface ABASRecorderViewController : UIViewController
@property(nonatomic, assign) NSUInteger curPageNumber;
@property(nonatomic, copy) NSString* storyTitle;
@property(nonatomic, strong) id<ABASRecorderViewControllerDelegate> delegate;

@end

#endif
