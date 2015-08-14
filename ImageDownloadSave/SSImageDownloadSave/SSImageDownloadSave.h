//
//  SSImageDownloadSave.h
//  ImageDownloadSave
//
//  Created by ShawnDu on 15/8/12.
//  Copyright (c) 2015年 ShawnDu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSImageDownloadSave : NSObject


/**
 *  下载图片到指定目录 document/ImageTempFolder，下载时根据plist文件里面的存的md5值判断是否已经下过了，如果本地存在，就不再下载。
 *
 *  @param imageUrl 传入的图片的json格式的地址
 本代码中的json格式为：{
	"scrollview_pics":[
 {
 "Url" : "http://www.zhkhy.com/xiaoka/mainscrollview/guide_page_1.jpg",
 "MD5" : "f95351a68f16bd45378ca82913151c9d",
 "isClicked":"true"
 }
	]
 }
 */

- (void)createImageDownloadTask:(NSString *)imageUrl;

@end
