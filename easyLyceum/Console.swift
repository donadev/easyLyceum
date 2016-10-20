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
    var handlers : [String : () -> ()] = [:]
    let START_SEQUENCE = ">>"
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.delegate = self
        self.insertNewline(nil)
    }
    func addCommandHandler(for command : String, handler : @escaping () -> ()) {
        handlers[command] = handler
    }
    override func insertNewline(_ sender: Any?) {
        if let lastline = self.textStorage?.paragraphs.last {
            var command = lastline.string.trimmingCharacters(in: [" "])
            let startIndex = command.index(command.startIndex, offsetBy: START_SEQUENCE.characters.count)
            command = command.substring(from: startIndex)
            Swift.print(command)
            if let handler = handlers[command] {
                handler()
            }
        }
        newLine()
    }
    internal override func controlTextDidBeginEditing(_ obj: Notification) {
        NSLog("WOW!")
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
