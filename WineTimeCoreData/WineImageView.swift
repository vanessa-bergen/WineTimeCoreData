//
//  WineImageView.swift
//  WineTime
//
//  Created by Vanessa Bergen on 2020-05-28.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI
import CoreData

struct WineImageView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @Binding var inputImage: UIImage?
    @State private var image: Image?
    @State private var showingImagePicker = false
    @State private var showingOptions = false
    @State private var pickerSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var imageAspectRatio: CGFloat = 1.0
    
    var body: some View {
        
        ZStack(alignment: .center) {
            image?
                .resizable()
                .aspectRatio(imageAspectRatio, contentMode: .fill)
                .frame(width: 150, height: 150, alignment: .center)
                .clipShape(Circle())
                .background(
                    Circle()
                        .fill(Color.white)
                    
                )
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                        
                )
                .shadow(radius: 15)
                
                                
            Button(action:{
                self.showingOptions = true
            }){
                
               Text("Select Image")
                    .offset(x: 0, y: 20)
                    .frame(width: 150, height: 170, alignment: .bottom)
                    .contentShape(Rectangle())
            }
                }
        .onAppear(perform: loadImage)
        // pass the inputImage property into our image picker, so it will be updated when the image is selected
        .sheet(isPresented: $showingImagePicker, onDismiss: setImage) {
            ImagePicker(inputImage: self.$inputImage, pickerSource: self.pickerSource)
        }
        .actionSheet(isPresented: $showingOptions) {
            ActionSheet(
                title: Text("Choose Option"),
                buttons: [
                    .default(Text("Take Photo")) {
                        self.pickerSource = .camera
                        self.showingImagePicker = true
                    },
                    .default(Text("Choose Photo")) {
                        self.pickerSource = .photoLibrary
                        self.showingImagePicker = true
                    },
                    .cancel()
                ]
            )
        }
    }
    // need to calculate the aspect ratio of the UIImage, otherwise vertical images will be stretched
    func calculateAspectRatio(image: UIImage) {
        let imageW = image.size.width
        let imageH = image.size.height
        self.imageAspectRatio = imageW/imageH
    }
    
    func setImage() {
        guard let inputImage = inputImage else { return }
        // here we are setting the swiftui image that will be shown
        image = Image(uiImage: inputImage)
        
        // calculate the aspect ratio of the uiImage, otherwise portrait photos are stretched on the x axis
        calculateAspectRatio(image: inputImage)
       
//        }
    }
    
    
    
    func loadImage() {
        calculateAspectRatio(image: inputImage!)
        self.image = Image(uiImage: inputImage!)
    }
}


