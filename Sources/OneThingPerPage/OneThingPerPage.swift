import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
    }
}
#endif

public struct ScalableButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        if #available(iOS 14.0, *) {
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
        } else {
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
        }
    }
}

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
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.systemGray6))
                .frame(height: 56)

            ZStack {
                if text.isEmpty && !isFocused {
                    Text(placeholder)
                        .font(.system(size: 22))
                        .foregroundColor(Color(UIColor.systemGray2))
                }

                TextField("", text: $text)
                    .font(.system(size: 22, weight: .regular))
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                    .focused($isFocused)
            }
            .padding(.horizontal, 16)
        }
        .padding(.horizontal, 20)
    }
}

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
    @State private var isAlertPresented: Bool = false
    @State private var keyboardIsShowing = false

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
        GeometryReader { geometry in
            ZStack {
                Group {
                    if #available(iOS 14.0, *) {
                        Color("backgroundColor")
                            .ignoresSafeArea()
                    } else {
                        Color("backgroundColor")
                            .edgesIgnoringSafeArea(.all)
                    }
                }

                VStack(spacing: 0) {
                    VStack(spacing: 10) {
                        Spacer().frame(height: 80)

                        Text(title)
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)

                        Text(subTitle)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 80)
                    }

                    if image != nil {
                        Spacer().frame(height: 40)
                    } else {
                        Spacer().frame(height: 30)
                    }

                    if #available(iOS 15.0, *) {
                        VStack(spacing: 10) {
                            if let image = image {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: imageHeight)
                            }

                            if showTextField {
                                OneThingAmountTextField(
                                    text: $textFieldValue,
                                    placeholder: placeholder
                                )
                                .padding(.vertical, 10)
                            }
                        }
                    } else {
                        VStack(spacing: 10) {
                            if let image = image {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: imageHeight)
                            }

                            if showTextField {
                                TextField(placeholder, text: $textFieldValue)
                                    .font(.system(size: 22, weight: .regular))
                                    .keyboardType(.numberPad)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.primary)
                                    .padding()
                                    .background(Color(UIColor.systemGray6))
                                    .cornerRadius(12)
                                    .padding(.horizontal, 20)
                            }
                        }
                    }

                    Spacer()

                    VStack {
                        Button(action: {
                            buttonAction()
                        }) {
                            Text(buttonText)
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, minHeight: 24)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(keyboardIsShowing ? 0 : 16)
                                .padding(.horizontal, keyboardIsShowing ? 0 : 16)
                        }
                        .buttonStyle(ScalableButtonStyle())
                        .padding(.bottom, keyboardIsShowing ? 0 : 24)
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .contentShape(Rectangle())
            .onTapGesture { hideKeyboard() }
            .gesture(
                DragGesture(minimumDistance: 2)
                    .onChanged { _ in hideKeyboard() }
            )
            .onAppear {
                NotificationCenter.default.addObserver(
                    forName: UIResponder.keyboardWillShowNotification,
                    object: nil,
                    queue: .main) { _ in
                        withAnimation {
                            DispatchQueue.main.async {
                                self.keyboardIsShowing = true
                            }
                        }
                    }

                NotificationCenter.default.addObserver(
                    forName: UIResponder.keyboardWillHideNotification,
                    object: nil,
                    queue: .main) { _ in
                        withAnimation {
                            DispatchQueue.main.async {
                                self.keyboardIsShowing = false
                            }
                        }
                    }
            }
        }
    }
}

import SwiftUI

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
        self.title = title
        self.cancelText = cancelText
        self.confirmText = confirmText
        self.onCancel = onCancel
        self.onConfirm = onConfirm
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 16) {
                    Text(title)
                        .font(.system(size: 17))
                        .foregroundColor(.primary)
                        .padding(.top, 24)
                        .padding(.bottom, 16)
                        .frame(maxWidth: .infinity)

                    HStack(spacing: 8) {
                        Button(action: onCancel) {
                            Text(cancelText)
                                .font(.system(size: 17))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15)
                                .background(Color(UIColor.systemGray6))
                                .foregroundColor(Color(UIColor.systemGray))
                                .cornerRadius(12)
                        }
                        .buttonStyle(ScalableButtonStyle())

                        Button(action: onConfirm) {
                            Text(confirmText)
                                .font(.system(size: 17))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .buttonStyle(ScalableButtonStyle())
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
                .frame(width: geometry.size.width * 0.75)
                .background(
                    Group {
                        if #available(iOS 14.0, *) {
                            Color("backgroundColor")
                        } else {
                            Color("backgroundColor")
                        }
                    }
                )
                .cornerRadius(14)
                .shadow(color: Color.black.opacity(0.12), radius: 5, x: 0, y: 2)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
        }
    }
}
