//
//  WineDetailsView.swift
//  WineTimeCoreData
//
//  Created by Vanessa Bergen on 2020-06-02.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct WineDetailsView: View {
    @Environment(\.managedObjectContext) var moc
    
    var wine: Wine?
    var isNew: Bool
    @Binding var isPresented: Bool
    
    @State private var name: String = ""
    @State private var grape: String = ""
    @State private var comments: String = ""
    @State private var country: Int = 2
    @State private var price: Int = 2
    @State private var type: String = "Red"
    @State private var inputImage: UIImage? = UIImage(named: "Placeholder")
    @State private var showingRegion = false
    @State private var region = ""
    
    let wineTypes = ["Red", "White", "Rose", "Specialty"]
    
    var title: String {
        isNew == true ? "Add New Wine" : "Wine Details"
    }
    
    var disableSave: Bool {
        if self.name.trimmingCharacters(in: .whitespaces).isEmpty {
            return true
        }
        return false
    }
    
    // create an initializer to set the state values to core data values
    init(wine: Wine?, isNew: Bool, isPresented: Binding<Bool>) {
        
        self.wine = wine
        self.isNew = isNew
        self._isPresented = isPresented
        
        if !isNew {
            guard let wine = self.wine else {
                return
            }
            // initializing state values without going through the property wrapper
            self._name = State<String>(initialValue: wine.wrappedName)
            self._grape = State<String>(initialValue: wine.wrappedGrape)
            self._comments = State<String>(initialValue: wine.wrappedComments)
            self._country = State<Int>(initialValue: Int(wine.country))
            self._price = State<Int>(initialValue: Int(wine.price))
            self._type = State<String>(initialValue: wine.type?.wrappedType ?? "Red")
            self._showingRegion = State<Bool>(initialValue: wine.hasRegion)
            self._region = State<String>(initialValue: wine.wrappedRegion)
            
            guard let imageData = wine.image else {
                return
            }
            self._inputImage = State<UIImage?>(initialValue: UIImage(data: imageData))
            
        }
    }
    
    var body: some View {
        
        Form {

            WineImageView(inputImage: $inputImage)
                .padding(.bottom)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)

            
            Section {
                Picker("Wine Type", selection: $type) {
                    ForEach(wineTypes, id: \.self) { category in
                        Text(category)
                            .tag(category)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                //.disabled(!isNew)
            }
            
            Section(header: Text("Info")) {
                TextField("Wine Name", text: $name)
                TextField("Wine/Grape Type", text: $grape)

            }
            
            Section(header: Text("Location")) {
                Picker(selection: $country, label: Text("Country")) {
                    ForEach(0..<Wine.countries.count, id: \.self) { index in
                        HStack {
                            Image(Wine.countries[index])
                                .FlagImage()
                                .frame(width: 25, height: 25)
                            Text(Wine.countries[index])
                        }
                    }
                }
                Toggle(isOn: $showingRegion.animation()) {
                    Text("Add Region?")
                }
                if showingRegion {
                    TextField("Region", text: $region)
                }
            }
            
            Section(header: Text("Price")) {
                PriceView(price: $price)
            }
            
            Section(header: Text("Thoughts?")) {
                TextField("Comments", text: $comments)
            }
            
            if isNew {
                Button("Save") {
                    
                    let newWine = Wine(context: self.moc)
                    newWine.name = self.name
                    newWine.grape = self.grape
                    newWine.country = Int16(self.country)
                    newWine.price = Int16(self.price)
                    newWine.comments = self.comments
                    
                    newWine.image = self.inputImage!.jpegData(compressionQuality: 1.0) as Data?
                    newWine.type = Type(context: self.moc)
                    newWine.type?.typeName = self.type
                    self.save()
                    
                    self.checkRegionEnabled()
                    newWine.hasRegion = self.showingRegion
                    newWine.region = self.region
                    
                    // dismiss the view after the save
                    self.isPresented = false
                    
                }
                .disabled(disableSave)
            }
        }
        
        .navigationBarTitle(Text(title), displayMode: .inline)
        .modifyKeyboardAdaptive()
            .onDisappear {
                // saving any changes to existing wine object when the form dissappears
                guard let wine = self.wine else {
                    return
                }
                wine.image = self.inputImage!.jpegData(compressionQuality: 1.0) as Data?
                
                // if the type has changed, create new Type object
                if wine.type?.typeName != self.type {
                    wine.type = Type(context: self.moc)
                    wine.type?.typeName = self.type
                }
                wine.name = self.name
                wine.grape = self.grape
                wine.country = Int16(self.country)
                wine.price = Int16(self.price)
                wine.comments = self.comments
                
                self.checkRegionEnabled()
                wine.region = self.region
                wine.hasRegion = self.showingRegion
                
                self.save()
        }
        
    }
    

    func save() {
        if self.moc.hasChanges {
            try? self.moc.save()
        }
    }
    
    func checkRegionEnabled() {
        // if the showingRegion toggle is set to true, make sure there is a region written, if not set the toggle to false
        if self.showingRegion {
            if self.region.trimmingCharacters(in: .whitespaces).isEmpty {
                self.showingRegion = false
            }
        } else {
            // if the toggle is not enabled, set the region to empty string
            self.region = ""
        }
    }
}


extension Image {
    // modifiying the flag image
    func FlagImage() -> some View {
        self
            .renderingMode(.original)
            .resizable()
            .clipShape(Capsule())
            .shadow(color: .black, radius: 2)
    
    }
}
