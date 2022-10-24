//
//  PhotoApp+CoreDataProperties.swift
//  PhotoApplication
//
//  Created by Константин Малков on 24.09.2022.
//

import Foundation
import CoreData


extension PhotoApp {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoApp> {
        return NSFetchRequest<PhotoApp>(entityName: "PhotoApp")
    }

    @NSManaged public var apiString: String?
    

}

extension PhotoApp : Identifiable {

}
