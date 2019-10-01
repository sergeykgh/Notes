//
//  EditableText.swift
//  Notes
//
//  Created by Sergey Korotkevich on 29/09/2019.
//  Copyright © 2019 Sergey Korotkevich. All rights reserved.
//

import SwiftUI
import UIKit

struct EditableText: UIViewRepresentable {
    @Binding var text: String
    let fontSize: CGFloat
    let showKeyboard: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.font = .systemFont(ofSize: fontSize)
        view.isScrollEnabled = true
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.delegate = context.coordinator
        if showKeyboard {
            view.becomeFirstResponder()
        }
        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var control: EditableText

        init(_ control: EditableText) {
            self.control = control
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            control.text = textView.text
        }
    }
}
