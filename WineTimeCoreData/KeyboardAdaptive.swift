//
//  KeyboardAdaptive.swift
//  WineTime
//
//  Created by Vanessa Bergen on 2020-06-02.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI
import Combine

// creating a view modifier that will move the view up when the keyboard is shown

struct KeyboardAdaptive: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboardHeight)
            .onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
    }
}

extension View {
    func modifyKeyboardAdaptive() -> some View {
        self.modifier(KeyboardAdaptive())
    }
}
