//
//  OutlineViewDiffableDataSource.swift
//  OutlineViewDiffableDataSource
//
//  Created by Steve Sparks on 2/8/20.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import Cocoa

typealias OutlineMemberItem = AnyHashable

/***
 * Created by Steve Sparks for Big Nerd Ranch
 *
 * I saw a demo of UITableViewDiffableDataSource and loved it. I was working on a
 * large Mac app with a complex NSOutlineView. Each time the contents of the outline
 * view changed, we were reloading, and had a TON of plumbing around hiding that fact.
 */
public class OutlineViewDiffableDataSource: NSObject {
    private let dataSource: NSOutlineViewDataSource!
    private let outlineView: NSOutlineView!

    init(baseDataSource: NSOutlineViewDataSource, targetView: NSOutlineView) {
        self.dataSource = baseDataSource
        self.outlineView = targetView
        super.init()
        snapshot = Snapshot(from: dataSource, for: outlineView)
        targetView.dataSource = self
    }

    private var snapshot = Snapshot.empty

    // Use when the model has changed and you want animation
    public func applySnapshot() {
        guard Thread.current == Thread.main else {
            DispatchQueue.main.async { self.applySnapshot() }
            return
        }

        guard !isEmpty else {
            refreshSnapshot()
            outlineView.reloadData()
            return
        }

        let oldSnapshot = snapshot
        refreshSnapshot()
        let newSnapshot = snapshot
        outlineView.apply(oldSnapshot.instructions(forMorphingInto: newSnapshot))
    }

    public func refreshSnapshot() {
        snapshot = Snapshot(from: dataSource, for: outlineView)
    }

    var isEmpty: Bool {
        return snapshot.isEmpty
    }
}


extension NSObject {
    func report(_ message: String = "", _ preamble: String = "", function: String = #function) {
//        let fn = String(describing: type(of: self))
//        print("--> \(preamble)\(fn) \(function) \(message) ")
    }
}

// Everything passes through.
extension OutlineViewDiffableDataSource: NSOutlineViewDataSource {

    public func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        guard let item = item as? AnyHashable? else {
            return 0
        }
        let ret = snapshot.numberOfChildren(ofItem: item)
        report(" item \(String(describing: item)) -> \(ret)")
        return ret
    }

    public func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if item == nil { return snapshot.child(index, ofItem: nil) ?? "" }

        guard let item = item as? OutlineMemberItem? else {
            return ""
        }
        let ret = snapshot.child(index, ofItem: item)
        //        report(" child \(index) item \(String(describing: item)) -> \(String(describing: ret))")
        return ret ?? ""
    }

    public func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        guard let item = item as? AnyHashable else {
            return false
        }
        let ret = snapshot.isItemExpandable(item)
        //        report(" item \(String(describing: item)) -> \(ret)")
        return ret
    }

    public func outlineView(_ outlineView: NSOutlineView, persistentObjectForItem item: Any?) -> Any? {
        report()
        return dataSource.outlineView?(outlineView, persistentObjectForItem: item)
    }

    public func outlineView(_ outlineView: NSOutlineView, itemForPersistentObject object: Any) -> Any? {
        report()
        return dataSource.outlineView?(outlineView, itemForPersistentObject: object)
    }

    public func outlineView(_ outlineView: NSOutlineView, updateDraggingItemsForDrag draggingInfo: NSDraggingInfo) {
        report()
        dataSource.outlineView?(outlineView, updateDraggingItemsForDrag: draggingInfo)
    }

    public func outlineView(_ outlineView: NSOutlineView, pasteboardWriterForItem item: Any) -> NSPasteboardWriting? {
        report()
        return dataSource.outlineView?(outlineView, pasteboardWriterForItem: item)
    }

    public func outlineView(_ outlineView: NSOutlineView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        report()
        dataSource.outlineView?(outlineView, sortDescriptorsDidChange: oldDescriptors)
    }

    public func outlineView(_ outlineView: NSOutlineView, writeItems items: [Any], to pasteboard: NSPasteboard) -> Bool {
        report()
        return dataSource.outlineView?(outlineView, writeItems: items, to: pasteboard) ?? false
    }

    public func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
        //        report()
        return dataSource.outlineView?(outlineView, objectValueFor: tableColumn, byItem: item)
    }

    public func outlineView(_ outlineView: NSOutlineView, acceptDrop info: NSDraggingInfo, item: Any?, childIndex index: Int) -> Bool {
        report()
        return dataSource.outlineView?(outlineView, acceptDrop: info, item: item, childIndex: index) ?? false
    }

    public func outlineView(_ outlineView: NSOutlineView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, byItem item: Any?) {
        report()
        dataSource.outlineView?(outlineView, setObjectValue: object, for: tableColumn, byItem: item)
    }

    public func outlineView(_ outlineView: NSOutlineView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation) {
        report()
        dataSource.outlineView?(outlineView, draggingSession: session, endedAt: screenPoint, operation: operation)
    }

    public func outlineView(_ outlineView: NSOutlineView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forItems draggedItems: [Any]) {
        report()
        dataSource.outlineView?(outlineView, draggingSession: session, willBeginAt: screenPoint, forItems: draggedItems)
    }

    public func outlineView(_ outlineView: NSOutlineView, validateDrop info: NSDraggingInfo, proposedItem item: Any?, proposedChildIndex index: Int) -> NSDragOperation {
        report()
        return dataSource.outlineView?(outlineView, validateDrop: info, proposedItem: item, proposedChildIndex: index) ?? NSDragOperation.generic
    }
}

