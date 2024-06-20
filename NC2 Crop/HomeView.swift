//
//  HomeView.swift
//  NC2 Crop
//
//  Created by kwak on 6/14/24.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showPicker: Bool = false
    @State private var croppedImage: UIImage?
    
    var body: some View {
        NavigationStack {
            VStack {
                if let croppedImage {
                    Image(uiImage: croppedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 350, height: 350)
                } else {
                    Text("No Image is Selected")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Crop Image PIcker")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showPicker.toggle()
                    } label: {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.callout)
                    }
                    .tint(.black)
                }
            }
            .cropImagePicker(options: [.circle, .rectangle, .starShape], show: $showPicker, croppedImage: $croppedImage)
        }
    }
}

#Preview {
    HomeView()
}
