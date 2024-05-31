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
    
    var identityPic: WideId?;
    
    func event(state: GlobalEvents) {
        switch state {
            
        case .identityNeeded:
            shouldShouldIdentityWelcome = true
        case .identitySelected(let iden):
            assumedIdentity = iden
            shouldShouldIdentityWelcome = false
        case .exchangeListChanged(let new_exchanges):
            exchanges = new_exchanges
        case .exchangeCreated(let exchangeId):
            ()
        case .identityPicUpdate(let blobHash):
            identityPic = blobHash
        }
    }
    
    var shouldShouldIdentityWelcome: Bool = false
    var assumedIdentity: Identification?
    
    
    var debug_showing = false;
    var debug_reset_data = false
}
