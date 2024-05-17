//
//  QRScanner.swift
//  GhostChat
//
//  Created by Kevin Dinicola on 5/10/24.
//

import SwiftUI
import AVFoundation

class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    
    @Binding var scanResult: String
    
    init(_ scanResult: Binding<String>) {
        self._scanResult = scanResult
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            scanResult = ""
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr,
           let result = metadataObj.stringValue {
            
            scanResult = result           
        }
    }
}

struct QRScanner: UIViewControllerRepresentable {
    
    @Binding var result: String
    
    func makeUIViewController(context: Context) -> QRScannerController {
        let controller = QRScannerController()
        controller.delegate = context.coordinator
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: QRScannerController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator($result)
    }
    
}

#Preview {
    QRScanner(result: .constant(""))
}
