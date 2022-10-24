//
//  ImageLink+CoreDataProperties.swift
//  PhotoApplication
//
//  Created by Константин Малков on 10.10.2022.
//
//

import Foundation
import CoreData


extension ImageLink {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageLink> {
        return NSFetchRequest<ImageLink>(entityName: "ImageLink")
    }

    @NSManaged public var url: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var image: Data?

}

extension ImageLink : Identifiable {

}
