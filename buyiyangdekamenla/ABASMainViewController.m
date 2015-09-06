//
//  ABASMainViewController.m
//  aBaStory
//
//  Created by joyce on 15/7/8.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ABASMainViewController.h"
#import "ABASConstant.h"
#import "ABASLocalizationUtility.h"
#import "ABASPListUtility.h"
#import "ABASAnimationUtility.h"
#import "ABASRecorderViewController.h"
#import "ABASAudioFilesViewController.h"

@interface ABASMainViewController()
{
    UIButton* indexPageBtn;
    UIButton* prePageBtn;
    UIButton* nextPageBtn;

    NSUInteger curPageNumber;
    UIImageView* curImageView;

    UIView*   navigationBarView;
    UIView*   contentView;

    UIButton* addImageBtn;
    UIButton* addRecordBtn;
    UIButton* playRecordBtn;

    AVAudioRecorder* audioRecorder;
    AVAudioPlayer* audioPlayer;
}
@end

@implementation ABASMainViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        curPageNumber = 0;
        curImageView = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    /*navigation bar view*/
    navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, UI_STATUS_BAR_HEIGHT, SCREEN_WIDTH, UI_NAVIGATION_BAR_HEIGHT)];
    navigationBarView.backgroundColor = ABASGetPListColor(@"LeftDirectoryBackgoundColor");
    [self.view addSubview:navigationBarView];

    indexPageBtn = [[UIButton alloc] initWithFrame:CGRectMake(0 , 0, GENERAL_BUTTON_WIDTH, GENERAL_BUTTON_HEIGHT)];
    [indexPageBtn setTitle:ABASGetLocalizedString(@"indexPage", @"") forState:UIControlStateNormal];
    indexPageBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [indexPageBtn.titleLabel sizeToFit];
    indexPageBtn.backgroundColor = ABASGetPListColor(@"LeftDirectoryButtonColor");
    [indexPageBtn addTarget:self action:@selector(indexButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [navigationBarView addSubview:indexPageBtn];

    prePageBtn = [[UIButton alloc] initWithFrame:CGRectMake(VIEW_FRAME_RIGHT(indexPageBtn), 0, GENERAL_BUTTON_WIDTH, GENERAL_BUTTON_HEIGHT)];
    [prePageBtn setTitle:ABASGetLocalizedString(@"prePage", @"") forState:UIControlStateNormal];
    prePageBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [prePageBtn.titleLabel sizeToFit];
    prePageBtn.backgroundColor = ABASGetPListColor(@"LeftDirectoryButtonColor");
    [prePageBtn addTarget:self action:@selector(preButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [navigationBarView addSubview:prePageBtn];

    nextPageBtn = [[UIButton alloc] initWithFrame:CGRectMake(VIEW_FRAME_RIGHT(prePageBtn), 0, GENERAL_BUTTON_WIDTH, GENERAL_BUTTON_HEIGHT)];
    [nextPageBtn setTitle:ABASGetLocalizedString(@"nextPage", @"") forState:UIControlStateNormal];
    nextPageBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [nextPageBtn.titleLabel sizeToFit];
    nextPageBtn.backgroundColor = ABASGetPListColor(@"LeftDirectoryButtonColor");
    [nextPageBtn addTarget:self action:@selector(nextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [navigationBarView addSubview:nextPageBtn];

    /*content view*/
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, UI_STATUS_BAR_HEIGHT + UI_NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - UI_STATUS_BAR_HEIGHT - UI_NAVIGATION_BAR_HEIGHT)];
    [self.view addSubview:contentView];

    [self loadCurrentStoryPage:curPageNumber];
}


-(void)indexButtonClicked:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)preButtonClicked:(UIButton *)button
{
    if (curPageNumber > 0)
    {
        if (curImageView)
        {
            NSLog(@"remove from supper");
            [curImageView removeFromSuperview];
        }
        NSLog(@"load previous");
        [self loadCurrentStoryPage:--curPageNumber];
    }
}

-(void)nextButtonClicked:(UIButton *)button
{
    if (curImageView)
    {
        NSLog(@"remove from supper");
        [curImageView removeFromSuperview];
        NSLog(@"load next");
        [self loadCurrentStoryPage:++curPageNumber];
    }
}

/*private functions*/
- (void)loadCurrentStoryPage:(NSUInteger)pageNumber
{
    UIImage* curImage = nil;

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    if (!documentsDirectory)
    {
        NSLog(@"Documents directory not found!");
    }
    NSString* fileName = [NSString stringWithFormat:@"%@%lu.png", _storyTitle, (unsigned long)pageNumber];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        curImage = [UIImage imageWithContentsOfFile:filePath];
    }
    if (curImage == nil)
    {
        curImageView = nil;
        NSLog(@"%@ not exist", fileName);
    }
    else
    {
        NSLog(@"%@ exist", fileName);
        curImageView = [[UIImageView alloc] initWithImage:curImage];
        curImageView.frame = CGRectMake(0, 0, VIEW_FRAME_WIDTH(contentView), VIEW_FRAME_HEIGHT(contentView));
        [contentView addSubview:curImageView];
    }
//    if (addImageBtn == nil)
    {
        addImageBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-GENERAL_BUTTON_WIDTH, VIEW_FRAME_HEIGHT(contentView)-GENERAL_BUTTON_HEIGHT, GENERAL_BUTTON_WIDTH, GENERAL_BUTTON_HEIGHT)];
        [addImageBtn setTitle:ABASGetLocalizedString(@"addImage", @"") forState:UIControlStateNormal];
        addImageBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [addImageBtn.titleLabel sizeToFit];
        addImageBtn.backgroundColor = ABASGetPListColor(@"LeftDirectoryButtonColor");
        [addImageBtn addTarget:self action:@selector(addImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:addImageBtn];
    }
    
//    if (addRecordBtn == nil)
    {
        addRecordBtn = [[UIButton alloc] initWithFrame:CGRectMake(VIEW_FRAME_LEFT(addImageBtn), VIEW_FRAME_TOP(addImageBtn) - GENERAL_BUTTON_HEIGHT, GENERAL_BUTTON_WIDTH, GENERAL_BUTTON_HEIGHT)];
        [addRecordBtn setTitle:ABASGetLocalizedString(@"addRecord", @"") forState:UIControlStateNormal];
        addRecordBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [addRecordBtn.titleLabel sizeToFit];
        addRecordBtn.backgroundColor = ABASGetPListColor(@"LeftDirectoryButtonColor");
        [addRecordBtn addTarget:self action:@selector(addRecordButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:addRecordBtn];
    }
    
    {
        playRecordBtn = [[UIButton alloc] initWithFrame:CGRectMake(VIEW_FRAME_LEFT(addRecordBtn), VIEW_FRAME_TOP(addRecordBtn) - GENERAL_BUTTON_HEIGHT, GENERAL_BUTTON_WIDTH, GENERAL_BUTTON_HEIGHT)];
        [playRecordBtn setTitle:ABASGetLocalizedString(@"playRecord", @"") forState:UIControlStateNormal];
        playRecordBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [playRecordBtn.titleLabel sizeToFit];
        playRecordBtn.backgroundColor = ABASGetPListColor(@"LeftDirectoryButtonColor");
        [playRecordBtn addTarget:self action:@selector(playRecordButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:playRecordBtn];
    }

}

-(void)addImageButtonClicked:(UIButton *)button
{
    ABASSelectionViewController* selection = [[ABASSelectionViewController alloc] init];
    selection.tag = SELECTION_TAG_PHOTO;
    NSArray* array = [NSArray arrayWithObjects:ABASGetLocalizedString(@"fromCamera", @""), ABASGetLocalizedString(@"fromPhoto", @""), ABASGetLocalizedString(@"cancel", @""), nil];
    selection.items = array;
    selection.delegate = self;
    //[self.navigationController pushViewControllerFromBottom:selection];
    [self.navigationController pushViewController:selection animated:YES];
}

-(void)addRecordButtonClicked:(UIButton *)button
{
    ABASSelectionViewController* selection = [[ABASSelectionViewController alloc] init];
    selection.tag = SELECTION_TAG_RECORD;
    NSArray* array = [NSArray arrayWithObjects:ABASGetLocalizedString(@"fromRecord", @""), ABASGetLocalizedString(@"fromAudioFile", @""), ABASGetLocalizedString(@"cancel", @""), nil];
    selection.items = array;
    selection.delegate = self;
//    [self.navigationController pushViewControllerFromBottom:selection];
    [self.navigationController pushViewController:selection animated:YES];
}

-(void)playRecordButtonClicked:(UIButton *)button
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    if (!documentsDirectory)
    {
        NSLog(@"Documents directory not found!");
    }
    
    NSString* fileName = [NSString stringWithFormat:@"%@%lu.caf", _storyTitle, (unsigned long)curPageNumber];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSURL *soundFileURL = [NSURL fileURLWithPath:filePath];
    
    NSError *error = nil;
    {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
        [[AVAudioSession sharedInstance] setActive:YES error:&error];
        if (error)
        {
            NSLog(@"error: %@", [error localizedDescription]);
        }
        else
        {
            [self playAudio:soundFileURL];
        }
    }
}

-(void) playAudio:(NSURL*)fileURL
{
//    if (!audioRecorder.recording)
    {
        NSError *error;
        
        audioPlayer = [[AVAudioPlayer alloc]
                       initWithContentsOfURL:fileURL
                       error:&error];
        
        audioPlayer.delegate = self;
        
        if (error)
        {
            NSLog(@"Error: %@",[error localizedDescription]);
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:ABASGetLocalizedString(@"noInfoTips", @"") delegate:nil cancelButtonTitle:nil otherButtonTitles:ABASGetLocalizedString(@"ok", @""), nil];
            [alert show];
        }
        else
        {
            BOOL ret = [audioPlayer play];
            if (ret == YES)
            {
                NSLog(@"playing ...");
            }
            else
            {
                NSLog(@"play failed");
            }
        }
    }
}
#pragma mark AVAudioPlayerDelegate
/* audioPlayerDidFinishPlaying:successfully: is called when a sound has finished playing. This method is NOT called if the player is stopped due to an interruption. */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"audioPlayerDidFinishPlaying");
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"audioPlayerDecodeErrorDidOccur");
}

