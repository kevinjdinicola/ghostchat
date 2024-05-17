//
//  ConnectionStatusIndicator.swift
//  GhostChat
//
//  Created by Kevin Dinicola on 5/17/24.
//

import SwiftUI

struct ConnectionStatusIndicator: View {
    
    let connection_count: UInt32;
    let healthy_threshold = 1;
    
    func calculateColor() -> Color {
        if connection_count < healthy_threshold {
            Color.gray;
        } else {
            Color.green;
        }
    }
    
    var body: some View {
        Circle()
            .fill(calculateColor())
            .frame(width: 10, height: 10)
    }
}

#Preview {
    ConnectionStatusIndicator(connection_count: 1)
}
