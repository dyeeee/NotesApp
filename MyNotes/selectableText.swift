//
//  selectableText.swift
//  MyNotes
//
//  Created by YES on 2020/3/21.
//  Copyright © 2020 YES. All rights reserved.
//
import SwiftUI
import UIKit



/// This subclass is needed since we want to customize the cursor and the context menu
class CustomUITextView: UITextView, UITextViewDelegate {

    /// Binding from the `CustomTextField` so changes of the text can be observed by `SwiftUI`
    fileprivate var _textBinding: Binding<String>!

    /// If it is `true` the text field behaves normally. If `false` text cannot be modified only selected, copied and so on.
    fileprivate var _isEditable = true


    // change the cursor to have zero size
    override func caretRect(for position: UITextPosition) -> CGRect {
        return self._isEditable ? super.caretRect(for: position) : .zero
    }

    // override this method to customize the displayed items of 'UIMenuController' (the context menu when selecting text)
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {

        // disable 'cut', 'delete', 'paste','_promptForReplace:'
        // if it is not editable
        if (!_isEditable) {
            switch action {
            case #selector(cut(_:)),
                 #selector(delete(_:)),
                 #selector(paste(_:)):
                return false
            default:
                // do not show 'Replace...' which can also replace text
                // Note: This selector is private and may change
                if (action == Selector("_promptForReplace:")) {
                    return false
                }
            }
        }
        return super.canPerformAction(action, withSender: sender)
    }


    // === UITextViewDelegate methods

    func textFieldDidChangeSelection(_ textField: UITextView) {
        // update the text of the binding
        self._textBinding.wrappedValue = textField.text ?? ""
    }

    func textField(_ textField: UITextView, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Allow changing the text depending on `self._isEditable`
        return self._isEditable
    }

}

struct CustomTextField: UIViewRepresentable {

    @Binding private var text: String
    private var isEditable: Bool

    init(text: Binding<String>, isEditable: Bool = true) {
        self._text = text
        self.isEditable = isEditable
    }

    func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> CustomUITextView {
        let textField = CustomUITextView(frame: .zero)
        textField.delegate = textField
        textField.text = self.text
        textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return textField
    }

    func updateUIView(_ uiView: CustomUITextView, context: UIViewRepresentableContext<CustomTextField>) {
        uiView.text = self.text
        uiView._textBinding = self.$text
        uiView._isEditable = self.isEditable
    }

    func isEditable(editable: Bool) -> CustomTextField {
        return CustomTextField(text: self.$text, isEditable: editable)
    }
}

struct selectableText: UIViewRepresentable {

    private var text: String
    private var selectable: Bool

    init(_ text: String, selectable: Bool = true) {
        self.text = text
        self.selectable = selectable
    }

    func makeUIView(context: Context) -> CustomUITextView {
        let textField = CustomUITextView(frame: .zero)
        textField.delegate = textField
        textField.text = self.text
        textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        textField.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return textField
    }

    func updateUIView(_ uiView: CustomUITextView, context: Context) {
        uiView.text = self.text
        uiView._textBinding = .constant(self.text)
        uiView._isEditable = false
        //uiView.isEnabled = self.selectable
        uiView.font = .systemFont(ofSize: 18)
        uiView.textAlignment = .left
        uiView.backgroundColor = .clear
    }

    func selectable(_ selectable: Bool) -> selectableText {
        return selectableText(self.text, selectable: selectable)
    }

}


struct TextTestView: View {

    @State private var selectableTag = true

    var body: some View {
        VStack {

            // Even though the text should be constant, it is not because the user can select and e.g. 'cut' the text
            TextField("", text: .constant("Test SwiftUI TextField"))
                .background(Color(red: 0.5, green: 0.5, blue: 1))

            // This view behaves like the `selectableText` however the layout behaves like a `TextField`
            CustomTextField(text: .constant("Test `CustomTextField`"))
                .isEditable(editable: false)
                            .background(Color(red: 0.5, green: 0.5, blue: 1))

            // A non selectable normal `Text`
            Text("Test SwiftUI `Text`")
                .background(Color.red)

            // A selectable `text` where the selection ability can be changed by the button below
            selectableText("Test `selectableText` maybe selectable")
                .selectable(self.selectableTag)
                .background(Color.orange)

            Button(action: {
                self.selectableTag.toggle()
            }) {
                Text("`selectableText` can be selected: \(self.selectableTag.description)")
            }

            // A selectable `text` which cannot be changed
            HStack {
                selectableText("Test 'selectableText` always selectableTest `selectableText` always selectable")
                    .frame(width: 200, height: 50)
                Spacer()
            }

        }.padding()
    }

}

struct Selectable_Previews: PreviewProvider {
    static var previews: some View {
        TextTestView()
    }
}

