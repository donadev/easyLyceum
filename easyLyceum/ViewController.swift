//
//  ViewController.swift
//  easyLyceum
//
//  Created by Luca Marconato on 31/08/2016.
//  Copyright © 2016 ilma. All rights reserved.
//

import Cocoa
import Quartz

class ViewController: NSViewController, PDFViewDelegate {
    @IBOutlet var console: Console!
    @IBOutlet weak var button: NSButton!
    @IBOutlet weak var markButton : NSButton!
    @IBOutlet weak var memoryButton : NSButton!
    @IBOutlet weak var removeButton : NSButton!

    @IBOutlet weak var pdfView: PDFView!
    var pdf : PDFDocument!
    let highlightColor = NSColor(deviceRed: 0, green: 1, blue: 0, alpha: 0.6)
    override func viewDidLoad() {
        super.viewDidLoad()
        console.parent = self
        pdfView.setOnMouseDownHandler {
            self.removeButton.isHidden = (self.pdfView.getSelectedAnnotation() == nil)
        }
        pdfView.setOnMouseUpHandler {
            self.markButton.isEnabled = self.pdfView.isSelectionBoxVisible()
        }
        
        //Esempio di utilizzo del rilevatore di comandi di console:
        console.addCommandHandler(for: "alert") {
            let alert = NSAlert()
            alert.messageText = "Hei! Questo è un alert"
            alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
        }
        //Esempio di utilizzo con tasto freccia in alto (unica differenza con il metodo precedente: è considerato come carattere unico e non come stringa)
        console.addKeyHandler(for: NSUpArrowFunctionKey) {
            let alert = NSAlert()
            alert.messageText = "Hei! Freccia in alto"
            alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
        }
    }
    func initAnnotations(path : String) {
        AnnotationStorage.setDocument(path: path)
        let pageCount = pdf.pageCount
        for i in 0..<pageCount {
            let page = pdf.page(at: i)!
            if let annotations = AnnotationStorage.list(page: page.pageRef!.pageNumber) {
                for annotation in annotations {
                    annotation.setInteriorColor(getMarkColor())
                    annotation.color = getMarkColor()
                    page.addAnnotation(annotation)
                }
            }
        }
    }
    
    func getMarkColor() -> NSColor {
        return (memoryButton.state == NSOnState) ? NSColor.black : highlightColor
    }
    
    @IBAction func removeButtonPressed(_ sender: AnyObject) {
        if let annotation = pdfView.getSelectedAnnotation() {
            if let page = self.pdfView.currentPage {
                page.removeAnnotation(annotation)
                AnnotationStorage.remove(annotation: annotation, page: page.pageRef!.pageNumber)
                self.reload(page: page)
                self.removeButton.isHidden = true
            }
        }
    }
    @IBAction func buttonPressed(_ sender: AnyObject) {
        let path = openFileDialog("Scegli la slide", message: "Message", filetypelist: "pdf")
        let url = URL(string: path)
        pdf = PDFDocument(url: url!)
        pdfView.document = pdf
        pdfView.delegate = self
        memoryButton.isEnabled = true
        initAnnotations(path: path)
        
    }
    @IBAction func annotate(_ sender : AnyObject) {
        if let rect = pdfView.getSelection() {
            addAnnotation(rect: rect)
        }
    }
    @IBAction func changeMemoryMode(_ sender : NSButton) {
        let color = getMarkColor()
        let count = pdf.pageCount
        for i in 0..<count {
            let page = pdf.page(at: i)!
            for annotation in (page.annotations) {
                if annotation is PDFAnnotationSquare {
                    let new = (annotation as! PDFAnnotationSquare)
                    new.setInteriorColor(color)
                    new.color = color
                }
            }
        }
        reload(page: pdfView.currentPage!)

    }
    func addAnnotation(rect : NSRect) {
        if let currentPage = pdfView.currentPage {
            Swift.print("rect: \(rect)")
            let annotation = PDFAnnotationSquare(bounds: rect)
            annotation.setInteriorColor(getMarkColor())
            annotation.color = getMarkColor()
            currentPage.addAnnotation(annotation)
            AnnotationStorage.save(annotation: annotation, page: currentPage.pageRef!.pageNumber)
            pdfView.removeSelectionBox()
            reload(page: currentPage)
        }
    }
    func reload(page : PDFPage) {
        var pageIndex = -1
        for i in 0..<pdf.pageCount {
            if pdf.page(at: i) == page {
                pageIndex = i
            }
        }
        pdfView.document = nil
        pdfView.document = pdf
        let newPage = pdf.page(at: pageIndex)!
        pdfView.go(to: newPage)
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

    
}


