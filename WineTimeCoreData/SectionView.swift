//
//  SectionView.swift
//  WineTime
//
//  Created by Vanessa Bergen on 2020-05-25.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct SectionView: View {
    @Environment(\.managedObjectContext) var moc
    
    // added observed object so that when records are deleted, the list will update right away
    @ObservedObject var type: Type
    
    var sortMethod: SortMethod
    var sortClosure: (Wine, Wine) -> Bool {
        sortMethod == .alphabetical ? { (a: Wine, b: Wine) -> Bool in a.wrappedName < b.wrappedName } : { (a: Wine, b: Wine) -> Bool in a.countryName < b.countryName }
    }
    
    let sectionColor = Color(red: 165.0/255.0, green: 165.0/255.0, blue: 165.0/255.0)
    let shadowColor = Color(red: 255.0/255.0, green: 232/255.0, blue: 147/255.0)
    
    var body: some View {
        Group {
            if !type.wineArray.isEmpty {
                Section(header:
                    HStack {
                        Image(type.wrappedType)
                            .resizable()
                            .scaledToFit()
                            .shadow(color: shadowColor, radius: 10)
                            .frame(width: 24.0, height: 24.0, alignment: .top)
                        Text(type.wrappedType)
                            .font(.system(.headline, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    .padding(.leading, 10)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
                    .listRowInsets(EdgeInsets())
                    .background(sectionColor)
                    
                ) {
                    ForEach(type.wineArray.sorted(by: sortClosure), id: \.self) { wine in
                        RowView(wine: wine)
                    }
                    .onDelete(perform: removeWine(at:))
                }
            }
        }
    }
    // remove the wines from the sections
    func removeWine(at offsets: IndexSet) {
        for offset in offsets {
            let wine = type.wineArray.sorted(by: sortClosure)[offset]
            moc.delete(wine)
            if self.moc.hasChanges {
                try? self.moc.save()
            }
        }
    }
}


