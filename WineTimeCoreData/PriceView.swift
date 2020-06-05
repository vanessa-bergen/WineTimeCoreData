//
//  PriceView.swift
//  WineTime
//
//  Created by Vanessa Bergen on 2020-05-25.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct PriceView: View {
    @Environment(\.managedObjectContext) var moc
    @Binding var price: Int
    
    var maxPrice = 3
    var onImage = "dollarFilled"
    var offImage = "dollarEmpty"
    
    var body: some View {
        HStack {
            ForEach(1..<maxPrice+1) { number in
                self.image(for: number)
                    .onTapGesture {
                        self.price = number
                    }
            }
        }
    }
    
    func image(for number: Int) -> Image {
        if number <= self.price {
            return Image(onImage)
        } else {
            return Image(offImage)
        }
    }
}

struct PriceView_Previews: PreviewProvider {
    static var previews: some View {
        PriceView(price: .constant(1))
    }
}
