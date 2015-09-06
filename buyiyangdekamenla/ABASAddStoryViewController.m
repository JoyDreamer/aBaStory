//
//  ABASAddStoryViewController.m
//  aBaStory
//
//  Created by joyce on 15/7/9.
//
//

#import <Foundation/Foundation.h>

#import "ABASAddStoryViewController.h"
#import "ABASConstant.h"
#import "ABASLocalizationUtility.h"
#import "ABASPListUtility.h"
#import "ABASSelectionViewController.h"

@interface ABASAddStoryViewController()
{
    UITextField* textField;
    UIButton* nextStep;
}
@end


@implementation ABASAddStoryViewController

- (id)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - LEFT_DIRECTORY_WIDTH)/2, SCREEN_HEIGHT/2, GENERAL_TEXTFIELD_WIDTH, GENERAL_TEXTFIELD_HEIGHT)];
    textField.backgroundColor = ABASGetPListColor(@"LeftDirectoryButtonColor");
    [self.view addSubview:textField];

    nextStep = [[UIButton alloc] initWithFrame:CGRectMake(0 , 0, GENERAL_BUTTON_WIDTH, GENERAL_BUTTON_HEIGHT)];
    [nextStep setTitle:ABASGetLocalizedString(@"nextStep", @"") forState:UIControlStateNormal];
    nextStep.titleLabel.adjustsFontSizeToFitWidth = YES;
    [nextStep.titleLabel sizeToFit];
    nextStep.backgroundColor = ABASGetPListColor(@"LeftDirectoryButtonColor");
    [nextStep addTarget:self action:@selector(nextStepButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextStep];
}

-(void)nextStepButtonClicked:(UIButton *)button
{
    NSString* userDefaultKey = ABASGetLocalizedString(STORIES_KEY, @"");
    //read UserDefaultStories, if 0, then init with kameila
    NSArray* stories = [[NSUserDefaults standardUserDefaults] valueForKey:userDefaultKey];
    NSMutableArray* destStories = [[NSMutableArray alloc] init];
    for (int i =0; i < stories.count; i++)
    {
        [destStories addObject:stories[i]];
    }
    [destStories addObject:textField.text];
    [[NSUserDefaults standardUserDefaults] setObject:destStories forKey:userDefaultKey];

    ABASSelectionViewController* selection = [[ABASSelectionViewController alloc] init];
    selection.tag = SELECTION_TAG_PHOTO;
    NSArray* array = [NSArray arrayWithObjects:ABASGetLocalizedString(@"fromCamera", @""), ABASGetLocalizedString(@"fromPhoto", @""), ABASGetLocalizedString(@"cancel", @""), nil];
    selection.items = array;
    selection.delegate = self;
    //[self.navigationController pushViewControllerFromBottom:selection];
    [self.navigationController pushViewController:selection animated:YES];
}

#pragma mark SelectionViewControllerDelegate
- (void) itemSelected:(NSUInteger)index selectionTag:(NSString*)tag
{
    if ([tag isEqualToString:SELECTION_TAG_PHOTO])
    {
        if (index == 0) //camera
        {
            //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
            picker.delegate = self;
            picker.allowsEditing = YES;//设置可编辑
            picker.sourceType = sourceType;
            [self presentModalViewController:picker animated:YES];//进入照相界面
        }
        else if (index == 1) //photo libs
        {
            UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
            }
            pickerImage.delegate = self;
            pickerImage.allowsEditing = NO;
            [self presentModalViewController:pickerImage animated:YES];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"didFinishPickingMediaWithInfo");
    [self.navigationController popViewControllerAnimated:YES];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        NSLog(@"dismissViewControllerAnimated done");
    }];

    UIImage* editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    if (editedImage) //from camera
    {
        UIImageWriteToSavedPhotosAlbum(editedImage, nil, nil, nil);
        
        UIImageView* imageView = [[UIImageView alloc] initWithImage:editedImage];
        //[contentView addSubview:imageView];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        if (!documentsDirectory)
        {
            NSLog(@"Documents directory not found!");
        }
        NSString* fileName = [NSString stringWithFormat:@"IndexPage%@.png", textField.text];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
        //        if(![[NSFileManager defaultManager] fileExistsAtPath:filePath])
        {
            //            NSMutableDictionary *plistDict;
            //            plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"myimage" ofType:@"png"]];
            //            [[NSDictionary dictionaryWithDictionary:plistDict] writeToFile:filePath atomically: YES];
            
            NSData *imageData = UIImagePNGRepresentation(editedImage);
            [imageData  writeToFile:filePath atomically:NO];
        }
    }
    else
    {
        UIImage* originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (originalImage)
        {
            UIImageView* imageView = [[UIImageView alloc] initWithImage:originalImage];
//            [contentView addSubview:imageView];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            if (!documentsDirectory)
            {
                NSLog(@"Documents directory not found!");
            }
            NSString* fileName = [NSString stringWithFormat:@"IndexPage%@.png", textField.text];
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
            //            if(![[NSFileManager defaultManager] fileExistsAtPath:filePath])
            {
                //            NSMutableDictionary *plistDict;
                //            plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"myimage" ofType:@"png"]];
                //            [[NSDictionary dictionaryWithDictionary:plistDict] writeToFile:filePath atomically: YES];
                
                NSData *imageData = UIImagePNGRepresentation(originalImage);
                [imageData  writeToFile:filePath atomically:NO];
            }
        }
    }

    [_delegate addStoryDone];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"imagePickerControllerDidCancel");
    [picker dismissViewControllerAnimated:YES completion:^{
        NSLog(@"dismissViewControllerAnimated done");
    }];
}

@end