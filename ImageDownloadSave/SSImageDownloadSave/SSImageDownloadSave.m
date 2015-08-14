//
//  SSImageDownloadSave.m
//  ImageDownloadSave
//
//  Created by ShawnDu on 15/8/12.
//  Copyright (c) 2015年 ShawnDu. All rights reserved.
//

#import "SSImageDownloadSave.h"
#import "ImageDownloadGlobal.h"

#define NullString @""
#define Image1Key @"image1"
#define Image2Key @"image2"
#define Image3Key @"image3"
#define ImagePicKey @"scrollview_pics"
#define Md5Key @"MD5"
#define ImageUrlKey @"Url"

@implementation SSImageDownloadSave
{
    NSString *_plistPath;
}

- (void)createImageDownloadTask:(NSString *)imageUrl
{
    [self createImagePlist];
    NSURL *url = [NSURL URLWithString:imageUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"dict:%@",dict);
            NSMutableDictionary *plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:_plistPath];
            NSArray *array = [dict objectForKey:ImagePicKey];
            for (NSInteger i = 0; i < [array count]; i++) {
                NSString *md5KeyString = [array[i] objectForKey:Md5Key];
                if (![self isMd5StringInPlistFile:md5KeyString plistMutableDictionary:plistDict]) {
                    [self downloadImageWithUrlString:[array[i] objectForKey:ImageUrlKey] imageIndex:i];
                    NSString *oneImageKeyString = [NSString stringWithFormat:@"image%ld", i+1];
                    [plistDict setValue:md5KeyString forKey:oneImageKeyString];
                    [plistDict writeToFile:_plistPath atomically:YES];
                    NSLog(@"plistImage%ld:%@",i+1,md5KeyString);
                }
            }
        }
    }];
}

- (void)downloadImageWithUrlString:(NSString *)string imageIndex:(NSInteger)index
{
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"imageDownLoadError:%@",connectionError);
        }
        else {
            // 设置文件的存放目标路径
            NSString *imagePath = [self getSavedPath:index];
            NSLog(@"imagePath:%@", imagePath);
            
            // 如果该路径下文件已经存在，就要先将其移除，在移动文件
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:imagePath]) {
                [fileManager removeItemAtPath:imagePath error:nil];
            }
            [data writeToFile:imagePath atomically:YES];
            NSString *indexString = [NSString stringWithFormat:@"%ld",index];
            [[NSNotificationCenter defaultCenter] postNotificationName:imageDownLoadCompleteNotification object:indexString];
        }
    }];
}

/* 获取Documents文件夹的路径 */
- (NSString *)getSavedPath:(NSInteger)index{
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *folderPath = [documentsDirectoryPath stringByAppendingPathComponent:ImageTempFolder];
    BOOL bo = [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSAssert(bo,@"创建目录失败");
    NSString *str = [NSString stringWithFormat:@"image%ld.jpg",index];
    NSString *imagePath = [folderPath stringByAppendingPathComponent:str];
    return imagePath;
}

- (BOOL)isMd5StringInPlistFile:(NSString *)string plistMutableDictionary:(NSMutableDictionary *)plistDict
{
    if ([string isEqualToString:[plistDict objectForKey:Image1Key]] ||
        [string isEqualToString:[plistDict objectForKey:Image2Key]] ||
        [string isEqualToString:[plistDict objectForKey:Image3Key]]) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void)createImagePlist
{
    NSString *path = NSTemporaryDirectory();
    _plistPath = [path stringByAppendingPathComponent:PlistName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //    [fileManager removeItemAtPath:_plistPath error:nil];
    if (![fileManager fileExistsAtPath:_plistPath]) {
        if (![fileManager createFileAtPath:_plistPath contents:nil attributes:nil]) {
            NSLog(@"createPlistError!");
        }
        else {
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:NullString, Image1Key, NullString, Image2Key, NullString, Image3Key, nil];
            [dict writeToFile:_plistPath atomically:YES];
        }
    }
}

@end
