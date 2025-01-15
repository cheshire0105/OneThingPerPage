import SwiftUI
import OneThingPerPage

struct ImageIncludedPageView: View {
    var body: some View {
        OneThingPerPageView(
            title: "추가 정보",
            subTitle: "이미지가 포함된 페이지입니다.",
            placeholder: "추가 금액을 입력하세요.", // 텍스트 필드를 사용하지 않으므로 placeholder는 사실상 사용되지 않습니다.
            textFieldValue: .constant(""), // 텍스트 필드를 사용하지 않으므로 빈 바인딩을 전달합니다.
            buttonText: "완료",
            image: Image("CoffeeCup"), // 에셋에서 이미지 로드
            showTextField: false, // 텍스트 필드를 숨깁니다.
            imageHeight: 200 // 원하는 이미지 높이 설정 (예: 200)
        ) {
            print("완료 버튼 클릭")
        }
    }
}
