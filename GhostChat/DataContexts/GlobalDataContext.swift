//
//  GlobalDataContext.swift
//  GhostChat
//
//  Created by Kevin Dinicola on 5/10/24.
//

import Foundation

@Observable
class GlobalDataContext: ObservableObject, GlobalDispatchResponder {
    
    var exchanges: [ExchangeListItem] = [];
    
    func event(state: GlobalEvents) {
        switch state {
            
        case .identityNeeded:
            shouldShouldIdentityWelcome = true
        case .identitySelected(let iden):
            assumed_identity = iden
            shouldShouldIdentityWelcome = false
        case .exchangeListChanged(let new_exchanges):
            exchanges = new_exchanges;
        case .exchangeCreated(let exchangeId):
            ()
        }
    }
    
    var shouldShouldIdentityWelcome: Bool = false
    var assumed_identity: Identification?
    
    
    var debug_showing = false;
    var debug_reset_data = false
}