#pragma mark SelectionViewControllerDelegate
- (void) itemSelected:(NSUInteger)index selectionTag:(NSString*)tag
{
    NSLog(@"select %lu", (unsigned long)index);
    if (index == 0)
    {
        if([tag isEqualToString:SELECTION_TAG_PHOTO]) //from camera
        {
            //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
            picker.delegate = self;
            picker.allowsEditing = YES;//设置可编辑
            picker.sourceType = sourceType;
            [self presentModalViewController:picker animated:YES];//进入照相界面
        }
        else if ([tag isEqualToString:SELECTION_TAG_RECORD]) //start record
        {
            ABASRecorderViewController* recorder = [[ABASRecorderViewController alloc] init];
            recorder.curPageNumber = curPageNumber;
            recorder.storyTitle = _storyTitle;
            recorder.delegate = self;
            [self.navigationController pushViewController:recorder animated:YES];
        }
    }
    else if (index == 1)
    {
        if([tag isEqualToString:SELECTION_TAG_PHOTO]) //from photo
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
        else if ([tag isEqualToString:SELECTION_TAG_RECORD]) //pause record
        {
            ABASAudioFilesViewController* audios = [[ABASAudioFilesViewController alloc] init];
            audios.storyTitle = _storyTitle;
            audios.curPageNumber = curPageNumber;
            audios.delegate = self;
            [self.navigationController pushViewController:audios animated:YES];
        }
    }
    else
    {
        if([tag isEqualToString:SELECTION_TAG_PHOTO] || [tag isEqualToString:SELECTION_TAG_RECORD])  //cancel
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
        [contentView addSubview:imageView];

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        if (!documentsDirectory)
        {
            NSLog(@"Documents directory not found!");
        }
        NSString* fileName = [NSString stringWithFormat:@"%@%lu.png", _storyTitle, (unsigned long)curPageNumber];
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
            [contentView addSubview:imageView];

            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            if (!documentsDirectory)
            {
                NSLog(@"Documents directory not found!");
            }
            NSString* fileName = [NSString stringWithFormat:@"%@%lu.png", _storyTitle, (unsigned long)curPageNumber];
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
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"imagePickerControllerDidCancel");
    [picker dismissViewControllerAnimated:YES completion:^{
        NSLog(@"dismissViewControllerAnimated done");
    }];
}

#pragma mark ABASRecorderViewControllerDelegate
- (void) recordStarted
{
    NSLog(@"recordStarted");
}

- (void) recordPaused
{
    NSLog(@"recordPaused");
}

- (void) recordResumed
{
    NSLog(@"recordResumed");
}

- (void) recordStoped
{
    NSLog(@"recordStoped");
    [self.navigationController popViewControllerAnimated:YES]; //pop ABASRecorderViewController
    [self.navigationController popViewControllerAnimated:YES]; //pop ABASSelectionViewController
}

#pragma mark ABASAudioFilesViewControllerDelegate
- (void) audioFileSelected
{
    NSLog(@"audioFileSelected");
    [self.navigationController popViewControllerAnimated:YES]; //pop ABASAudioFilesViewController
    [self.navigationController popViewControllerAnimated:YES]; //pop ABASSelectionViewController
}

@end
