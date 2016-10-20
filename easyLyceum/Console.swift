//
//  Console.swift
//  easyLyceum
//
//  Created by Luigi Donadel on 20/10/16.
//  Copyright © 2016 ilma. All rights reserved.
//

import Cocoa

class Console : NSTextView {
    var parent: ViewController?
    
    override func insertNewline(_ sender: Any?) {
        newLine()
    }
    
    override func controlTextDidBeginEditing(_ obj: Notification) {
        NSLog("WOW!")
    }
    func newLine() {
        if let textStorage = self.textStorage {
            let myString = "\n>>"
            let myAttribute = [ NSForegroundColorAttributeName: NSColor.green, NSFontAttributeName: NSFont(name: "Menlo Regular", size: 13.0)! ]
            let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
            
            textStorage.append(myAttrString)
            let length = self.string!.characters.count
            
            self.setSelectedRange(NSRange(location: length,length: 0))
            self.scrollRangeToVisible(NSRange(location: length,length: 0))
        }
    }
}
