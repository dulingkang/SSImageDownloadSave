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

#define ImageDownloadUrl @"http://115.28.228.41/static/background.json"
#define ImageCount 3
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (nonatomic, strong) NSMutableArray *imageArray;

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
    for (UIImage *image in _imageArray) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_stackView addArrangedSubview:imageView];
        [UIView animateWithDuration:1 animations:^{
            [_stackView layoutIfNeeded];
        }];
    }
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
}

- (UIImage *)loadImageFromDownloadTempFolder:(NSInteger)index {
    NSString * tmpPath = NSTemporaryDirectory();
    NSString *folderPath = [tmpPath stringByAppendingPathComponent:ImageTempFolder];
    NSString *str = [NSString stringWithFormat:@"image%ld.jpg",index];
    NSString *imagePath = [folderPath stringByAppendingPathComponent:str];
    UIImage * img = [UIImage imageWithContentsOfFile:imagePath];
    return img;
}

@end
