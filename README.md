#ImageDownloadSave
------
## 使用方法
> 下载或者clone到本地后，把SSImageDownloadSave导入到工程中，在controller中，导入头文件：
```
SSImageDownloadSave *imageDownload = [[SSImageDownloadSave alloc] init];
[imageDownload createImageDownloadTask:ImageDownloadUrl];
_plistPath = imageDownload.plistPath;
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageDownloadNotify:) name:imageDownLoadCompleteNotification object:nil];
```
> plistPath中存储每个图片的md5值，初始值为
```
key:image1  image2 image3
value: "" "" ""
```
> 每次有新的图片下载到本地，会发出通知，controller中接收到通知后，更新界面。

## 说明
> * 下载图片到指定目录 document/ImageTempFolder，下载时根据plist文件里面的存的md5值判断是否已经下过了，如果本地存在，就不再下载。
imageUrl 传入的图片的json格式的地址
本代码中的json格式为：
```
{
"scrollview_pics":[
{
"Url" : "http://www.zhkhy.com/xiaoka/mainscrollview/guide_page_1.jpg",
"MD5" : "f95351a68f16bd45378ca82913151c9d",
"isClicked":"true"
}]
}
```
### 我的博客地址： http://dulingkang.github.io