# 相乐搞笑(xiangle-ios)
这个项目本来是用来创业的，但上架App Store几个月以来，下载量寥寥无几，可能方向不对，可能不懂运营...

现分享出来，看有没有需要的朋友

# 项目介绍
```text
布局采用纯代码的方式（frame+masonry），没有storyboard
主框架: 自定义UITabBarController+UIScrollView+自定义UINavigationController
网络请求: AFNetworking
图片加载: SDWebImage
列表加载: UITableView
文件存储: OSS(sts方式)
指示器(HUD): SVProgressHUD
下拉刷新，上拉加载: MJRefresh
json转模型: MJExtension
自动布局: Masonry
token存储: NSUserDefaults
包管理工具: CocoaPods

目录结构
Controller：控制器，里面针对不同模块建立对应子目录
Model：所有接口的model
View：cell,自定义view等，里面针对不同模块建立对应子目录
Bean：类似Java bean
Expand：扩展
Util：工具类
```

# 介绍
分享风趣幽默的段子/视频/图片
```text
首页：视频/图片/文字 任你选择
详情：收藏/评论/点赞 雁过留声
发现：搜索/话题/活动 应有尽有
我的：收藏/评论/点赞 一个不少
```

# 截图
![home.jpg](screenshots/home.jpg)
![detail.jpg](screenshots/detail.jpg)
![discover.jpg](screenshots/discover.jpg)
![my.jpg](screenshots/my.jpg)

# 快速开始

1.在项目根目录执行
```
pod install
```
2.使用Xcode 12.4打开`xiangle.xcworkspace`文件
