//
//  ImageLinkCoreDataClass.swift
//  PhotoApplication
//
//  Created by Константин Малков on 08.10.2022.
//

import Foundation
import CoreData
import UIKit

class ImageLinkStack {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static let instance = ImageLinkStack()
    var vaultData = [ImageLink]()
    
    func loadImage() {
        do{
            vaultData = try context.fetch(ImageLink.fetchRequest())
        } catch {
            print("Error of loading data")
        }
    }
    
    
    
    func saveImage(image data: Data,link string: String) {
        let image = ImageLink(context: context)
        image.image = data
        image.url = string
        do {
            try context.save()
            loadImage()
        } catch {
            print("Error of saving")
        }
    }
    
    func deleteImage(image: ImageLink) {
        context.delete(image)
        do{
            try context.save()
            loadImage()
        } catch {
            print("Error deleting")
        }
    }
}
