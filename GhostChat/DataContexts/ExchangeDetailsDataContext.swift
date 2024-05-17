//
//  ExchangeDetailsDataContext.swift
//  GhostChat
//
//  Created by Kevin Dinicola on 5/10/24.
//

import Foundation


@Observable
class ExchangeDetailsDataContext: ObservableObject, ExchangeDispatchResponder {
    func event(state: ExchangeEvents) {
        switch state {
            
        case .messagesReloaded(messages: let messages):
            self.messages = messages;
        case .messageReceived(message: let message):
            print("just got one message.. errr")
        case .nameChanged(let name):
            self.displayName = name
        case .liveConnectionsUpdated(count: let count):
            self.connections = count
        }
    }
    
    // maybe keep track of some kind of connection state enum kinda like a state machine here?
    var connections: UInt32 = 0;
    var displayName: String?
    var messages: [DisplayMessage] = []
    
}
