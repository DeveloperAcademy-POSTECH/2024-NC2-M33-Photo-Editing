//
//  FilterView.swift
//  NC2 Crop
//
//  Created by kwak on 6/14/24.
//

import SwiftUI

struct FilterView: View {
    
    enum EditState {
        case brightness
        case contrast
        case hue
        case opacity
        case chroma
    }
    
    @State var editState: EditState = .brightness
    
    @Binding var brightnessAdjust : Double //밝기
    @Binding var contrastAdjust: Double //대비
    @Binding var hueAdjust: Double  //색조
    @Binding var opacityAdjust: Double //불투명도
    @Binding var saturationAdjust: Double //채도
    
    var body: some View {
        VStack {
            
            switch editState {
            case .brightness:
                BrightnessAdjust(brightnessAdjust: $brightnessAdjust)
            case .contrast:
                ContrastAdjust(contrastAdjust: $contrastAdjust)
            case .hue:
                HueAdjust(hueAdjust: $hueAdjust)
            case .opacity:
                OpacityAdjust(opacityAdjust: $opacityAdjust)
            case .chroma:
                SaturationAdjust(saturationAdjust: $saturationAdjust)
            }
            
            HStack {
                VStack {
                    Button(action: {
                        editState = .brightness
                    }) {
                        Image(systemName:"microbe.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .padding(.bottom, 14)
                    }
                    Text("밝기")
                        .font(
                            Font.custom("Pretendard", size: 14)
                                .weight(.bold)
                        )
                }
                .foregroundColor(editState == .brightness ? Color.black : Color.gray)
                .padding(20)
                
                VStack {
                    Button(action: {
                        editState = .contrast
                    }) {
                        Image(systemName:"circle.lefthalf.filled")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .padding(.bottom, 14)
                    }
                    Text("대비")
                        .font(
                            Font.custom("Pretendard", size: 14)
                                .weight(.bold)
                        )
                }
                .foregroundColor(editState == .contrast ? Color.black : Color.gray)
                .padding(20)
                
                VStack {
                    Button(action: {
                        editState = .hue
                    }) {
                        Image(systemName:"drop.halffull")
                            .resizable()
                            .frame(width: 20, height: 28)
                            .padding(.bottom, 14)
                    }
                    Text("색조")
                        .font(
                            Font.custom("Pretendard", size: 14)
                                .weight(.bold)
                        )
                }
                .foregroundColor(editState == .hue ? Color.black : Color.gray)
                .padding(20)
                
                VStack {
                    Button(action: {
                        editState = .opacity
                    }) {
                        Image(systemName:"circle.lefthalf.filled.righthalf.striped.horizontal.inverse")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .padding(.bottom, 14)
                    }
                    Text("흐리게")
                        .font(
                            Font.custom("Pretendard", size: 14)
                                .weight(.bold)
                        )
                }
                .foregroundColor(editState == .opacity ? Color.black : Color.gray)
                .padding(20)
                
                VStack {
                    Button(action: {
                        editState = .chroma
                    }) {
                        Image(systemName:"lightspectrum.horizontal")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .padding(.bottom, 14)
                    }
                    Text("채도")
                        .font(
                            Font.custom("Pretendard", size: 14)
                                .weight(.bold)
                        )
                }
                .foregroundColor(editState == .chroma ? Color.black : Color.gray)
                .padding(20)
            }
        }
    }
}

struct BrightnessAdjust: View {
    @Binding var brightnessAdjust : Double //밝기
    
    var body: some View {
        VStack {
            Slider(value: $brightnessAdjust, in: 0...1)
                .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
        }
    }
}

struct ContrastAdjust: View {
    @Binding var contrastAdjust: Double //대비
    
    var body: some View {
        VStack {
            Slider(value: $contrastAdjust, in: 0...1)
                .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
        }
    }
}

struct HueAdjust: View {
    @Binding var hueAdjust: Double  //색조
    
    var body: some View {
        VStack {
            Slider(value: $hueAdjust, in: 0...90)
                .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
        }
    }
}

struct OpacityAdjust: View {
    @Binding var opacityAdjust: Double //불투명도
    
    var body: some View {
        VStack {
            Slider(value: $opacityAdjust, in: 0...1)
                .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
        }
    }
}

struct SaturationAdjust: View {
    @Binding var saturationAdjust: Double //채도
    
    var body: some View {
        VStack {
            Slider(value: $saturationAdjust, in: 0...1)
                .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
        }
    }
}

extension FilterView {
    enum FilterType {
        case brightness, contrast, hue, opacity, chroma
    }
}


