//
//  IdentitySetup.swift
//  GhostChat
//
//  Created by Kevin Dinicola on 5/10/24.
//

import SwiftUI


struct IdentitySetup: View {
    
    @EnvironmentObject
    var global: GlobalDataContext;
    
    @State var nameText: String = "";

    
    var body: some View {
        VStack {
            Text("Welcome to GhostChat!").font(.title)
            Spacer()
            Spacer()
            Text("Please enter a name to create your identity")
            Spacer()
            TextField("Name", text: $nameText)
            Spacer()
            WideButton(text: "Create") {
                AppHostWrapper.shared.app?.globalDispatch().emitAction(action: .createIdentity(nameText))
            }
            
        }
        .padding()
        .frame(height: 300)
    }
}

#Preview {
    IdentitySetup()
}
