//
//  ExchangeRow.swift
//  GhostChat
//
//  Created by Kevin Dinicola on 5/10/24.
//

import SwiftUI

struct ExchangeRow: View {
    
    var data: ExchangeListItem
    
    var body: some View {
        HStack {
            Text(data.label)
            Spacer()
            ConnectionStatusIndicator(connection_count: data.connections)
        }
        .padding()
        
    }
}

#Preview {
    ExchangeRow(data: ExchangeListItem(id: WideId(p1: 0, p2: 0, p3: 0, p4: 0), label: "Homer simpson", connections: 1))
}
