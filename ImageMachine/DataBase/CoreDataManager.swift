//
//  CoreDataManager.swift
//  ImageMachine
//
//  Created by Phincon on 15/12/22.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    static let sharedManager = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "ImageMachine")
        
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    func saveContext () {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    /*Insert*/
    func insertData(name: String, id: String, machineNumber: String) -> ImageMachineData? {
        
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "ImageMachineData",
                                                in: managedContext)!
        
        let machine = NSManagedObject(entity: entity,
                                      insertInto: managedContext)
        
        machine.setValue(name, forKeyPath: "name")
        machine.setValue(id, forKeyPath: "id")
        machine.setValue(machineNumber, forKey: "machine")
        
        do {
            try managedContext.save()
            return machine as? ImageMachineData
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func update(name:String, id: String, machine: String, imageMachine: ImageMachineData) {
        
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        imageMachine.setValue(name, forKey: "name")
        imageMachine.setValue(id, forKey: "id")
        imageMachine.setValue(machine, forKey: "machine")
        
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func delete(id: String) -> [ImageMachineData]? {
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        /*init fetch request*/
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ImageMachineData")
        
        /*pass your condition with NSPredicate. We only want to delete those records which match our condition*/
        fetchRequest.predicate = NSPredicate(format: "id == %@" ,id)
        do {
            
            /*managedContext.fetch(fetchRequest) will return array of person objects [personObjects]*/
            let item = try managedContext.fetch(fetchRequest)
            var arrRemovedMachine = [ImageMachineData]()
            for i in item {
                
                managedContext.delete(i)
                
                /*finally save the contexts*/
                try managedContext.save()
                
                /*update your array also*/
                arrRemovedMachine.append(i as! ImageMachineData)
            }
            return arrRemovedMachine
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
        
    }
    
    func fetchAllMachine() -> [ImageMachineData]?{
        
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ImageMachineData")
        
        do {
            let machine = try managedContext.fetch(fetchRequest)
            return machine as? [ImageMachineData]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func filterMachine(id: String) -> ImageMachineData? {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        let filter = id
        let predicate = NSPredicate(format: "id = %@", filter)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"ImageMachineData")
        fetchRequest.predicate = predicate
        
        do{
            let fetchedResults = try context.fetch(fetchRequest) as! [NSManagedObject]
            if let machine = fetchedResults.first as? ImageMachineData{
                return machine
            }
            
        } catch {
            return nil
        }
        
        return nil
    }
    
    func addImageToMachine(imageMachine: ImageMachineData, image: UIImage) -> ListImage {
        let listImage = ListImage(context: CoreDataManager.sharedManager.persistentContainer.viewContext)
        let imageData = image.pngData()
        listImage.images = imageData
        imageMachine.addToParentImageMachine(listImage)
        saveContext()
        return listImage
    }
    
    func listImage(images: ImageMachineData) -> [ListImage] {
        let request: NSFetchRequest<ListImage> = ListImage.fetchRequest()
        request.predicate = NSPredicate(format: "imageItems = %@", images)
        var fetchedImage: [ListImage] = []
        
        do {
            fetchedImage = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetching songs \(error)")
        }
        return fetchedImage
    }
    
    func removeImageFromMachine(imageMachine: ListImage, completion: @escaping (Bool) -> Void) {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        context.delete(imageMachine)
        saveContext()
        completion(true)
    }
    
}
