//
//  PDFAnnotation.swift
//  easyLyceum
//
//  Created by Luigi Donadel on 20/10/16.
//  Copyright © 2016 ilma. All rights reserved.
//

import Cocoa
import Quartz

extension PDFAnnotationSquare {
    func initFromDict(dictionary : [String : CGFloat]) {
        self.bounds.origin.x = dictionary["x"]!
        self.bounds.origin.y = dictionary["y"]!
        self.bounds.size.width = dictionary["width"]!
        self.bounds.size.height = dictionary["height"]!
    }
    func equalTo(annotation : [String : CGFloat]) -> Bool {
        return self.bounds.origin.x == annotation["x"]! &&
               self.bounds.origin.y == annotation["y"]! &&
               self.bounds.size.width == annotation["width"]! &&
               self.bounds.size.height == annotation["height"]!
    }
    func toDict() -> [String : CGFloat] {
        var dict : [String : CGFloat] = [:]
        dict["x"] = self.bounds.origin.x
        dict["y"] = self.bounds.origin.y
        dict["width"] = self.bounds.size.width
        dict["height"] = self.bounds.size.height
        return dict
    }
}
