//
//  WideButton.swift
//  GhostChat
//
//  Created by Kevin Dinicola on 5/10/24.
//

import SwiftUI

struct WideButton: View {
    
    let action: () -> Void;
    let text: String;
    
    var backgroundColor: Color = .blue;
    
    public init(text: String, backgroundColor: Color = .blue, action: @escaping () -> Void) {
        self.action = action
        self.text = text;
        self.backgroundColor = backgroundColor
    }
    
    var body: some View {
        Button(action: self.action) {
            Text(self.text)
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .background(backgroundColor)
                .foregroundColor(.white)
                .cornerRadius(15)
                .font(.title2)
        }
    }
}

#Preview {
    WideButton(text: "Push Me") {
        print("thanks")
    }
}
