# ijkplayer_ios_swift
基于IJKPlayer 高度封装 直接集成

使用

1：导入IJKFramework

2:调用播放器

let playerView = VideoPlayerView.init(frame: self.view.bounds, strUrl: videoUrl)

view.addSubview(playerView)

3:UI自定义

struct ControlModel（修改里面子控件即可）
