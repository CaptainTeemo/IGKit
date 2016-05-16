<p align="center">
  <img src="https://raw.githubusercontent.com/CaptainTeemo/IGKit/master/logo.png">
</p>

# IGKit
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/CaptainTeemo/IGKit/master/LICENSE.md)
<!--[![GitHub release](https://img.shields.io/github/release/CaptainTeemo/IGKit.svg)](https://github.com/CaptainTeemo/IGKit/releases)-->

### Features
* All in one framework without any third-party dependency.
* Built in network request tool base on NSURLSession.
* Built in JSON struct.
* Built in model-to-JSON tool.
* Built in `Promise` tool.
* Easy to use.

### At a glance

```swift
User.fetchSelfFeed().then { (mediaArray, page) -> Void in
    self.dataSource = mediaArray
    dispatch_async(dispatch_get_main_queue(), { 
        self.tableView.reloadData()
    })
}.error { (error) in
    print(error)
}
```

### Requirements
* iOS 9.0+
* Xcode 7.3+

### Carthage
Put `github "CaptainTeemo/IGKit"` in your cartfile and run `carthage update` from terminal, then drag built framework to you project.
