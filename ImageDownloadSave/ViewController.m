//
//  ViewController.m
//  ImageDownloadSave
//
//  Created by ShawnDu on 15/8/12.
//  Copyright (c) 2015年 ShawnDu. All rights reserved.
//

#import "ViewController.h"
#import "ImageDownloadGlobal.h"
#import "SSImageDownloadSave.h"

#define ImageDownloadUrl @"http://www.zhkhy.com/xiaoka/mainscrollview/mainscrollviewinfo.json"
#define ImageCount 3
@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *imageArray;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;

@end

@implementation ViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    _imageArray = [[NSMutableArray alloc] initWithCapacity:ImageCount];
    NSArray *scrollLocalArray = @[@"image1.jpg",@"image2.jpg",@"image3.jpg"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageDownloadNotify:) name:imageDownLoadCompleteNotification object:nil];
    NSString *path = NSTemporaryDirectory();
    NSString *plistPath = [path stringByAppendingPathComponent:PlistName];
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    for (NSInteger m = 0 ; m < ImageCount; m++) {
        NSString *keyStr = [NSString stringWithFormat:@"image%ld",m+1];
        NSString *imageStr = [plistDict objectForKey:keyStr];
        UIImage *image = [[UIImage alloc] init];
        if (imageStr.length > 0) {
           image = [self loadImageFromDownloadTempFolder:m];
        }
        else {
            image = [UIImage imageNamed:scrollLocalArray[m]];
        }
        [_imageArray addObject:image];
    }
    [self reloadTheImages];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:imageDownLoadCompleteNotification object:nil];
}

#pragma mark - private methods

- (void)imageDownloadNotify:(NSNotification *)notify
{
    id indexId = notify.object;
    NSInteger index = [indexId integerValue];
    UIImage *image = [self loadImageFromDownloadTempFolder:index];
    if (!image) return;
    if (_imageArray.count > index) {
        [_imageArray replaceObjectAtIndex:index withObject:image];
    }
    else {
        [_imageArray addObject:image];
    }
    [self reloadTheImages];
}

- (UIImage *)loadImageFromDownloadTempFolder:(NSInteger)index {
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *folderPath = [documentsDirectoryPath stringByAppendingPathComponent:ImageTempFolder];
    NSString *str = [NSString stringWithFormat:@"image%ld.jpg",index];
    NSString *imagePath = [folderPath stringByAppendingPathComponent:str];
    UIImage * img = [UIImage imageWithContentsOfFile:imagePath];
    return img;
}

- (void)reloadTheImages
{
    _imageView1.image = _imageArray[0];
    _imageView2.image = _imageArray[1];
    _imageView3.image = _imageArray[2];
}

@end
