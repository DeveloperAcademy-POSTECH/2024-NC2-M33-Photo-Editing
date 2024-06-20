# 2024-NC2-M33-Photo Editing
## 🎥 Youtube Link
(추후 만들어진 유튜브 링크 추가)

## 💡 About Photo Editing
> **필터와 효과, 자르기 및 조정 등 사진 편집에 대한 기본적인 기능**

**이 기술은 어떻게 활용할 수 있을까요?**
> 
- 기본적인 사진 편집 개념을 모두 제공하여(빛, 색상, 효과, 디테일 등) 사진 앱 또는 카메라 앱 상에서 간편한 사진 편집시 사용 가능합니다.
- 사진 라이브러리에 접근하고 사진과 비디오 등을 편집, 저장할 수 있습니다.
    - ex ) 사용자가 사진 앱 내에서 바로 사용할 수 있는 고급 편집 도구를 제공할 수 있음
    - ex ) 사용자가 포토북, 캘린더, 카드 등을 쉽게 만들 수 있는 기능을 제공할 수 있음

## 🎯 What we focus on?
- **사진 크롭 기능 활용**
    - 기존에 제공되는 크롭 형태에서 커스텀을 통해 shape를 제공하여 사용자가 원하는 모양으로 사진을 클리핑할 수 있도록 하였습니다.
- **사진 필터 편집 활용**
    - 밝기, 색조, 대비, 채도 흐리게 등 간단한 필터들을 제공해 사진을 편집할 수 있도록 하였습니다.

## 💼 Use Case
> **‘하루 한 번 하늘보기 챌린지를 Photo Editing을 통해 기록하자!’**
- 하늘 한 번 볼 틈 없이 바쁜 일상을 보내는 직장인이 여유를 가지고 삶을 환기 시키기 위해 하루에 한 번씩 하늘 사진을 찍고 Photo Editing을 활용하여 사진을 편집해 캘린더에 등록합니다.

## 🖼️ Prototype

<table>
  <tbody>
    <tr>
      <td colspan="1" align="center"><b>메인 캘린더뷰</b></td>
      <td colspan="1" align="center"><b>사진 크롭뷰</b></td>
      <td colspan="1" align="center"><b>사진 필터뷰</b></td>
    </tr>
    <tr>
      <td align="center"><img src="https://github.com/DeveloperAcademy-POSTECH/2024-NC2-M33-Photo-Editing/assets/167501118/6bd4020e-d576-4b6f-9024-045ef3b1b90d" width="260px;" alt=""/></td>
      <td align="center"><img src="https://github.com/DeveloperAcademy-POSTECH/2024-NC2-M33-Photo-Editing/assets/167501118/d6368bf9-0463-421e-ae9b-b8b9c9165443" width="260px;" alt=""/></td>
      <td align="center"><img src="https://github.com/DeveloperAcademy-POSTECH/2024-NC2-M33-Photo-Editing/assets/167501118/159e7ed0-acd2-451b-855d-4ac57699ab43" width="260px;" alt=""/></td>
    </tr>
  </tbody>
</table>

## 🛠️ About Code
### 사진 크롭 기능(Image Crop)

```swift
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
}
```

- 이미지 로드 및 오버레이
    - 'overlay(content:)': 추가적인 레이어를 이미지 위에 올립니다. 여기서는 이미지의 위치와 크기를 추적하여 상호작용을 처리합니다.
    - 'Color.clear.onChange(of: isInteracting)': 상호작용 상태가 변경될 때마다 호출되는 콜백입니다. 이미지를 경계 내로 유지하기 위해 오프셋을 조정합니다.
- 이미지 조작
    - 'scaleEffect(scale)': 이미지의 확대/축소 비율을 설정합니다.
    - 'offset(offset)': 이미지의 위치를 조정합니다.

 ```swift
.gesture(
    DragGesture()
        .updating($isInteracting) { _, out, _ in
            out = true
        }
        .onChanged { value in
            let translation = value.translation
            offset = CGSize(width: translation.width + lastStoredOffset.width, height: translation.height + lastStoredOffset.height)
        }
)
.gesture(
    MagnificationGesture()
        .updating($isInteracting) { _, out, _ in
            out = true
        }
        .onChanged { value in
            let updatedScale = value + lastScale
            scale = (updatedScale < 1 ? 1 : updatedScale)
        }
        .onEnded { value in
            withAnimation(.easeInOut(duration: 0.2)) {
                if scale < 1 {
                    scale = 1
                    lastScale = 0
                } else {
                    lastScale = scale - 1
                }
            }
        }
)
.frame(cropSize)
.clipShape(CropShape(crop: crop))
```

- 제스처 처리
    - 'DragGesture': 드래그 제스처를 처리합니다. 사용자가 이미지를 드래그하면 오프셋을 업데이트합니다.
    - 'MagnificationGesture': 확대/축소 제스처를 처리합니다. 사용자가 이미지를 확대/축소하면 스케일을 업데이트합니다.
- 모양 클리핑
    - 'clipShape(CropShape(crop: crop))': CropShape를 사용하여 이미지를 자릅니다. CropShape는 자르기 모양을 정의하는 구조체입니다.

### 사진 필터 기능(Image Filter)
```swift
@State var brightnessAdjust: Double = 0 // 밝기
@State var contrastAdjust: Double = 1 // 대비
@State var hueAdjust: Double = 0 // 색조
@State var opacityAdjust: Double = 1 // 불투명도
@State var saturationAdjust: Double = 1 // 채도
```

- Filter 관련 변수들
    - 이 변수들은 필터 조정값을 저장합니다. 각각의 변수는 초기값으로 설정되어 있으며, FilterView에서 조정될 수 있습니다.
 
```swift
Image(uiImage: image)
    .resizable()
    .aspectRatio(contentMode: .fill)
    .overlay(content: {
        // GeometryReader와 onChange 등 기타 코드 생략
    })
    .frame(size)
    .opacity(opacityAdjust)
    .hueRotation(Angle(degrees: hueAdjust))
    .brightness(brightnessAdjust)
    .contrast(contrastAdjust)
    .saturation(saturationAdjust)

struct BrightnessAdjust: View {
    @Binding var brightnessAdjust : Double //밝기
    
    var body: some View {
        VStack {
            Slider(value: $brightnessAdjust, in: 0...1)
                .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
        }
    }
}
```

- ImageView에서 필터 적용
    - 이미지의 밝기, 대비, 색조, 불투명도, 채도를 조정할 수 있습니다.
    - 'Slider': 슬라이더를 이용하여 수치값을 변경할 수 있습니다.
