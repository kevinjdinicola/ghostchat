//
//  ExchangeRow.swift
//  GhostChat
//
//  Created by Kevin Dinicola on 5/10/24.
//

import SwiftUI

struct ExchangeRow: View {
    
    var data: ExchangeListItem
    
    @StateObject
    var picData: BlobLoader = BlobLoader()

    var body: some View {
        HStack {
            if let d = picData.data {
                Image(uiImage: UIImage(data: d)!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            }
            Text(data.label)
            Spacer()
            ConnectionStatusIndicator(connection_count: data.connections)
        }
        .onAppear() {
            if let pic = self.data.pic {
                picData.setHash(hash: pic)
                AppHostWrapper.shared.app?.blobDispatch().hydrate(bdr: picData)
            }
        }
        
    }
}

#Preview {
        let bl = BlobLoader(withData: UIImage(named: "crow")!.pngData()!);
    return ExchangeRow(data: ExchangeListItem(id: WideId(p1: 0, p2: 0, p3: 0, p4: 0), label: "Homer simpson", pic: nil, connections: 1), picData: bl)
}
