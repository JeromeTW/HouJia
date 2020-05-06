// CoreDataConnect.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh.

import CoreData
import UIKit

public class CoreDataConnect {
  public let persistentContainer: NSPersistentContainer!

  public lazy var backgroundContext: NSManagedObjectContext = {
    persistentContainer.newBackgroundContext()
  }()

  public lazy var viewContext = persistentContainer.viewContext

  // MARK: Init with dependency

  public init(container: NSPersistentContainer) {
    persistentContainer = container
    persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
  }

  public convenience init() {
    self.init(container: PersistentContainerManager.shared.persistentContainer)
  }

  // MARK: - Functions
  public func getProperContext() -> NSManagedObjectContext {
    if Thread.isMainThread {
      return viewContext
    } else {
      return backgroundContext
    }
  }
  
  // insert
  // NOTE: myEntityName(在Video.xcdatamodeld中設定) 必須跟 class name 一致才能用範型
  public func insert<T: NSManagedObject>(type _: T.Type, attributeInfo: [String: Any], aContext: NSManagedObjectContext? = nil) throws {
    var context: NSManagedObjectContext!
    if let notNil = aContext {
      context = notNil
    } else {
      context = getProperContext()
    }
    let insetObject = NSEntityDescription.insertNewObject(forEntityName: String(describing: T.self), into: context)

    for (key, value) in attributeInfo {
      insetObject.setValue(value, forKey: key)
    }

    try persistentContainer.saveContext(context)
  }

  // retrieve
  // NOTE: 如果找不到結果會回傳 nil, 不會回傳空陣列
  public func retrieve<T: NSManagedObject>(type _: T.Type, predicate: NSPredicate? = nil, sort: [[String: Bool]]? = nil, limit: Int? = nil, aContext: NSManagedObjectContext? = nil) -> [T]? {
    var context: NSManagedObjectContext!
    if let notNil = aContext {
      context = notNil
    } else {
      context = getProperContext()
    }
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: T.self))

    // predicate
    request.predicate = predicate

    // sort
    if let mySort = sort {
      var sortArr: [NSSortDescriptor] = []
      for sortCond in mySort {
        for (key, value) in sortCond {
          sortArr.append(NSSortDescriptor(key: key, ascending: value))
        }
      }

      request.sortDescriptors = sortArr
    }

    // limit
    if let limitNumber = limit {
      request.fetchLimit = limitNumber
    }

    do {
      let result = try context.fetch(request) as! [T]
      return result.isEmpty ? nil : result

    } catch {
      fatalError("\(error)")
    }
  }

  // update
  public func update<T: NSManagedObject>(type: T.Type, predicate: NSPredicate? = nil, limit: Int? = 1, attributeInfo: [String: Any], aContext: NSManagedObjectContext? = nil) throws {
    if let results = self.retrieve(type: type, predicate: predicate, sort: nil, limit: limit, aContext: aContext) {
      for result in results {
        for (key, value) in attributeInfo {
          result.setValue(value, forKey: key)
        }
      }
      try persistentContainer.saveContext(aContext)
    }
  }

  // delete
  public func delete<T: NSManagedObject>(type: T.Type, predicate: NSPredicate? = nil, aContext: NSManagedObjectContext? = nil) throws {
    var context: NSManagedObjectContext!
    if let notNil = aContext {
      context = notNil
    } else {
      context = getProperContext()
    }
    if let results = self.retrieve(type: type, predicate: predicate, sort: nil, limit: nil, aContext: aContext) {
      for result in results {
        context.delete(result)
      }

      try persistentContainer.saveContext(context)
    }
  }

  public func getCount<T: NSManagedObject>(type _: T.Type, predicate: NSPredicate? = nil, aContext: NSManagedObjectContext? = nil) -> Int {
    var context: NSManagedObjectContext!
    if let notNil = aContext {
      context = notNil
    } else {
      context = getProperContext()
    }
    var count = 0
    let request = NSFetchRequest<NSNumber>(entityName: String(describing: T.self))

    // predicate
    request.predicate = predicate
    request.resultType = .countResultType

    do {
      let countResult = try context.fetch(request)
      // 获取数量
      count = countResult.first!.intValue
    } catch let error as NSError {
      assertionFailure("Could not fetch \(error), \(error.userInfo)")
    }
    return count
  }

  public func getFRC<T: NSManagedObject>(type _: T.Type, predicate: NSPredicate? = nil, sortDescriptors:
    [NSSortDescriptor], limit: Int? = nil, sectionNameKeyPath: String? = nil, cacheName: String? = nil, aContext: NSManagedObjectContext? = nil) -> NSFetchedResultsController<T> {
    var context: NSManagedObjectContext!
    if let notNil = aContext {
      context = notNil
    } else {
      context = getProperContext()
    }
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: T.self))

    // predicate
    request.predicate = predicate
    // sort
    request.sortDescriptors = sortDescriptors

    // limit
    if let limitNumber = limit {
      request.fetchLimit = limitNumber
    }
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: context,
                                                              sectionNameKeyPath: sectionNameKeyPath,
                                                              cacheName: cacheName) as! NSFetchedResultsController<T>
    do {
      try fetchedResultsController.performFetch()
    } catch {
      logE(error)
    }

    return fetchedResultsController
  }
}

public protocol HasID {
  var id: Int64 { get set }
}

// MARK: - HasID

extension CoreDataConnect {
  // This Entity must has id property
  public func generateNewID<T: HasID>(_: T.Type, aContext: NSManagedObjectContext? = nil) -> Int64 {
    var context: NSManagedObjectContext!
    if let notNil = aContext {
      context = notNil
    } else {
      context = getProperContext()
    }
    var newID: Int64 = 1
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: T.self))
    request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
    request.fetchLimit = 1

    do {
      let result = try context.fetch(request) as? [T]
      if let first = result?.first {
        newID = first.id + 1
      }
      return newID
    } catch {
      fatalError("\(error)")
    }
  }
}

// MARK: - HasOrder

public protocol HasOrder {
  var order: Int64 { get set }
}

extension CoreDataConnect {
  // This Entity must has order property
  public func generateNewOrder<T: HasOrder>(_: T.Type, aContext: NSManagedObjectContext? = nil) -> Int64 {
    var context: NSManagedObjectContext!
    if let notNil = aContext {
      context = notNil
    } else {
      context = getProperContext()
    }
    var newOrder: Int64 = 1
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: T.self))
    request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: false)]
    request.fetchLimit = 1

    do {
      let result = try context.fetch(request) as? [T]
      if let first = result?.first {
        newOrder = first.order + 1
      }
      return newOrder
    } catch {
      fatalError("\(error)")
    }
  }
}
