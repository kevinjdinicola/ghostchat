//
//  AppHostWrapper.swift
//  GhostChat
//
//  Created by Kevin Dinicola on 5/10/24.
//

import Foundation

func getLibraryDataPath() -> String {
    var libraryPath = "";
    if let libraryDirectoryURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first {
        libraryPath = libraryDirectoryURL.appendingPathComponent("data").path
        if !FileManager.default.fileExists(atPath: libraryPath) {
            do {
                try FileManager.default.createDirectory(atPath: libraryPath, withIntermediateDirectories: true)
            } catch {
                print("failed to create data dir")
            }
            
        }
        print("Library data path: \(libraryPath)")
    }
    return libraryPath
}

class AppHostWrapper {
    static var shared = AppHostWrapper();
    
    var app: AppHostProtocol?;
    
    init() {
        let isPreview = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1";
        
        if !isPreview {
            print("starting app host...")
            let cfg = AppConfig(dataPath: getLibraryDataPath())
            
            self.app = AppHost(config: cfg)
        }

    }
    
}
