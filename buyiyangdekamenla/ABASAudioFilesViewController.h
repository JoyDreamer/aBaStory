//
//  ABASAudioFilesViewController.h
//  aBaStory
//
//  Created by joyce on 15/7/9.
//
//

#ifndef aBaStory_ABASAudioFilesViewController_h
#define aBaStory_ABASAudioFilesViewController_h

#import <UIKit/UIKit.h>

@protocol ABASAudioFilesViewControllerDelegate <NSObject>
- (void) audioFileSelected;

@end

@interface ABASAudioFilesViewController : UIViewController<UITableViewDataSource,UITableViewDataSource>
@property(nonatomic, assign) NSUInteger curPageNumber;
@property(nonatomic, copy) NSString* storyTitle;
@property(nonatomic, strong) id<ABASAudioFilesViewControllerDelegate> delegate;

@end

#endif
