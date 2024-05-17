//
//  GhostChatApp.swift
//  GhostChat
//
//  Created by Kevin Dinicola on 5/10/24.
//

import SwiftUI

@main
struct GhostChatApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var global: GlobalDataContext;
    
    init() {
        let app = AppHostWrapper.shared.app;
        self.global = GlobalDataContext();
        
        let globalDispatch = app?.globalDispatch();
        globalDispatch?.registerResponder(responder: self.global)
        
        
        self.global.shouldShouldIdentityWelcome = false
    
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environment(self.global)
    }
}
