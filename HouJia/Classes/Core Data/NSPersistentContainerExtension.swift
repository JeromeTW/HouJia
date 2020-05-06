// NSPersistentContainerExtension.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh.

import CoreData

extension NSPersistentContainer {
  public func saveContext(_ aContext: NSManagedObjectContext? = nil) throws {
    let context = aContext ?? viewContext
    guard context.hasChanges else { return }
    do {
      try context.save()
    } catch {
      logE(error)
      throw error
    }
  }
}
