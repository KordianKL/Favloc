//
//  CoreDataManager.swift
//  Favloc
//
//  Created by Kordian Ledzion on 03/01/2018.
//  Copyright © 2018 KordianLedzion. All rights reserved.
//

import Foundation
import CoreData

class MainCollectionViewModel: DataSource {
    
    var count: Int {
        return places.count
    }
    
    private lazy var context: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { (description, error) in
            if let error = error as Error? {
                fatalError("CoreData error: \(error), \(error.localizedDescription)")
            }
        }
        return container.viewContext
    }()
    
    private var places = [Place]()
    
    private let containerName: String
    
    init(persistentContainerName containerName: String) {
        defer {
            fetch()
        }
        self.containerName = containerName
    }
    
    func select(itemAt: Int) -> Result<Place, DataSourceError> {
        return places.count == 0 ?
            Result.failure(DataSourceError.noData) :
            Result.success(places[itemAt])
    }
    
    func insert(itemAt index: Int, into ind: Int) {
        let temp = places.remove(at: index)
        places.insert(temp, at: ind)
        fixOrder()
        saveContext()
    }
    
    func add(_ completion: () -> Void) {
        let newPlace = Place(entity: Place.entity(), insertInto: context)
        newPlace.index = Int16(places.count)
        places.append(newPlace)
        saveContext()
        completion()
    }
    
    func finishedEditing(_ completion: () -> Void) {
        saveContext()
        completion()
    }
    
    func delete(itemsAt indexPaths: [IndexPath], _ completion: () -> Void) {
        let indexes = indexPaths.map { return $0.row }
        for index in indexes {
            context.delete(places[index])
        }
        places = places.filter { return !indexes.contains(Int($0.index))}
        fixOrder()
        saveContext()
        completion()
    }
    
    private func fixOrder() {
        for i in 0..<places.count {
            places[i].index = Int16(i)
        }
    }
    
    private func fetch() {
        let request: NSFetchRequest<Place> = Place.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]
        places = try! context.fetch(request)
        if places.count == 0 {
            loadMocks()
        }
    }
    
    private func loadMocks() {
        let ahimsa = Place(entity: Place.entity(), insertInto: context)
        ahimsa.desc = Mocks.ahimsa.description
        ahimsa.name = Mocks.ahimsa.name
        ahimsa.photo = Mocks.ahimsa.photo
        ahimsa.longitiude = Mocks.ahimsa.longitiude
        ahimsa.latitiude = Mocks.ahimsa.latitiude
        ahimsa.index = 0
        places.append(ahimsa)
        
        let pwr = Place(entity: Place.entity(), insertInto: context)
        pwr.desc = Mocks.pWr.description
        pwr.name = Mocks.pWr.name
        pwr.photo = Mocks.pWr.photo
        pwr.longitiude = Mocks.pWr.longitiude
        pwr.latitiude = Mocks.pWr.latitiude
        pwr.index = 2
        places.append(pwr)
        
        let adSpec = Place(entity: Place.entity(), insertInto: context)
        adSpec.desc = Mocks.adSp.description
        adSpec.name = Mocks.adSp.name
        adSpec.photo = Mocks.adSp.photo
        adSpec.longitiude = Mocks.adSp.longitiude
        adSpec.latitiude = Mocks.adSp.latitiude
        adSpec.index = 1
        places.append(adSpec)
        
        saveContext()
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let err = error as Error
                fatalError("Saving Context error: \(err), \(err.localizedDescription)")
            }
        }
    }

}
