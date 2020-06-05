//
//  Publishers-Extension.swift
//  WineTime
//
//  Created by Vanessa Bergen on 2020-05-29.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//
import SwiftUI
import Combine

extension Publishers {
    // keyboardHeight emits CGFloat and can never return with an error
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        // iOS sends out notifications for when things happen
        // here we are watching for when the keyboard is shown and when its hidden
        // so we wrap the willshow and willhide in publishers
        // we are only interested in getting the height
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }
        
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        
        // combine multiple publishers into one
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}
