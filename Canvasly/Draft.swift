//
//  Draft.swift
//  Canvasly
//
//  Created by Lorenzo Zanotto on 30/03/2016.
//  Copyright © 2016 Lorenzo Zanotto. All rights reserved.
//

import Foundation
import CoreData

class Draft: NSManagedObject {
    @NSManaged var title: String
    @NSManaged var content: String
}