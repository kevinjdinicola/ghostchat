//
//  EstablishConnectionDataContext.swift
//  GhostChat
//
//  Created by Kevin Dinicola on 5/10/24.
//

import Foundation

enum ConnectionScreenMode: String, CustomStringConvertible {
    var description: String {
        return self.rawValue
    }
    
    case ready
    case showingCode
    case scanningCode
    case attemptingJoin
    case verify
}

@Observable
class EstablishConnectionDataContext: ObservableObject, EstablishConnectionDispatchResponder {

    func event(state: EstablishConnectionEvents) {
        switch state {
            
        case .joinTicketGenerated(let ticket):
            self.joinToken = ticket
            self.mode = .showingCode
            
        case .connectionEstablished(let iden):
            self.connectorsName = iden.name
            self.mode = .verify
            
        case .connectionConfirmed:
            print("do something")
            complete = true
        case .attemptingJoin:
            self.mode = .attemptingJoin
            
        case .connectionRejected:
            self.connectorsName = nil
            self.mode = .ready
            print("do something")
        case .picLoaded(let blobHash):
            connectorsPicBlobHash = blobHash
        }
        
    }
    
    // maybe keep track of some kind of connection state enum kinda like a state machine here?
    
    var joinToken: String?
    
    var connectorsPicBlobHash: WideId?
    var connectorsName: String?
    var mode: ConnectionScreenMode = .ready
    var complete: Bool = false
    
}
