//
//  AnnotationStorage.swift
//  easyLyceum
//
//  Created by Luigi Donadel on 20/10/16.
//  Copyright © 2016 ilma. All rights reserved.
//

import Cocoa
import Quartz

var docKey : String!
class AnnotationStorage {
    class func setDocument(path : String) {
        docKey = path
    }
    class func save(annotation : PDFAnnotationSquare, page : Int) {
        let defaults = UserDefaults.standard
        var pages : [String : [[String : CGFloat]]]? = defaults.dictionary(forKey: docKey) as? [String : [[String : CGFloat]]]
        if pages == nil {
            pages = [:]
        }
        var annotations = pages!["\(page)"]
        if annotations == nil {
            annotations = []
        }
        annotations!.append(annotation.toDict())
        pages!["\(page)"] = annotations
        defaults.set(pages, forKey: docKey)
        defaults.synchronize()
    }
    class func remove(annotation : PDFAnnotationSquare, page : Int) {
        let defaults = UserDefaults.standard
        var pages : [String : [[String : CGFloat]]]? = defaults.dictionary(forKey: docKey) as? [String : [[String : CGFloat]]]
        if pages == nil {
            pages = [:]
        }
        var annotations = pages!["\(page)"]
        if annotations == nil {
            annotations = []
        }
        let i = annotations!.index { (candidate : [String : CGFloat]) -> Bool in
            return annotation.equalTo(annotation: candidate)
        }!
        annotations!.remove(at: i)
        pages!["\(page)"] = annotations
        defaults.set(pages, forKey: docKey)
        defaults.synchronize()
    }
    class func list(page : Int) -> [PDFAnnotationSquare]? {
        let defaults = UserDefaults.standard
        var pages : [String : [[String : CGFloat]]]? = defaults.dictionary(forKey: docKey) as? [String : [[String : CGFloat]]]
        if pages == nil {
            pages = [:]
        }
        if let list = pages!["\(page)"] {
            var output : [PDFAnnotationSquare] = []
            for item in list {
                let annotation = PDFAnnotationSquare()
                annotation.initFromDict(dictionary: item)
                output.append(annotation)
            }

            return output
        }
        return nil
    }
}
