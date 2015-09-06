//
//  ABASRecorderViewController.m
//  aBaStory
//
//  Created by joyce on 15/7/9.
//
//

#import <Foundation/Foundation.h>
#import "ABASRecorderViewController.h"
#import "ABASLocalizationUtility.h"
#import "ABASPListUtility.h"
#import "ABASConstant.h"

@interface ABASRecorderViewController()
{
    AVAudioRecorder* audioRecorder;
    AVAudioPlayer *audioPlayer;

    UIButton *startButton;
//    UIButton *pauseButton;
    UIButton *stopButton;
}

@end

@implementation ABASRecorderViewController

- (id) init
{
    self = [super init];
    if (self)
    {
        audioRecorder = nil;
        audioPlayer = nil;

        startButton = nil;
        stopButton = nil;
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];

    startButton = [[UIButton alloc] initWithFrame:CGRectMake(0 , SCREEN_HEIGHT - GENERAL_BUTTON_HEIGHT, GENERAL_BUTTON_WIDTH, GENERAL_BUTTON_HEIGHT)];
    [startButton setTitle:ABASGetLocalizedString(@"startRecord", @"") forState:UIControlStateNormal];
    startButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [startButton.titleLabel sizeToFit];
    startButton.backgroundColor = ABASGetPListColor(@"LeftDirectoryButtonColor");
    [startButton addTarget:self action:@selector(startButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startButton];

    stopButton = [[UIButton alloc] initWithFrame:CGRectMake(VIEW_FRAME_RIGHT(startButton), VIEW_FRAME_TOP(startButton), GENERAL_BUTTON_WIDTH, GENERAL_BUTTON_HEIGHT)];
    [stopButton setTitle:ABASGetLocalizedString(@"stopRecord", @"") forState:UIControlStateNormal];
    stopButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [stopButton.titleLabel sizeToFit];
    stopButton.backgroundColor = ABASGetPListColor(@"LeftDirectoryButtonColor");
    stopButton.hidden = YES;
    [stopButton addTarget:self action:@selector(stopButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopButton];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    if (!documentsDirectory)
    {
        NSLog(@"Documents directory not found!");
    }

    NSString* fileName = [NSString stringWithFormat:@"%@%lu.caf", _storyTitle, (unsigned long)_curPageNumber];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSURL *soundFileURL = [NSURL fileURLWithPath:filePath];
    
    NSDictionary *recordSettings = [NSDictionary
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:AVAudioQualityMin],
                                    AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:16],
                                    AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 2],
                                    AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:44100.0],
                                    AVSampleRateKey,
                                    nil];
    
    NSError *error = nil;
    
    audioRecorder = [[AVAudioRecorder alloc]
                     initWithURL:soundFileURL
                     settings:recordSettings
                     error:&error];
    if (error)
    {
        NSLog(@"error: %@", [error localizedDescription]);
    }
    else
    {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:NULL];
        [audioRecorder prepareToRecord];
    }
    
}

-(void)startButtonClicked:(UIButton *)button
{
    [self recordAudio];
    [_delegate recordStarted];
}

-(void)stopButtonClicked:(UIButton *)button
{
    [self stopRecord];
    [_delegate recordStoped];
}

/*private functions*/
-(void) recordAudio
{
    if (!audioRecorder.recording)
    {
        startButton.hidden = YES;
        stopButton.hidden = NO;
        [audioRecorder record];
    }
}

-(void)stopRecord
{
    stopButton.hidden = YES;
    startButton.hidden = NO;
    
    if (audioRecorder.recording)
    {
        [audioRecorder stop];
    } else if (audioPlayer.playing)
    {
        [audioPlayer stop];
    }
}


-(void) playAudio
{
    if (!audioRecorder.recording)
    {
        NSError *error;
        
        audioPlayer = [[AVAudioPlayer alloc]
                       initWithContentsOfURL:audioRecorder.url
                       error:&error];
        
        audioPlayer.delegate = self;
        
        if (error)
        {
            NSLog(@"Error: %@",[error localizedDescription]);
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

@end