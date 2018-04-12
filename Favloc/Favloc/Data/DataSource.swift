//
//  DataSource.swift
//  Favloc
//
//  Created by Kordian Ledzion on 13/01/2018.
//  Copyright © 2018 KordianLedzion. All rights reserved.
//

import Foundation

enum DataSourceError: String, Error {
    
    case noData = "No data fetched"
    
    var description: String {
        return self.rawValue
    }
}

enum Result<V, E> {
    case success(V)
    case failure(E)
}

protocol DataSource {
    
    var count: Int { get }
    func select(itemAt: Int) -> Result<Place, DataSourceError>
    func insert(itemAt: Int, into: Int) -> Void
    func add(_ completion: () -> Void) -> Void
    func finishedEditing(_ completion: () -> Void) -> Void
    func delete(itemsAt: [IndexPath], _ comepletion: () -> Void) -> Void
}
