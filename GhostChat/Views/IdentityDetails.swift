//
//  IdentityDetails.swift
//  GhostChat
//
//  Created by Kevin Dinicola on 5/30/24.
//

import SwiftUI
import PhotosUI




struct IdentityDetails: View {
    
    @EnvironmentObject
    var global: GlobalDataContext;
    
    @State var selectedItems: [PhotosPickerItem] = []
    var gdispatch: GlobalAppDispatcherProtocol? = AppHostWrapper.shared.app?.globalDispatch()
    
    @StateObject
    var picData: BlobLoader = BlobLoader();
    
    
    var body: some View {
        VStack {
            PhotosPicker(selection: $selectedItems, maxSelectionCount: 1,
                         matching: .images,
                         photoLibrary: .shared()) {
                
                CircularImageView(data: picData.data, editable: true)
                    .frame(width: 150, height: 150)
                    .padding(.top, 100)
            }


            Text(global.assumedIdentity?.name ?? "no name")
                .font(.largeTitle)

            Spacer()
        }
        .onChange(of: selectedItems) {
            self.selectedItems[0].loadTransferable(type: Data.self) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let image?):
                        print("got data, emitting action")
                        gdispatch?.emitAction(action: .setIdentityPic(image))
                        // Handle the success case with the image.
                    case .success(nil):
                        print("nada")
                        // Handle the success case with an empty value.
                    case .failure(let error):
                        // Handle the failure case with the provided error.
                        print("failed")
                    }
                }
            }
        }
        .onChange(of: global.identityPic) {
            print("identity pic updated in swiftland!")
            picData.setHash(hash: global.identityPic!)
            AppHostWrapper.shared.app?.blobDispatch().hydrate(bdr: picData)
        }
        .onAppear {
            if let hash = global.identityPic {
                picData.setHash(hash: global.identityPic!)
                AppHostWrapper.shared.app?.blobDispatch().hydrate(bdr: picData)
            }
        }
    }
    
}

#Preview {
    let gdc = GlobalDataContext();
    gdc.assumedIdentity = Identification(publicKey: WideId(0), name: "kevin")

//    let bl = BlobLoader(withData: UIImage(named: "crow")!.pngData()!);
    let bl = BlobLoader()
    return IdentityDetails(picData: bl)
        .environment(gdc)
}
