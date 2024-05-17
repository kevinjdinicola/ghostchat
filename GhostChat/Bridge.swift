//
//  Bridge.swift
//  GhostChat
//
//  Created by Kevin Dinicola on 5/16/24.
//

import Foundation

extension WideId {
    func toString() -> String {
        wideidToString(wideId: self)
    }
    
    init(_ val: UInt64) {
        self.p1 = val;
        self.p2 = 0;
        self.p3 = 0;
        self.p4 = 0;
    }
}

extension WideId: CustomDebugStringConvertible {
    public var debugDescription: String {
        return self.toString()
    }
}

// Optionally, you can also conform to CustomStringConvertible
extension WideId: CustomStringConvertible {
    public var description: String {
        return self.toString()
    }
}
