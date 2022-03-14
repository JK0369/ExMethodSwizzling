//
//  Swizzling+UIViewController.swift
//  ExSwizzleMethod
//
//  Created by Jake.K on 2022/03/14.
//

import UIKit

final private class Deallocator {
  var closure: () -> Void
  
  init(_ closure: @escaping () -> Void) {
    self.closure = closure
  }
  
  deinit {
    closure()
  }
}

private var associatedObjectAddr = ""

extension UIViewController {
  class func swizzleMethodForDealloc() {
    guard
      let originalMethod = class_getInstanceMethod(Self.self, #selector(viewDidLoad)),
      let swizzledMethod = class_getInstanceMethod(Self.self, #selector(swizzled_viewDidLoad))
    else { return }
    method_exchangeImplementations(originalMethod, swizzledMethod)
  }
  
  @objc private func swizzled_viewDidLoad() {
    print("viewDidLoad()보다 먼저 실행")
    let deallocator = Deallocator { print("deinit: \(Self.self)") }
    objc_setAssociatedObject(self, &associatedObjectAddr, deallocator, .OBJC_ASSOCIATION_RETAIN)
  }
}
