//
//  ExchangeRatePolling.swift
//  ArbiBot
//
//  Created by anhtu on 3/7/19.
//  Copyright © 2019 fia. All rights reserved.
//

import Foundation

class PrintPolling: NSObject, Pollingable {
  
  private var callback: (() -> Void)?
  
  func interval() -> Int {
    return 1
  }
  
  func eventHandler() -> (() -> Void) {
    return { [weak self] in
      print("polling 1...")
      self?.callback?()
    }
  }
  
  func listenEventFired(_ callback: @escaping () -> Void) -> Void {
    self.callback = callback
  }
}

class PrintPolling2: NSObject, Pollingable {
  
  private var callback: (() -> Void)?
  
  func interval() -> Int {
    return 2
  }
  
  func eventHandler() -> (() -> Void) {
    return { [weak self] in
      print("polling 2...")
      self?.callback?()
    }
  }
  
  func listenEventFired(_ callback: @escaping () -> Void) -> Void {
    self.callback = callback
  }
}
