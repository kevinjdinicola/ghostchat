//
//  MessageView.swift
//  GhostChat
//
//  Created by Kevin Dinicola on 5/10/24.
//

import SwiftUI

struct MessageView: View {
    var message: DisplayMessage
    var body: some View {
        VStack(alignment: .leading, content: {
            
//            !message.isSelf ? Text(message.sender + ":")
//                .bold()
//                .foregroundColor(Color.gray)
//            : nil
            
            Text(message.text)
                .padding(10)
                .background(message.isSelf ? Color.gray : Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(10)
            
        })
        
    }
}

#Preview {
    MessageView(message: DisplayMessage(id: 1, text: "me", isSelf: true))
}
