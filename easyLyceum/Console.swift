//
//  Console.swift
//  easyLyceum
//
//  Created by Luigi Donadel on 20/10/16.
//  Copyright © 2016 ilma. All rights reserved.
//

import Cocoa

class Console : NSTextView, NSTextViewDelegate {
    var parent: ViewController?
    var commandHandlers : [String : () -> ()] = [:]
    var keyHandlers : [Character : () -> ()] = [:]
    let START_SEQUENCE = ">>"
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.delegate = self
        self.insertNewline(nil)
    }
    func addCommandHandler(for command : String, handler : @escaping () -> ()) {
        commandHandlers[command] = handler
    }
    func addKeyHandler(for key : Character, handler : @escaping () -> ()) {
        keyHandlers[key] = handler
    }
    
    func addKeyHandler(for key : Int, handler : @escaping () -> ()) {
        addKeyHandler(for: Character(UnicodeScalar(key)!), handler: handler)
    }
    
    
    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        if let chars = event.charactersIgnoringModifiers {
            let index = chars.startIndex
            let key = chars[index]
            if let handler = keyHandlers[key] {
                handler()
            }
        }
        return super.performKeyEquivalent(with: event)
        
    }
    override func insertNewline(_ sender: Any?) {
        if let lastline = self.textStorage?.paragraphs.last {
            var command = lastline.string.trimmingCharacters(in: [" "])
            let startIndex = command.index(command.startIndex, offsetBy: START_SEQUENCE.characters.count)
            command = command.substring(from: startIndex)
            Swift.print(command)
            if let handler = commandHandlers[command] {
                handler()
            }
        }
        newLine()
    }
    func newLine() {
        if let textStorage = self.textStorage {
            let myAttribute = [ NSForegroundColorAttributeName: NSColor.green, NSFontAttributeName: NSFont(name: "Menlo Regular", size: 13.0)! ]
            let myAttrString = NSAttributedString(string: "\n\(START_SEQUENCE)", attributes: myAttribute)
            
            textStorage.append(myAttrString)
            let length = self.string!.characters.count
            
            self.setSelectedRange(NSRange(location: length,length: 0))
            self.scrollRangeToVisible(NSRange(location: length,length: 0))
        }
    }
}
