//
//  ArrayDataSource.swift
//  OutlineViewDiffableDataSourceTests
//
//  Created by Steve Sparks on 2/10/20.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import Cocoa

/***
 * This simple data source lets you stash an array of items
 */
class ArrayDataSource: NSObject, NSOutlineViewDataSource {
    static let RootIdentfier = UUID().uuidString

    var root: [AnyHashable] {
        get { return contents[ArrayDataSource.RootIdentfier]! }
        set { contents[ArrayDataSource.RootIdentfier] = newValue }
    }

    var contents: [AnyHashable: [AnyHashable]] = [ArrayDataSource.RootIdentfier:[]]
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let item = item as? String, let arr = contents[item] {
            return arr[index]
        } else {
            return root[index]
        }
    }

    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let item = item as? String {
            return contents[item]?.count ?? 0
        } else {
            return root.count
        }
    }

    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let item = item as? String {
            return (contents[item]?.count ?? 0) > 0
        }
        return false
    }
    
    public func remove(_ val: AnyHashable) -> (AnyHashable, Int)? {
        for (k, v) in contents {
            if let idx = v.firstIndex(of: val) {
                var m = v
                m.remove(at: idx)
                contents[k] = m.isEmpty ? nil : m
                return (k, idx)
            }
        }
        return nil
    }
}

extension ArrayDataSource: NSOutlineViewDelegate {
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        return NSTextField(labelWithString: String(describing: item))
    }
}
