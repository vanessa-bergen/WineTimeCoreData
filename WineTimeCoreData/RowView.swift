//
//  RowView.swift
//  WineTime
//
//  Created by Vanessa Bergen on 2020-05-25.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct RowView: View {
    @Environment(\.managedObjectContext) var moc
    
    // added observed object so that when changes are made to the wine object, the list will be updated
    @ObservedObject var wine: Wine
    
    var body: some View {
        NavigationLink(destination: WineDetailsView(wine: wine, isNew: false, isPresented: .constant(true))) {
            HStack {
                VStack(alignment: .leading) {
                    Text(wine.wrappedName)
                        .font(.headline)
                    Text(wine.wrappedGrape == "" ? "Unknown Grape Type" : wine.wrappedGrape)
                        .font(.subheadline)
                }
                .padding(.leading, 5)
                
                Spacer()
                
                Text(wine.countryName)
                    .font(.subheadline)
                    .padding(.trailing, 5)
                        
                
            }
        }
    }
}

//struct RowView_Previews: PreviewProvider {
//    static var previews: some View {
//        RowView(wine: .constant(Wine.example))
//    }
//}
