//
//  CustomImagePicker.swift
//  NC2 Crop
//
//  Created by kwak on 6/14/24.
//

import SwiftUI
import PhotosUI

extension View {
    
    @ViewBuilder
    func cropImagePicker(options: [Crop],show: Binding<Bool>,croppedImage: Binding<UIImage?>)->some View {
        CustomImagePicker(options: options, show: show, croppedImage: croppedImage) {
            self
        }
    }
    
    @ViewBuilder
    func frame(_ size: CGSize)->some View {
        self
            .frame(width: size.width, height: size.height)
    }
    
    func haptics(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
}

fileprivate struct CustomImagePicker<Content: View>: View {
    var content: Content
    var options: [Crop]
    
    @Binding var show: Bool
    @Binding var croppedImage: UIImage?
    
    init(options: [Crop],show: Binding<Bool>,croppedImage: Binding<UIImage?>,@ViewBuilder content: @escaping ()->Content) {
        self.content = content()
        self._show = show
        self._croppedImage = croppedImage
        self.options = options
    }
    
    @State private var photosItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showDialog: Bool = false
    @State private var selectedCropType: Crop = .circle
    @State private var showCropView: Bool = false
    
    var body: some View {
        content
            .photosPicker(isPresented: $show, selection: $photosItem)
            .onChange(of: photosItem) {newValue in
                if let newValue {
                    Task {
                        if let imageData = try? await newValue.loadTransferable(type: Data.self),let image = UIImage(data: imageData) {
                            await MainActor.run(body: {
                                selectedImage = image
                                showDialog.toggle()
                            })
                        }
                    }
                }
            }
        
            .confirmationDialog("", isPresented: $showDialog) {
                ForEach(options.indices,id:\.self) {index in
                    Button(options[index].name()) {
                        selectedCropType = options[index]
                        showCropView.toggle()
                    }
                }
            }
            .fullScreenCover(isPresented: $showCropView) {
                selectedImage = nil
            } content: {
                CropView(crop: selectedCropType, image: selectedImage) { croppedImage, status in
                    if let croppedImage {
                        self.croppedImage = croppedImage
                    }
                }
            }
    }
}

struct CropView: View {
    
    @State var crop: Crop
    
    var image: UIImage?
    var onCrop: (UIImage?,Bool)->()
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var isShapeView = true
    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 0
    @State private var offset: CGSize = .zero
    @State private var lastStoredOffset: CGSize = .zero
    @GestureState private var isInteracting: Bool = false
    
    @State var brightnessAdjust : Double = 0 //밝기
    @State var contrastAdjust: Double = 1 //대비
    @State var hueAdjust: Double = 0 //색조
    @State var opacityAdjust: Double = 1 //불투명도
    @State var saturationAdjust: Double = 1 //채도
    
    var body: some View {
        NavigationStack {
            ZStack {
                ZStack {
                    if let image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 393, height: 550)
                            .opacity(0.4)
                            .blur(radius: 8)
                    }
                    
                    ImageView()
                        .padding(.top, 30)
                }
                .padding(.bottom, 160)
                
                VStack(spacing: 0) {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.white)
                            .frame(height: 120)
                            .frame(maxWidth: .infinity)
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "xmark")
                                    .font(Font.custom("SF Pro Display", size: 25))
                            }
                            .tint(.black)
                            .padding(.leading, 16)
                            
                            Spacer()
                            
                            Text("Edit.")
                                .font(
                                    Font.custom("Pretendard", size: 22)
                                        .weight(.bold)
                                )
                                .foregroundColor(.black)
                                .padding(15)
                            
                            Spacer()
                            
                            Button {
                                let renderer = ImageRenderer(content: ImageView(true))
                                renderer.proposedSize = .init(crop.size())
                                if let image = renderer.uiImage {
                                    onCrop(image,true)
                                } else {
                                    onCrop(nil,false)
                                }
                                dismiss()
                            } label: {
                                Text("저장")
                                    .fontWeight(.semibold)
                            }
                            .tint(.black)
                            .padding(.trailing, 16)
                        }
                        .padding(.top, 60)
                    }
                    
                    Spacer()
                    
                    ZStack {
                        Rectangle()
                            .foregroundColor(.white)
                            .frame(height: 220)
                            .frame(maxWidth: .infinity)
                        VStack {
                            if isShapeView {
                                ShapeView(crop: $crop, onShapeChange: { newCrop in
                                    // Shape 변경 후 CropView의 crop 변수 업데이트
                                    crop = newCrop
                                })
                            } else {
                                FilterView(brightnessAdjust: $brightnessAdjust, contrastAdjust: $contrastAdjust, hueAdjust: $hueAdjust, opacityAdjust: $opacityAdjust, saturationAdjust: $saturationAdjust)
                            }
                            
                            HStack {
                                Button(action: {
                                    isShapeView.toggle()
                                }) {
                                    Text("SHAPE")
                                        .padding(.leading, 55)
                                        .font(
                                            Font.custom("Pretendard", size: 16)
                                                .weight(.bold)
                                        )
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    Text("FILTER")
                                        .padding(.trailing, 55)
                                        .font(
                                            Font.custom("Pretendard", size: 16)
                                                .weight(.bold)
                                        )
                                        .foregroundColor(.black)
                                }
                                .padding(.bottom, 20)
                            }
                        }
                    }
                }
                .ignoresSafeArea()
            }
        }
    }
    
    @ViewBuilder
    func ImageView(_ hideGrids: Bool = false)->some View {
        let cropSize = crop.size()
        GeometryReader {
            let size = $0.size
            
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .overlay(content: {
                        GeometryReader { proxy in
                            let rect = proxy.frame(in: .named("CROPVIEW"))
                            
                            Color.clear
                                .onChange(of: isInteracting) { newValue in
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        if rect.minX > 0 {
                                            offset.width = (offset.width - rect.minX)
                                            haptics(.medium)
                                        }
                                        if rect.minY > 0 {
                                            offset.height = (offset.height - rect.minY)
                                            haptics(.medium)
                                        }
                                        if rect.maxX < size.width {
                                            offset.width = (rect.minX - offset.width)
                                            haptics(.medium)
                                        }
                                        if rect.maxY < size.height {
                                            offset.height = (rect.minY - offset.height)
                                            haptics(.medium)
                                        }
                                    }
                                    
                                    if !newValue {
                                        lastStoredOffset = offset
                                    }
                                }
                        }
                    })
                    .frame(size)
                    .opacity(opacityAdjust)
                    .hueRotation(Angle(degrees: hueAdjust))
                    .brightness(brightnessAdjust)
                    .contrast(contrastAdjust)
                    .saturation(saturationAdjust)
            }
        }
        .scaleEffect(scale)
        .offset(offset)
        .coordinateSpace(name: "CROPVIEW")
        .gesture(
            DragGesture()
                .updating($isInteracting, body: {_, out, _ in
                    out = true
                }).onChanged({ value in
                    let translation = value.translation
                    offset = CGSize(width: translation.width + lastStoredOffset.width, height: translation.height + lastStoredOffset.height)
                })
        )
        .gesture(
            MagnificationGesture()
                .updating($isInteracting, body: { _, out, _ in
                    out = true
                }).onChanged({ value in
                    let updatedScale = value + lastScale
                    scale = (updatedScale < 1 ? 1 : updatedScale)
                }).onEnded({ value in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        if scale < 1 {
                            scale = 1
                            lastScale = 0
                        } else {
                            lastScale = scale - 1
                        }
                    }
                })
        )
        .frame(cropSize)
        .clipShape(CropShape(crop: crop))
    }
}


#Preview {
    HomeView()
}
