//
//  ABASSelectionViewController.m
//  aBaStory
//
//  Created by joyce on 15/7/8.
//
//

#import <Foundation/Foundation.h>
#import "ABASSelectionViewController.h"
#import "ABASPListUtility.h"
#import "ABASConstant.h"

@interface ABASSelectionViewController()
{
    UIView* backgroundView;
}
@end

@implementation ABASSelectionViewController
@synthesize delegate;

- (id) init
{
    self = [super init];
    if (self)
    {
        backgroundView = nil;
        _items = nil;
    }
    return self;
}

- (void) viewDidLoad
{
    backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backgroundView.backgroundColor = ABASGetPListColor(@"SelectionViewBackgroundColor");
    [self.view addSubview:backgroundView];

    //from bottom to top
    for(int i = 0; i < _items.count; i++)
    {
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(VIEW_FRAME_WIDTH(backgroundView)/2, VIEW_FRAME_BOTTOM(backgroundView) - (i+1)*GENERAL_BUTTON_HEIGHT, GENERAL_BUTTON_WIDTH, GENERAL_BUTTON_HEIGHT)];
        [button setTitle:_items[i] forState:UIControlStateNormal];
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        [button.titleLabel sizeToFit];
        button.backgroundColor = ABASGetPListColor(@"LeftDirectoryButtonColor");
        [button addTarget:self action:@selector(selectionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:button];
    }
}

-(void)selectionButtonClicked:(UIButton *)button
{
    NSUInteger index = 0;
    NSString* title = button.titleLabel.text;
    for (int i = 0; i < _items.count; i++)
    {
        if ([title isEqualToString:_items[i]])
        {
            index = i;
            break;
        }
    }
    [delegate itemSelected:index selectionTag:_tag];
}

@end