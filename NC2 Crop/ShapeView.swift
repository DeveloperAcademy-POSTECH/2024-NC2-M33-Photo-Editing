//
//  ShapeView.swift
//  NC2 Crop
//
//  Created by kwak on 6/19/24.
//

import SwiftUI

struct ShapeView: View {
    
    @Binding var crop: Crop
    var onShapeChange: (Crop) -> Void
    
    var body: some View {
        HStack {
            Button {
                crop = .circle
                onShapeChange(crop)
            } label: {
                CropShape(crop: .circle)
                    .frame(width: 80, height: 80)
                    .foregroundColor(.black)
            }
            
            Button {
                crop = .starShape
                onShapeChange(crop)
            } label: {
                CropShape(crop: .starShape)
                    .frame(width: 115, height: 115)
                    .foregroundColor(.black)
                    .padding(EdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 25))
            }
            
            Button {
                crop = .rectangle
                onShapeChange(crop)
            } label: {
                CropShape(crop: .rectangle)
                    .frame(width: 75, height: 75)
                    .foregroundColor(.black)
            }
        }
        .padding(.bottom, 25)
    }
}


