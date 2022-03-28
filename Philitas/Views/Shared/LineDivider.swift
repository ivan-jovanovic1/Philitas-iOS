//
//  Divider.swift
//  Philitas
//
//  Created by Ivan Jovanović on 28/03/2022.
//

import SwiftUI



struct LineDivider: View {
    
    let text: String
    let color: Color
    
    init(
        _ text: String,
        color: Color = .gray
    ) {
        self.text = text
        self.color = color
    }
    
    var body: some View {
        HStack {
            rectangle()
            
            Text(text.uppercased())
            
            rectangle()
        }
    }
}

extension LineDivider {
    
    @ViewBuilder
    private func rectangle() -> some View {
        Rectangle()
            .foregroundColor(color)
            .frame(maxWidth: .infinity, maxHeight: 1)
    }
    
}

struct LineDivier_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            LineDivider("Example")
            
            LineDivider("Second example", color: .black)
        }
            .previewDevice("iPhone 13 Pro")
    }
}

