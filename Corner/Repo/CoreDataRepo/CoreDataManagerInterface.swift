//
//  CoreDataManagerInterface.swift
//  Corner
//
//  Created by manish singh on 03/10/24.
//

import Foundation
import CoreData

//This will be confirm by CoreDataManager class.
protocol CoreDataManagerInterface {
    func saveContext()
    func fetchEntities<T: NSManagedObject>(ofType type: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> [T]?
    func createEntity<T: NSManagedObject>(ofType type: T.Type) -> T?
    func delete(entity: NSManagedObject)
}
