//
//  ViewController.swift
//  ExSwizzleMethod
//
//  Created by Jake.K on 2022/03/14.
//

import UIKit

class ViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    Self.swizzleMethod()
    self.someMethod()
  }
  
  @objc open func someMethod() {
    print("iOS앱 개발 알아가기 - 원본")
  }
}

extension ViewController {
  class func swizzleMethod() {
    guard
      let originalMethod = class_getInstanceMethod(Self.self, #selector(Self.someMethod)),
      let swizzledMethod = class_getInstanceMethod(Self.self, #selector(Self.anotherMethod))
    else { return }
    method_exchangeImplementations(originalMethod, swizzledMethod)
  }
  
  @objc private func anotherMethod() {
    print("iOS앱 개발 알아가기 - 스위즐링")
  }
}
