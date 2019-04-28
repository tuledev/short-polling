# Short Polling 
### A simple short-polling center (crontab-like) with Swift 4.2

## Table of Contents
- Introduction
- Installation & Usage
- To do

## Introduction 
This repo is a simple center for short-polling. You can easily manage repeating tasks with Swift. E.g. fetching APIs,...

## Installation & Usage
- Add `PollingCenter.swift` to your project
- Create your own polling. E.g.
``` Swift
class PrintPolling: NSObject, Pollingable {
  func interval() -> Int {
    return 5
  }
  // handler's called every interval time
  func eventHandler() -> (() -> Void) {
    return {
      print("polling 1...")
    }
  }
}
```
- Add and enable your polling. E.g.
``` Swift
let pollingCenter = PollingCenter()
let printPolling = PrintPolling()
pollingCenter.addPolling(printPolling)
pollingCenter.enablePolling(printPolling.uid())
```
- Done. Now you can do whatever you want in `eventHandler`

## To do
- Installing via Cocoapods
- Using Swift 5.x
- Delete pollings
- Enable/Disable all pollings

### License
This project is licensed under the terms of the MIT license.


