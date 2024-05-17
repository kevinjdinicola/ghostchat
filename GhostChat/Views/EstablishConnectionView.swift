//
//  CreateConnection.swift
//  GhostChat
//
//  Created by Kevin Dinicola on 5/10/24.
//

import SwiftUI

struct ScanButton: View {
    
    let action: () -> Void;
    let imageName: String;
    let text: String
    
    public init(text: String, imageName: String, action: @escaping () -> Void) {
        self.action = action
        self.text = text
        self.imageName = imageName
    }
    
    var body: some View {
        Button(action: self.action, label: {
            VStack {
                Image(systemName: self.imageName)
                    .resizable()
                    .scaledToFit()
                    .padding()
                
                // Caption text
                Text(self.text)
                    .font(.title)
            }
        })
    }
    
}



struct EstablishConnectionView: View {
    @Binding
    var showingInSheet: Bool
    
    @EnvironmentObject
    var global: GlobalDataContext
    
    @StateObject
    var model: EstablishConnectionDataContext = EstablishConnectionDataContext();
    
    @State var dispatch: EstablishConnectionDispatcherProtocol?;
    
    @State var scanResult: String = ""

    
    // file sharing shit
    @State var isSharingViaFile = false
    @State private var fileURL: URL?
    
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                let context = CIContext()
                if let cgImage = context.createCGImage(output, from: output.extent) {
                    return UIImage(cgImage: cgImage)
                }
            }
        }
        
        return nil
    }
    
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Connect").font(.largeTitle).bold()
                .padding(.bottom, 10)
  
            switch self.model.mode {
            case .verify:
                VStack {
                    Text("Connect with this person?")
                        .padding(.bottom, 50).font(.title2)
                    Text(model.connectorsName ?? "unknown").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).bold()
                    Spacer()
                    HStack {
                        WideButton(text: "Deny", backgroundColor: .red) {
                            dispatch?.emitAction(action: .rejectConnection)
                            // emit action to deny, clear out any state
                        }
                        WideButton(text: "Confirm", backgroundColor: .green) {
                            dispatch?.emitAction(action: .acceptConnection)
                            self.showingInSheet = false
                        }
                    }

                    
                }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            case .ready:
                VStack {
                    HStack {
                        ScanButton(text: "Show Code", imageName: "qrcode") {
                            self.dispatch?.emitAction(action: .generateJoinTicket);
                        }
                        ScanButton(text: "Receive Code", imageName: "qrcode.viewfinder") {
                            self.model.mode = .scanningCode
                        }
                    }
                    .foregroundColor(.gray)
                    
                }
            case .showingCode:
                VStack {
                    Spacer()
                    Image(uiImage: generateQRCode(from: model.joinToken!)!)
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(1, contentMode: .fit)
                    Spacer()
                    HStack {
                        ProgressView().padding(.trailing, 10)
                        Text("Waiting for connection")
                    }
                    .padding(.bottom)
                    Button("or copy to clipboard") {
                        let pasteboard = UIPasteboard.general
                        pasteboard.string = model.joinToken!
                    }
                    Spacer()
                    
                    WideButton(text: "Cancel") {
                        print("MAKE THIS BETTER")
                        self.dispatch?.unregisterResponder();
                        self.dispatch = AppHostWrapper.shared.app?.createEstablishConnectionDispatch()
                        self.dispatch?.registerResponder(responder: self.model)
                        self.model.mode = .ready
                    }
                }
            case .attemptingJoin:
                VStack(alignment: .center) {
                    Spacer()
                    ProgressView().padding(.bottom, 10)
                    Text("Establishing connection")
                    Spacer()
                }.frame(maxWidth: .infinity)
            case .scanningCode:
                VStack {
                    ZStack {
                        VStack {
                            Image(systemName: "camera")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                            Text("Loading camera")
                        }
                        
                        QRScanner(result: $scanResult)
                    }
                    .background(.gray)
                    .cornerRadius(10)
                    .padding()
                    .scaledToFill()
                    .aspectRatio(1, contentMode: .fit)
                    .clipped()
                    Button("or paste from clipboard") {
                        let pasteboard = UIPasteboard.general
                        if let clipboardString = pasteboard.string {
                            dispatch?.emitAction(action: .receivedJoinTicket(clipboardString))
                        }
                    }
                    
                    
                    Spacer()
                    WideButton(text: "Cancel") {
                        self.model.mode = .ready
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .onChange(of: scanResult) {
            if scanResult.count > 0 {
                dispatch?.emitAction(action: .receivedJoinTicket(scanResult))
            }
        }
        .onChange(of: model.complete) {
            self.showingInSheet = false
        }
        .onAppear(perform: {
            self.dispatch = AppHostWrapper.shared.app?.createEstablishConnectionDispatch();
            self.dispatch?.registerResponder(responder: self.model);
        });
        
    }
}

#Preview {
    let ecdc = EstablishConnectionDataContext();
    ecdc.joinToken="asdf"
    ecdc.mode = .scanningCode
    return EstablishConnectionView(showingInSheet: .constant(true), model: ecdc)
        .environmentObject(GlobalDataContext())
}
