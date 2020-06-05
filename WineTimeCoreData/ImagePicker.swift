//
//  ImagePicker.swift
//  Instafilter
//
//  Created by Vanessa Bergen on 2020-05-07.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import Foundation
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    // used to dismiss the view when the image is chosen
    @Environment(\.presentationMode) var presentationMode
    @Binding var inputImage: UIImage?
    var pickerSource: UIImagePickerController.SourceType
    
    // need to use coordinators to be notified when an image is selected
    // handles communication from the UIImagePikcerController
    // SwiftUI’s coordinators are designed to act as delegates for UIKit view controllers
    // NSObject is the parent class for almost everything in UIKit. NSObject allows Objective-C to ask the object what functionality it supports at runtime, which means the image picker can say things like “hey, the user selected an image, what do you want to do?”
    // UIImagePickerControllerDelegate protocol is what adds functionality for detecting when the user selects an image. (NSObject lets Objective-C check for the functionality; this protocol is what actually provides it.)
    // UINavigationControllerDelegate protocol lets us detect when the user moves between screens in the image picker.
    class Coordinator: NSObject, UIImagePickerControllerDelegate,
    UINavigationControllerDelegate  {
        
        // tell the coordinator what is parent is, that way it can modify values from the parent
        // add parent to the initializer
        var parent: ImagePicker
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        // this method receives a dictionary where the keys are of the type UIImagePickerController.InfoKey, and the values are of the type Any
        // we need to find the image selected, assign it to the parent and dismiss the view
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let uiImage = info[.originalImage] as? UIImage {
                // setting the inputImage binding
                parent.inputImage = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        // setting self (the ImagePicker struct) as the parent in the coordinator
        Coordinator(self)
    }
    
    // here we are creating the UIImagePickerController
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = pickerSource
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    
}
