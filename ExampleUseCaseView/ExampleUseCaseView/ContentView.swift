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
                OneThingPerPageView(
                    title: "타이틀 제목",
                    subTitle: "서브 타이틀입니다.",
                    placeholder: "플레이스 홀더입니다.",
                    textFieldValue: $amount,
                    buttonText: "다음 단계로"
                ) {
                    showAlert = true
                }

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
