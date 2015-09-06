//
//  ABASConstant.h
//  aBaStory
//
//  Created by joyce on 15/7/7.
//
//

#ifndef aBaStory_ABASConstant_h
#define aBaStory_ABASConstant_h

// Screen Size
#define SCREEN_WIDTH			CGRectGetWidth([[UIScreen mainScreen] bounds])
#define SCREEN_HEIGHT           CGRectGetHeight([[UIScreen mainScreen] bounds])

#define IsIOS7 ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=7)
#define UI_NAVIGATION_BAR_HEIGHT           (IsIOS7?64:44)
#define UI_STATUS_BAR_HEIGHT               (IsIOS7?0:20)

//scale reference value(6 plus)
#define REFERENCE_SCREEN_WIDTH     414
#define SCALE                      (SCREEN_WIDTH/REFERENCE_SCREEN_WIDTH)

#define GENERAL_TEXTFIELD_WIDTH                  100
#define GENERAL_TEXTFIELD_HEIGHT                 GENERAL_TEXTFIELD_WIDTH/3

#define BUTTON_IN_LEFT_DIRECTORY_WIDTH           100
#define BUTTON_IN_LEFT_DIRECTORY_HEIGHT          BUTTON_IN_LEFT_DIRECTORY_WIDTH
#define LEFT_DIRECTORY_WIDTH                     120
#define LEFT_DIRECTORY_HEIGHT                    LEFT_DIRECTORY_WIDTH
#define LEFT_DIRECTORY_PENDING_Y                 5
#define BUTTON_IN_LEFT_DIRECTORY_PENDING_X       (LEFT_DIRECTORY_WIDTH - BUTTON_IN_LEFT_DIRECTORY_WIDTH)/2
#define BUTTON_IN_LEFT_DIRECTORY_PENDING_Y       (LEFT_DIRECTORY_HEIGHT - BUTTON_IN_LEFT_DIRECTORY_HEIGHT + LEFT_DIRECTORY_PENDING_Y)
#define GENERAL_BUTTON_WIDTH                     100
#define GENERAL_BUTTON_HEIGHT                    (GENERAL_BUTTON_WIDTH/2)

static NSString* const STORIES_KEY = @"storiesKey";
static NSString* const ADD_NEW_STORY = @"+";

#define SELECTION_TAG_PHOTO   @"photo"
#define SELECTION_TAG_RECORD  @"record"

/*
 utilities
 */
#define VIEW_FRAME_LEFT(view) \
    view.frame.origin.x
#define VIEW_FRAME_RIGHT(view) \
    (view.frame.origin.x + view.frame.size.width)
#define VIEW_FRAME_TOP(view) \
    view.frame.origin.y
#define VIEW_FRAME_BOTTOM(view) \
    (view.frame.origin.y + view.frame.size.height)
#define VIEW_FRAME_WIDTH(view) \
    view.frame.size.width
#define VIEW_FRAME_HEIGHT(view) \
    view.frame.size.height


#endif
