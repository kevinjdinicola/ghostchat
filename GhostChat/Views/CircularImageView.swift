//
//  CircularImageView.swift
//  GhostChat
//
//  Created by Kevin Dinicola on 5/30/24.
//

import SwiftUI

struct CircularImageView: View {
    
    var uiImage: UIImage?;
    var editable: Bool = false
    
    init(data: Data?, editable: Bool) {
        if let d = data {
            uiImage = UIImage(data: d)
        }
        self.editable = editable
    }
    init(uiImage: UIImage, editable: Bool) {
        self.uiImage = uiImage
        self.editable = editable
    }
    
    var body: some View {
        ZStack {
            Group {
                if let img = uiImage {
                    Image(uiImage: img)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .foregroundStyle(Color.black.opacity(0.3))
                } else {
                    Image(systemName: "questionmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(50)
                        .foregroundStyle(Color.black.opacity(0.3))
                }
            }
            if editable {
                VStack  {
                    Spacer()
                    ZStack {
                        Rectangle()
                            .fill(Color.black.opacity(0.2))
                            .frame(height: 35)
                        Text("Edit").foregroundStyle(Color.white)
                            .padding(.bottom, 10)
                    }
                    
                }
            }
            
            
        }
        .background(Color.gray)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.white, lineWidth: 4))
        .shadow(radius: 10)
    }
}


#Preview {
    CircularImageView(data: nil, editable: true)
}
