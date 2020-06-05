//
//  ContentView.swift
//  WineTimeCoreData
//
//  Created by Vanessa Bergen on 2020-06-02.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

enum SortMethod {
    case alphabetical, country
}

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(
        entity: Type.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Type.typeName, ascending: true)]
    ) var types: FetchedResults<Type>
    
    @State private var showingAddSheet = false
    @State private var showingSortSheet = false
    @State private var sortMethod: SortMethod = .alphabetical
    
    var body: some View {
        NavigationView {
            VStack(alignment: .trailing) {
                Button(action: {
                    self.showingSortSheet = true
                }) {
                    Text(self.sortMethod == .alphabetical ? "Sorted By Name" : "Sorted By Country")
                    Image(systemName: "chevron.down")
                }
                .padding(.trailing)
                .actionSheet(isPresented: $showingSortSheet) {
                    ActionSheet(
                        title: Text("How do you want to sort?"),
                        buttons: [
                            .default(Text("Name")) {
                                self.sortMethod = .alphabetical
                            },
                            .default(Text("Country")) {
                                self.sortMethod = .country
                            }
                        ]
                    )
                }
                
                List {
                    
                    ForEach(types, id: \.self) { type in
                        SectionView(type: type, sortMethod: self.sortMethod)
                    }
                }
                //.listStyle(GroupedListStyle())
                .navigationBarTitle("Wines")
                .navigationBarItems(
                    leading: EditButton(),
                    trailing: Button(action: {
                        self.showingAddSheet = true
                        
                    }){
                        Image(systemName: "plus")
                            .imageScale(.large)
                            .padding()
                    })
                .sheet(isPresented: $showingAddSheet) {
                    NavigationView {
                        WineDetailsView(wine: nil, isNew: true, isPresented: self.$showingAddSheet).environment(\.managedObjectContext, self.moc)
                            .navigationBarItems(leading: Button(action: {
                                self.showingAddSheet = false
                            }) {
                                Text("Cancel")
                            })
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
