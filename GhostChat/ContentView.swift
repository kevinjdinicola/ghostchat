//
//  ContentView.swift
//  GhostChat
//
//  Created by Kevin Dinicola on 5/10/24.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject
    var globalData: GlobalDataContext;
    
    
    var body: some View {
        ZStack {

            ExchangeList()
                .sheet(isPresented: $globalData.shouldShouldIdentityWelcome, content: {
                    IdentitySetup().interactiveDismissDisabled()
                })
                .onChange(of: globalData.assumed_identity) {
                    print("welcome " + globalData.assumed_identity!.name)
                }
            
            if globalData.debug_showing {
                DebugView()
                    .background(.regularMaterial)
            }
        }
        
    }
}

#Preview {

    let global = GlobalDataContext();
    global.shouldShouldIdentityWelcome = false;
    
    return ContentView()
        .environment(global)
}
