//
//  multiLineTextField.swift
//  MyNotes
//
//  Created by YES on 2020/3/20.
//  Copyright © 2020 YES. All rights reserved.
//

import SwiftUI
import UIKit


struct multiLineTextField : UIViewRepresentable {
    @Binding var text : String
    @State var editable: Bool = true
    
    func makeCoordinator() -> multiLineTextField.Coordinator {
        return multiLineTextField.Coordinator(parent1: self)
    }
    func makeUIView(context: UIViewRepresentableContext<multiLineTextField>) -> UITextView{
        let textview = UITextView()
        textview.font = .systemFont(ofSize: 18)
        textview.delegate = context.coordinator
        
        let toolBar = UIToolbar(frame: CGRect(x:0,y:0,width: textview.frame.size.width, height: 44))
        let doneButton = UIBarButtonItem(title: "done", style: .done, target: self, action: #selector(textview.doneBUttonTapped(button:)))
        if editable{
            toolBar.items = [doneButton]
            toolBar.setItems([doneButton], animated: true)
            textview.inputAccessoryView = toolBar
            textview.textColor = .gray
        }
        else{
            textview.textColor = .black
        }
        //textView透明背景
        //textview.backgroundColor = .clear
        
        textview.isUserInteractionEnabled = true
        textview.isEditable = editable
        textview.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        
        return textview
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<multiLineTextField>) {
        uiView.text = text
    }
    
    class Coordinator : NSObject,UITextViewDelegate{
        var parent : multiLineTextField
        init(parent1 : multiLineTextField) {
            parent = parent1
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {

                   //textView.text = ""
                   textView.textColor = .black
               }
        
        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }
    }
}


extension UITextView{
    @objc func doneBUttonTapped(button:UIBarButtonItem) -> Void{
        self.resignFirstResponder()
    }
}
