//
//  ABASMainViewController.h
//  aBaStory
//
//  Created by joyce on 15/7/8.
//
//

#ifndef aBaStory_ABASMainViewController_h
#define aBaStory_ABASMainViewController_h
#import <UIKit/UIKit.h>
#import "ABASSelectionViewController.h"
#import "ABASRecorderViewController.h"
#import "ABASAudioFilesViewController.h"

@interface ABASMainViewController : UIViewController <SelectionViewControllerDelegate, UIImagePickerControllerDelegate, ABASRecorderViewControllerDelegate, ABASAudioFilesViewControllerDelegate>
@property(nonatomic, copy) NSString* storyTitle;

@end

#endif
