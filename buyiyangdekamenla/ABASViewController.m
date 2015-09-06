//
//  ViewController.m
//  buyiyangdekamenla
//
//  Created by joyce on 15/7/6.
//
//
#import <Foundation/Foundation.h>

#import "ABASViewController.h"
#import "ABASConstant.h"
#import "ABASLocalizationUtility.h"
#import "ABASPListUtility.h"
#import "ABASMainViewController.h"
#import "ABASAddStoryViewController.h"

@interface ABASViewController ()
{
    NSMutableArray* storyArray;
    UIScrollView* leftDirsScrollView;
    NSString* storyTitle;
    NSUInteger storyIndex;
 }
@end


@implementation ABASViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        storyArray = nil;
        leftDirsScrollView = nil;
        storyIndex = 0;
        storyTitle = nil;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString* userDefaultKey = ABASGetLocalizedString(STORIES_KEY, @"");
    //read UserDefaultStories, if 0, then init with kameila
    NSArray* stories = [[NSUserDefaults standardUserDefaults] valueForKey:userDefaultKey];
    if ([stories count] == 0)
    {
        NSString* kamenla = ABASGetLocalizedString(@"buyiyangdekameila", @"");
        storyArray = [NSMutableArray arrayWithObjects:kamenla, nil];

        NSArray* array = [[NSArray alloc] initWithObjects:kamenla, nil];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:userDefaultKey];
    }
    else
    {
        storyArray = [[NSMutableArray alloc] init];
        for (int i =0; i < stories.count; i++)
        {
            [storyArray addObject:stories[i]];
        }
    }

    //process storyArray
    leftDirsScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    NSUInteger scrollHeight = ((LEFT_DIRECTORY_HEIGHT+LEFT_DIRECTORY_PENDING_Y)*storyArray.count) > SCREEN_HEIGHT ? ((LEFT_DIRECTORY_HEIGHT+LEFT_DIRECTORY_PENDING_Y)*(storyArray.count+1)) : SCREEN_HEIGHT;
    leftDirsScrollView.frame = CGRectMake(0, 0, LEFT_DIRECTORY_WIDTH, SCREEN_HEIGHT);
    leftDirsScrollView.contentSize = CGSizeMake(LEFT_DIRECTORY_WIDTH, scrollHeight);
    leftDirsScrollView.backgroundColor = ABASGetPListColor(@"LeftDirectoryBackgoundColor");
    [self.view addSubview:leftDirsScrollView];

    for (int i =0; i<storyArray.count; i++)
    {
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(BUTTON_IN_LEFT_DIRECTORY_PENDING_X, i*(LEFT_DIRECTORY_HEIGHT + LEFT_DIRECTORY_PENDING_Y) + BUTTON_IN_LEFT_DIRECTORY_PENDING_Y, BUTTON_IN_LEFT_DIRECTORY_WIDTH, BUTTON_IN_LEFT_DIRECTORY_HEIGHT)];
        [button setTitle:storyArray[i] forState:UIControlStateNormal];
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        [button.titleLabel sizeToFit];
        button.backgroundColor = ABASGetPListColor(@"LeftDirectoryButtonColor");
        [button addTarget:self action:@selector(indexButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [leftDirsScrollView addSubview:button];
    }

    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(BUTTON_IN_LEFT_DIRECTORY_PENDING_X, storyArray.count * (LEFT_DIRECTORY_HEIGHT + LEFT_DIRECTORY_PENDING_Y) + BUTTON_IN_LEFT_DIRECTORY_PENDING_Y, BUTTON_IN_LEFT_DIRECTORY_WIDTH, BUTTON_IN_LEFT_DIRECTORY_HEIGHT)];
    [button setTitle:ABASGetLocalizedString(@"addStory", @"") forState:UIControlStateNormal];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    [button.titleLabel sizeToFit];
    button.backgroundColor = ABASGetPListColor(@"LeftDirectoryButtonColor");
    [button addTarget:self action:@selector(addStoryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [leftDirsScrollView addSubview:button];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)indexButtonClicked:(UIButton *)button
{
    storyTitle = button.titleLabel.text;
    for (int i = 0; i < storyArray.count; i++)
    {
        if ([storyTitle isEqualToString:storyArray[i]])
        {
            storyIndex = i;
            break;
        }
    }
    UIImage* indexImage = nil;
    NSString* title = button.titleLabel.text;
    if (storyIndex == 0)
    {
        NSString* indexPath = [NSString stringWithFormat:@"IndexPage%@", title];
        indexImage = [UIImage imageNamed:indexPath];
    }
    else
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        if (!documentsDirectory)
        {
            NSLog(@"Documents directory not found!");
        }
        NSString* fileName = [NSString stringWithFormat:@"IndexPage%@.png", title];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
        indexImage = [UIImage imageWithContentsOfFile:filePath];
    }
    UIImageView* indexImageView = [[UIImageView alloc] initWithImage:indexImage];
    indexImageView.frame = CGRectMake(LEFT_DIRECTORY_WIDTH, 0, SCREEN_WIDTH - LEFT_DIRECTORY_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:indexImageView];

    UIButton* startBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - GENERAL_BUTTON_WIDTH, SCREEN_HEIGHT - GENERAL_BUTTON_HEIGHT, GENERAL_BUTTON_WIDTH, GENERAL_BUTTON_HEIGHT)];
    [startBtn setTitle:ABASGetLocalizedString(@"start", @"") forState:UIControlStateNormal];
    startBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [startBtn.titleLabel sizeToFit];
    startBtn.backgroundColor = ABASGetPListColor(@"LeftDirectoryButtonColor");
    [startBtn addTarget:self action:@selector(startButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn]; 
}

-(void)startButtonClicked:(UIButton *)button
{
    ABASMainViewController* mainViewCtl = [[ABASMainViewController alloc] init];
    mainViewCtl.storyTitle = storyTitle;
    [self.navigationController pushViewController:mainViewCtl animated:YES];
}

-(void)addStoryButtonClicked:(UIButton *)button
{
    ABASAddStoryViewController* addStoryCtl = [[ABASAddStoryViewController alloc] init];
    addStoryCtl.delegate = self;
    [self.navigationController pushViewController:addStoryCtl animated:YES];
}

#pragma mark ABASAddStoryViewControllerDelegate
-(void) addStoryDone
{
    [self.navigationController popViewControllerAnimated:YES];
    //reload
    [self viewDidUnload];
    [self viewDidLoad];
}

@end
