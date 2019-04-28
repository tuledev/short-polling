//
//  PollingCenter.swift
//  Coindess
//
//  Created by anhtu on 5/10/18.
//  Copyright © 2018 Coindess. All rights reserved.
//

import Foundation

protocol Pollingable {
  func uid() -> String
  func interval() -> Int
  func eventHandler() -> (() -> Void)
  static func uid() -> String
}

extension Pollingable where Self: NSObject {
  func uid() -> String {
    return String(describing: Self.self)
  }
  
  static func uid() -> String {
    return String(describing: Self.self)
  }
}

class PollingCenter {
  
  private let serialQueueChanging = DispatchQueue(label: "serialQueuePollingCenter")
  
  fileprivate var pollings = [String:DispatchSourceTimer]()
  fileprivate var pollingStates = [String: Bool]()
  
  private static var sharedInstance: PollingCenter = {
    let pollingCenter = PollingCenter()
    return pollingCenter
  }()
  
  static func shared() -> PollingCenter {
    return sharedInstance
  }

  private func createTimer(polling: Pollingable) -> DispatchSourceTimer {
    let queue = DispatchQueue.global(qos: .background)
    let timer = DispatchSource.makeTimerSource(queue: queue)
    timer.schedule(deadline: .now(), repeating: .seconds(polling.interval()))
    timer.setEventHandler(handler: {
      polling.eventHandler()()
    })
    return timer
  }
  
  fileprivate func resumePolling(_ uid: String) {
    if let polling = self.pollings[uid], let state = self.pollingStates[uid] {
      if state == false {
        self.pollingStates[uid] = true
        polling.resume()
      }
    }
  }
  
  fileprivate func pausePolling(_ uid: String) {
    if let polling = self.pollings[uid], let state = self.pollingStates[uid] {
      if state == true {
        self.pollingStates[uid] = false
        polling.suspend()
      }
    }
  }
  
}

extension PollingCenter {
  func addPollings(_ pollings: [Pollingable]) {
    pollings.forEach { addPolling($0) }
  }
  
  func addPolling(_ polling: Pollingable) {
    if pollings.index(forKey: polling.uid()) == nil {
      pollings[polling.uid()] = createTimer(polling: polling)
      pollingStates[polling.uid()] = false
    }
  }
}

extension PollingCenter {
  func enablePolling(_ uid: String) {
    self.serialQueueChanging.sync {
      self.resumePolling(uid)
    }
  }
  func disablePolling(_ uid: String) {
    self.serialQueueChanging.sync {
      self.pausePolling(uid)
    }
  }
}
