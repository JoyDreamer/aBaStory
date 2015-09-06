//
//  ABASSelectionViewController.h
//  aBaStory
//
//  Created by joyce on 15/7/8.
//
//

#ifndef aBaStory_ABASSelectionViewController_h
#define aBaStory_ABASSelectionViewController_h
#import <UIKit/UIKit.h>

@protocol SelectionViewControllerDelegate <NSObject>

- (void) itemSelected:(NSUInteger)index selectionTag:(NSString*)tag;

@end

@interface ABASSelectionViewController : UIViewController

@property(nonatomic, copy)NSString* tag;
@property(nonatomic, strong) NSArray* items;
@property(nonatomic, strong) id<SelectionViewControllerDelegate> delegate;

@end

#endif
