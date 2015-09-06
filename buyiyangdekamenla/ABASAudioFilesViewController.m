//
//  ABASAudioFilesViewController.m
//  aBaStory
//
//  Created by joyce on 15/7/9.
//
//

#import <Foundation/Foundation.h>
#import "ABASAudioFilesViewController.h"
#import "ABASConstant.h"

@interface ABASAudioFilesViewController()
{
    UITableView* tableView;

    NSMutableArray* audioFiles;
}
@end

@implementation ABASAudioFilesViewController

- (id) init
{
    self = [super init];
    if (self)
    {
        tableView = nil;
        audioFiles = nil;
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];

    audioFiles = [[NSMutableArray alloc] init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    if (!documentsDirectory)
    {
        NSLog(@"Documents directory not found!");
    }
    NSArray *arrMp3=[NSBundle pathsForResourcesOfType:@"mp3" inDirectory:documentsDirectory];
    for (NSString *filePath in arrMp3)
    {
        NSLog(@"%@", filePath);
        [audioFiles addObject:filePath];
    }
    NSArray *arrCAF=[NSBundle pathsForResourcesOfType:@"caf" inDirectory:documentsDirectory];
    for (NSString *filePath in arrCAF)
    {
        NSLog(@"%@", filePath);
        [audioFiles addObject:filePath];
    }

    paths = NSSearchPathForDirectoriesInDomains(NSMusicDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    if (!documentsDirectory)
    {
        NSLog(@"download directory not found!");
    }
    arrMp3=[NSBundle pathsForResourcesOfType:@"mp3" inDirectory:documentsDirectory];
    for (NSString *filePath in arrMp3)
    {
        NSLog(@"%@", filePath);
        [audioFiles addObject:filePath];
    }
    arrCAF=[NSBundle pathsForResourcesOfType:@"caf" inDirectory:documentsDirectory];
    for (NSString *filePath in arrCAF)
    {
        NSLog(@"%@", filePath);
        [audioFiles addObject:filePath];
    }

    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return audioFiles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"audioFileIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = [[audioFiles objectAtIndex:indexPath.row] lastPathComponent];
    }
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *destPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [destPaths objectAtIndex:0];
    if (!documentsDirectory)
    {
        NSLog(@"Documents directory not found!");
    }
    
    NSString* destFileName = [NSString stringWithFormat:@"%@%lu.caf", _storyTitle, (unsigned long)_curPageNumber];
    NSString *destFilePath = [documentsDirectory stringByAppendingPathComponent:destFileName];
//    NSURL *soundFileURL = [NSURL fileURLWithPath:filePath];

    NSString* filePath = [audioFiles objectAtIndex:indexPath.row];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    NSData* data = [NSData dataWithContentsOfURL:fileURL];
    BOOL ret = [data writeToFile:destFilePath atomically:YES];
    if (ret)
    {
        [_delegate audioFileSelected];
    }
}



@end