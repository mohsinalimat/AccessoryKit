//
//  ViewController.swift
//  AccessoryKit
//
//  Created by Yubo Qin on 02/11/2020.
//  Copyright (c) 2020 Yubo Qin. All rights reserved.
//

import UIKit
import AccessoryKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    private var accessoryView: KeyboardAccessoryView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let keyButtons: [KeyboardAccessoryButton] = [
            KeyboardAccessoryButton(type: .tab, tapHandler: {}),
            KeyboardAccessoryButton(type: .undo, tapHandler: { [weak self] in
                self?.undo()
            }),
            KeyboardAccessoryButton(type: .redo, tapHandler: { [weak self] in
                self?.redo()
            }),
            KeyboardAccessoryButton(type: .header, tapHandler: {}),
            KeyboardAccessoryButton(type: .bold, tapHandler: {}),
            KeyboardAccessoryButton(type: .italic, tapHandler: {}),
            KeyboardAccessoryButton(type: .code, tapHandler: {}),
            KeyboardAccessoryButton(type: .delete, tapHandler: {}),
            KeyboardAccessoryButton(type: .item, tapHandler: {}),
            KeyboardAccessoryButton(type: .quote, tapHandler: {}),
            KeyboardAccessoryButton(type: .link, menu: createInsertMenu()),
            KeyboardAccessoryButton(type: .image, tapHandler: {}),
        ]
        accessoryView = KeyboardAccessoryView(
            frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0),
            keyButtons: keyButtons,
            showDismissKeyboardKey: true,
            delegate: self)
        if #available(iOS 13.0, *) {
            accessoryView.tintColor = .systemPink
            accessoryView.setTintColor(.systemGreen, at: 5)
        } else {
            accessoryView.tintColor = .red
            accessoryView.setTintColor(.green, at: 5)
        }
        textView.inputAccessoryView = accessoryView
        textView.delegate = self
        textView.alwaysBounceVertical = true
        updateAccessoryViewButtonEnabled()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func undo() {
        textView.undoManager?.undo()
        updateAccessoryViewButtonEnabled()
    }
    
    private func redo() {
        textView.undoManager?.redo()
        updateAccessoryViewButtonEnabled()
    }
    
    private func updateAccessoryViewButtonEnabled() {
        accessoryView.setEnabled(textView.undoManager?.canUndo ?? false, at: 1)
        accessoryView.setEnabled(textView.undoManager?.canRedo ?? false, at: 2)
    }

    private func createInsertMenu() -> UIMenu {
        return UIMenu(
            title: "",
            image: nil,
            identifier: nil,
            options: .displayInline,
            children: [
                UIAction(
                    title: "Insert link",
                    image: UIImage(systemName: "link"),
                    handler: { _ in }),
                UIAction(
                    title: "Insert image",
                    image: UIImage(systemName: "photo"),
                    handler: { _ in }),
                UIAction(
                    title: "Insert math formula",
                    image: UIImage(systemName: "function"),
                    handler: { _ in }),
            ])
    }

}

extension ViewController: KeyboardAccessoryViewDelegate {
    
    func dismissKeyboardButtonTapped() {
        textView.resignFirstResponder()
    }
    
}

extension ViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        updateAccessoryViewButtonEnabled()
    }
    
}
