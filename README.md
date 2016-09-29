# AsstisTouch

对AsstisTouch的模拟实现app中全局显示

[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)
[![CocoaPods](https://img.shields.io/cocoapods/v/TKSubmitTransition.svg)]()

**语言:Swift2.3!! :cat:**
# Demo
![Demo GIF Animation](https://github.com/DKJone/AsstisTouch/blob/master/ex.gif?raw=true "Demo GIF Animation")
---
在项目中使用时只需啊哟将DebugExt.swift拖入项目中并在appdelegarte中添加以下代码即可

```swift
    var assistiveTouch: AssistiveTouch!
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.performSelector(#selector(showDeBugExt), withObject: nil, afterDelay: 3)
        return true
    }
```

需要在弹出视图中添加更多功能，可以在DebugExt.swift文件的
```swift
func itemClick(sender: UIButton){
    //具体操作的例子
    sender.tag == 1 ? self.hidden = true: ()
    //add more
}
```
