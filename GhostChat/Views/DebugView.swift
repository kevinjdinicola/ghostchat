//
//  DebugView.swift
//  GhostChat
//
//  Created by Kevin Dinicola on 5/16/24.
//

import SwiftUI

struct DebugView: View {
    
    @EnvironmentObject
    var global: GlobalDataContext;
    
    var body: some View {
        VStack {
            Text("Debug Menu")
            WideButton(text: "Delete All Data", backgroundColor: .red, action: {
                AppHostWrapper.shared.app?.setResetFlag()
                AppHostWrapper.shared.app?.shutdown();
                exit(0)
            })
            Spacer()
            WideButton(text: "close", action: {
                global.debug_showing = false
            })
        }.padding()
        
    }
}

#Preview {
    DebugView()
}
