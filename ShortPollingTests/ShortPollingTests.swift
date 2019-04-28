//
//  ShortPollingTests.swift
//  ShortPollingTests
//
//  Created by anhtu on 3/7/19.
//  Copyright © 2019 tuledev. All rights reserved.
//

import XCTest
@testable import ShortPolling

class ShortPollingTests: XCTestCase {
  
  var pollingCenter = PollingCenter()
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
  }
  
  func test1Polling() {
    let expectation = XCTestExpectation(description: "testAsync")
    pollingCenter = PollingCenter()
    var count = 0
    let printPolling = PrintPolling()
    printPolling.listenEventFired {
      count += 1
    }
    pollingCenter.addPolling(printPolling)
    pollingCenter.enablePolling(printPolling.uid())
    
    let finish = {
      XCTAssertEqual(count, 10)
      expectation.fulfill()
    }
    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 9.5) {
      finish()
    }
    
    wait(for: [expectation], timeout: 11.0)
  }
  
  func test2Polling() {
    let expectation = XCTestExpectation(description: "testAsync")
    pollingCenter = PollingCenter()
    var count = 0
    var count2 = 0
    let printPolling = PrintPolling()
    printPolling.listenEventFired {
      count += 1
    }
    
    let printPolling2 = PrintPolling2()
    printPolling2.listenEventFired {
      count2 += 1
    }
    pollingCenter.addPolling(printPolling)
    pollingCenter.enablePolling(printPolling.uid())
    pollingCenter.addPolling(printPolling2)
    pollingCenter.enablePolling(printPolling2.uid())
    
    let finish = {
      XCTAssertEqual(count, 10)
      XCTAssertEqual(count2, 5)
      expectation.fulfill()
    }
    
    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 9.5) {
      finish()
    }

    wait(for: [expectation], timeout: 11.0)
  }
  func testStopPolling() {
    let expectation = XCTestExpectation(description: "testAsync")
    pollingCenter = PollingCenter()
    var count = 0
    let printPolling = PrintPolling()
    printPolling.listenEventFired {
      count += 1
    }
    pollingCenter.addPolling(printPolling)
    pollingCenter.enablePolling(printPolling.uid())
    
    let finish = {
      XCTAssertEqual(count, 5)
      expectation.fulfill()
    }
    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 4.5) {
      self.pollingCenter.disablePolling(printPolling.uid())
    }
    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 9.5) {
      finish()
    }
    
    wait(for: [expectation], timeout: 11.0)
  }
  
  func testAsyncPolling() {
    let expectation = XCTestExpectation(description: "testAsync")
    pollingCenter = PollingCenter()
    let printPolling = PrintPolling()
    let printPolling2 = PrintPolling()

    let finish = {
      expectation.fulfill()
    }
    
    let enablePolling: (Int) -> Void = { index in
      for _ in 0...100 {
        self.pollingCenter.enablePolling(printPolling.uid())
        self.pollingCenter.enablePolling(printPolling2.uid())
      }
    }
    let disablePolling: (Int) -> Void = { index in
      for _ in 0...100 {
        self.pollingCenter.disablePolling(printPolling.uid())
        self.pollingCenter.disablePolling(printPolling2.uid())
      }
    }


    let operationQueue: OperationQueue = OperationQueue()
    operationQueue.maxConcurrentOperationCount = 4

    operationQueue.addOperation {
      enablePolling(1)
    }
    operationQueue.addOperation {
      enablePolling(2)
    }
    operationQueue.addOperation {
      disablePolling(3)
    }
    operationQueue.addOperation {
      disablePolling(4)
    }

    operationQueue.waitUntilAllOperationsAreFinished()
    DispatchQueue.main.asyncAfter(wallDeadline: .now() + 8) {
      finish()
    }

    wait(for: [expectation], timeout: 10.0)
  }
  
}
