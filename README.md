# OneThingPerPage

SwiftUI로 이루어진 “**한 화면, 한 가지 기능**”을 단순화·집중화하기 위한 컴포넌트 라이브러리입니다.  
( **GitHub**: [https://github.com/cheshire0105/OneThingPerPage](https://github.com/cheshire0105/OneThingPerPage) )

## 주요 기능

| ![](https://github.com/user-attachments/assets/136a0c9a-a8cf-42bf-bc19-032e2ac9874d) | ![](https://github.com/user-attachments/assets/c9e4881b-a2d3-4eaf-8296-81c4e3fdad0c) | ![](https://github.com/user-attachments/assets/d3318c4d-947c-421e-a000-f92e431a6c0d) | ![](https://github.com/user-attachments/assets/dea4e3e3-24d6-4e51-9278-53682231258b) |
|---|---|---|---|


1. **OneThingPerPageView**
   - 화면에 들어갈 주요 타이틀, 서브 타이틀, 텍스트 필드, 이미지를 간편하게 구성할 수 있는 뷰.
   - 텍스트 입력 필드를 표시할지, 이미지를 표시할지 옵션을 선택할 수 있으며, 버튼 액션을 간단히 연동 가능.

2. **OneThingAlertView**
   - 자체적으로 알림(모달) 뷰를 띄워서 사용자에게 확인/취소 등의 이벤트를 받을 수 있음.

3. **OneThingAmountTextField** *(iOS 15+ 권장)*
   - 텍스트 필드를 커스텀하여 보다 심플하고 일관된 스타일로 입력을 받을 수 있도록 함.
   - `@FocusState`를 활용해 포커스 상태를 직접 제어할 수 있음.

4. **ScalableButtonStyle**
   - 버튼을 터치했을 때 미세한 진동 및 크기 변화를 통해 사용자에게 시각·촉각적 피드백을 줄 수 있는 커스텀 스타일.

---

## 지원 환경

- **iOS 14.0+** (일부 컴포넌트는 iOS 15.0+에 최적화되어 있음)
- **SwiftUI** 프로젝트

---

## 설치 방법

### 1. Swift Package Manager(SPM)을 통한 설치

`Xcode`에서 직접 Swift Package를 추가하는 방법:
1. Xcode의 프로젝트 설정(프로젝트 루트)으로 이동
2. **Package Dependencies** 탭 선택
3. **+** 버튼을 클릭 후, 아래의 URL 입력:  
   ```
   https://github.com/cheshire0105/OneThingPerPage
   ```
4. 원하는 버전을 선택하고 추가

### 2. Manual(직접 소스 추가)

`OneThingPerPage`에 포함된 SwiftUI 파일들을 복사하여 프로젝트에 추가할 수도 있습니다.

---

## 사용 예시

아래의 예시는 `ExampleUseCaseView`이며, `OneThingPerPage`를 활용해 간단한 입력 폼과 Alert, 그리고 다음 화면으로 넘어가는 과정을 보여줍니다.

```swift
import SwiftUI
import OneThingPerPage

struct ExampleUseCaseView: View {
    @State private var amount: String = ""
    @State private var navigateToImageIncludedPage: Bool = false
    @State private var showAlert: Bool = false

    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                mainContent
            }
        } else {
            NavigationView {
                mainContent
            }
        }
    }

    private var mainContent: some View {
        ZStack {
            VStack {
                // MARK: - OneThingPerPageView 사용 예시
                OneThingPerPageView(
                    title: "타이틀 제목",
                    subTitle: "서브 타이틀입니다.",
                    placeholder: "플레이스 홀더입니다.",
                    textFieldValue: $amount,
                    buttonText: "다음 단계로"
                ) {
                    // 버튼 클릭 시 호출될 액션
                    showAlert = true
                }

                // iOS 16 이상에서는 NavigationLink의 새로운 문법 사용
                if #available(iOS 16.0, *) {
                    NavigationLink(
                        value: navigateToImageIncludedPage,
                        label: { EmptyView() }
                    )
                    .navigationDestination(isPresented: $navigateToImageIncludedPage) {
                        ImageIncludedPageView()
                    }
                } else {
                    NavigationLink(
                        destination: ImageIncludedPageView(),
                        isActive: $navigateToImageIncludedPage,
                        label: { EmptyView() }
                    )
                }
            }
            .navigationTitle("메인 페이지")
            .navigationBarTitleDisplayMode(.automatic)

            // MARK: - OneThingAlertView 사용 예시
            if showAlert {
                OneThingAlertView(
                    title: "얼럿 창 화면?",
                    cancelText: "닫기",
                    confirmText: "적용하기",
                    onCancel: {
                        showAlert = false
                    },
                    onConfirm: {
                        showAlert = false
                        navigateToImageIncludedPage = true
                    }
                )
            }
        }
    }
}
```

### 주요 컴포넌트 살펴보기

#### 1. OneThingPerPageView

```swift
@available(iOS 14.0, *)
public struct OneThingPerPageView: View {
    private let title: String
    private let subTitle: String
    private let placeholder: String
    private let buttonText: String
    @Binding private var textFieldValue: String
    private let buttonAction: () -> Void
    private let image: Image?
    private let showTextField: Bool
    private let imageHeight: CGFloat

    // ... 생략 ...

    public init(
        title: String,
        subTitle: String,
        placeholder: String,
        textFieldValue: Binding<String> = .constant(""),
        buttonText: String,
        image: Image? = nil,
        showTextField: Bool = true,
        imageHeight: CGFloat = 100,
        buttonAction: @escaping () -> Void
    ) {
        self.title = title
        self.subTitle = subTitle
        self.placeholder = placeholder
        self._textFieldValue = textFieldValue
        self.buttonText = buttonText
        self.image = image
        self.showTextField = showTextField
        self.imageHeight = imageHeight
        self.buttonAction = buttonAction
    }

    public var body: some View {
        // 타이틀, 서브 타이틀, (옵션)이미지, 텍스트필드, 버튼 등을 수직으로 배치한 레이아웃
    }
}
```

- **title**: 메인 타이틀 (예: "타이틀 제목")
- **subTitle**: 서브 타이틀 (예: "서브 타이틀입니다.")
- **placeholder**: 텍스트 필드 플레이스 홀더 (예: "금액을 입력하세요.")
- **textFieldValue**: Binding으로 연결될 실제 텍스트 필드 값
- **buttonText**: 버튼 라벨 텍스트 (예: "다음 단계로")
- **buttonAction**: 버튼 클릭 시 실행할 클로저
- **image** *(옵션)*: 화면에 표시할 이미지를 넣을 수 있음
- **showTextField** *(기본값=true)*: 텍스트 필드 표시 여부
- **imageHeight**: 이미지를 넣을 경우, 높이 지정

#### 2. OneThingAlertView

```swift
public struct OneThingAlertView: View {
    let title: String
    let cancelText: String
    let confirmText: String
    let onCancel: () -> Void
    let onConfirm: () -> Void

    public init(
        title: String,
        cancelText: String = "닫기",
        confirmText: String = "확인",
        onCancel: @escaping () -> Void,
        onConfirm: @escaping () -> Void
    ) {
        // ...
    }

    public var body: some View {
        // 반투명 배경 위에 Alert 영역을 띄우는 구성
    }
}
```

- **title**: 얼럿 창의 타이틀
- **cancelText**: 취소 버튼 텍스트 (기본값 "닫기")
- **confirmText**: 확인 버튼 텍스트 (기본값 "확인")
- **onCancel**: 취소 버튼 탭 시 동작
- **onConfirm**: 확인 버튼 탭 시 동작

#### 3. OneThingAmountTextField *(iOS 15.0+)*

```swift
@available(iOS 15.0, *)
public struct OneThingAmountTextField: View {
    @Binding var text: String
    let placeholder: String
    @FocusState private var isFocused: Bool

    public init(text: Binding<String>, placeholder: String) {
        self._text = text
        self.placeholder = placeholder
    }

    public var body: some View {
        ZStack(alignment: .center) {
            // 둥근 모서리 배경
            // placeholder & focused 상태를 고려한 TextField
        }
    }
}
```

- **`@FocusState private var isFocused: Bool`**를 통해 키보드 포커스를 자동 제어 가능
- **numberPad** 키보드를 적용하여 주로 금액 입력 시 사용

#### 4. ScalableButtonStyle

```swift
public struct ScalableButtonStyle: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { isPressed in
                if isPressed {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.prepare()
                    generator.impactOccurred()
                }
            }
    }
}
```

- 버튼을 누르는 동안 살짝 축소되면서 햅틱(진동) 피드백 발생
- SwiftUI에서 기본 제공하는 ButtonStyle 프로토콜을 준수

---

## 간단한 사용 가이드

1. **Swift Package Manager** 또는 직접 소스 추가 방식을 통해 `OneThingPerPage`를 프로젝트에 추가합니다.
2. **Import** 후, `OneThingPerPageView`나 `OneThingAlertView` 등 필요한 뷰를 화면(혹은 View)에서 선언합니다.
3. `@State` 혹은 `@Binding` 변수를 활용해 **사용자 입력**, **얼럿 표시 여부** 등을 상태로 관리합니다.
4. **버튼 액션**이나 **얼럿의 확인/취소 액션**에 원하는 로직(화면 이동, 데이터 처리, etc.)을 연결합니다.

---

## 주의 사항

- iOS 15.0 이상에서 작동하는 일부 기능(예: `OneThingAmountTextField`)이 있으므로, **최소 지원 버전**에 주의하세요. (iOS 14에서도 컴파일은 가능하나, 일부 기능은 제한될 수 있습니다.)
- SwiftUI **Navigation** 방식이 iOS 16에서 크게 변경되었기 때문에, `NavigationView` 대신 `NavigationStack`을 사용할 경우에는 조건부 컴파일/호환 여부를 주의 깊게 확인하세요.
- `ScalableButtonStyle` 내부에서 햅틱 피드백을 사용하기 때문에, 시뮬레이터 보다는 실제 기기에서 테스트를 권장합니다.

---

## 기여(Contributing)

이 라이브러리에 기여하고 싶으시다면, **Fork** 후 새로운 기능을 추가하거나 버그를 수정한 뒤 **Pull Request**를 올려주세요.  
또는 이슈를 등록해 주시면 함께 더 나은 라이브러리를 만들어 갈 수 있습니다.

---

## 라이선스(License)

[MIT License](LICENSE) 하에 오픈소스로 배포되며, 자유롭게 수정 및 재배포 가능합니다.

---

더 자세한 예시나 추가 문서는 [GitHub Repo](https://github.com/cheshire0105/OneThingPerPage)를 참고하세요.  
궁금하신 점이나 버그 제보 사항이 있으면 이슈를 등록 부탁드립니다. 

감사합니다! 
