//
//  Notification-Extension.swift
//  WineTime
//
//  Created by Vanessa Bergen on 2020-05-29.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//
import SwiftUI

extension Notification {
    // the keyboardFrameEndUserInfoKey tells us the frame of the keyboard once it has finished animating
    // we are returning the height of the keyboard
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}
