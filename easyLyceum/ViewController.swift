//
//  ViewController.swift
//  easyLyceum
//
//  Created by Luca Marconato on 31/08/2016.
//  Copyright © 2016 ilma. All rights reserved.
//

import Cocoa
import Quartz

class ViewController: NSViewController {
    @IBOutlet var console: Console!
    @IBOutlet weak var button: NSButton!
    @IBOutlet weak var pdfView: PDFView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        console.parent = self
    }
    
    
    func newLine() {
        let textStorage = console.textStorage
        if(textStorage != nil) {
            let myString = "\n>>"
            let myAttribute = [ NSForegroundColorAttributeName: NSColor.green, NSFontAttributeName: NSFont(name: "Menlo Regular", size: 13.0)! ]
            let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
            
            textStorage!.append(myAttrString)
            let length = console.string!.characters.count
            
            console.setSelectedRange(NSRange(location: length,length: 0))
            console.scrollRangeToVisible(NSRange(location: length,length: 0))
        }
    }
    
    @IBAction func buttonPressed(_ sender: AnyObject) {
        let path = openFileDialog("Scegli la slide", message: "Message", filetypelist: "pdf")
        let url = URL(string: path)
        let pdf = PDFDocument(url: url!)
        pdfView.document = pdf
    }
    
    func openFileDialog (_ windowTitle: String, message: String, filetypelist: String) -> String
    {
        var path: String = ""
        
        let myFiledialog: NSOpenPanel = NSOpenPanel()
        let fileTypeArray: [String] = filetypelist.components(separatedBy: ",")
        
        myFiledialog.prompt = "Open"
        myFiledialog.worksWhenModal = true
        myFiledialog.allowsMultipleSelection = false
        myFiledialog.canChooseDirectories = false
        myFiledialog.resolvesAliases = true
        myFiledialog.title = windowTitle
        myFiledialog.message = message
        myFiledialog.allowedFileTypes = fileTypeArray
        
        myFiledialog.runModal()
        
        let chosenfile = myFiledialog.url // Pathname of the file
        
        if (chosenfile != nil)
        {
            path = chosenfile!.absoluteString
        }
        return (path)
    }


    //override var representedObject: AnyObject? {
    //    didSet {
        // Update the view, if already loaded.
    //    }
    //}
    
    
}

class Console : NSTextView {
    var parent: ViewController?
    override func insertNewline(_ sender: Any?) {
        parent!.newLine()
    }
    
    override func controlTextDidBeginEditing(_ obj: Notification) {
        NSLog("WOW!")
    }
}
