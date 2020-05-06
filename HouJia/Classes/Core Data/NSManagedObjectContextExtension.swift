// NSManagedObjectContextExtension.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh.

import CoreData

extension NSManagedObjectContext {
  public func saveIfChanged() throws {
    guard hasChanges else { return }
    do {
      try save()
    } catch {
      logE(error)
      throw error
    }
  }
}
