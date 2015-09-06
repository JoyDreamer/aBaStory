//
//  ABASAddStoryViewController.h
//  aBaStory
//
//  Created by joyce on 15/7/9.
//
//

#ifndef aBaStory_ABASAddStoryViewController_h
#define aBaStory_ABASAddStoryViewController_h
#import <UIKit/UIKit.h>
#import "ABASSelectionViewController.h"

@protocol ABASAddStoryViewControllerDelegate <NSObject>
- (void) addStoryDone;

@end

@interface ABASAddStoryViewController : UIViewController <SelectionViewControllerDelegate>
@property(nonatomic, strong) id<ABASAddStoryViewControllerDelegate> delegate;

@end

#endif
