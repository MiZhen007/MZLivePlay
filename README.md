# MZLivePlay
excellent, classic live video player and stream pusher, base on Tencent live SDK and IM SDK, contains chat room

基于腾讯移动直播和云通信的直播聊天项目
本模块抽离自“先生开讲”App
项目代码下载后，需要手动集成腾讯相关SDK，集成目录在TencentIM和TencentLive中

TencentIM:
    IMGroupExt.framework
    IMMessageExt.framework
    ImSDK.framework
    IMSDKBugly.framework
    QALSDK.framework
    TLSSDK.framework
TencentLive：
    TXLiteAVSDK_Professional.framework
    
注意：
    1，注意集成的腾讯SDK版本，本次适配版本为云通信IM：v3.3.0，移动直播SDK：符号重命名版v4.4（4.5，4.6版本SDK有画面旋转的bug，截止本次commit，腾讯团队的回复是4.7版本修复），v4.4地址：http://liteavsdk-1252463788.cosgz.myqcloud.com/4.4/TXLiteAVSDK_Professional_Rename_iOS_4.4.3774.zip?_ga=1.66190826.57758247.1496281070
    2，腾讯移动直播参考文档：https://cloud.tencent.com/document/product/454/7876
        腾讯云通信IM参考文档：https://cloud.tencent.com/document/product/269/9147
    
