//
//  BlobLoader.swift
//  GhostChat
//
//  Created by Kevin Dinicola on 5/30/24.
//

import Foundation

@Observable
class BlobLoader : ObservableObject, BlobDataResponder {
    
    var blobHash: WideId;
    var state: BlobDataState = BlobDataState.loading;
    
    init() {
        self.blobHash = WideId(0)
    }
    
    init(blobHash: WideId) {
        self.blobHash = blobHash
    }
    
    init(withData: Data) {
        self.blobHash = WideId(0)
        self.state = .loaded(withData)
    }
    
    func update(state: BlobDataState) {
        self.state = state;
    }
    
    func hash() -> WideId {
        blobHash
    }
    
    func setHash(hash: WideId) {
        self.blobHash = hash
    }
    
    var data: Data? {
        if case let .loaded(data) = state {
            return data
        } else {
            return nil
        }
    }
    
    var isLoading: Bool {
        if case .loading = state {
            return true
        } else {
            return false
        }
    }
    
}
