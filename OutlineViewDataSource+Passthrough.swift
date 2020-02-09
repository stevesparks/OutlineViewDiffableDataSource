//
//  OutlineViewDataSource+Passthrough.swift
//  OutlineViewDiffableDataSource
//
//  Created by Steve Sparks on 2/9/20.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import Cocoa

public class PassthroughOutlineViewDataSource: NSObject, NSOutlineViewDataSource {
    var dataSource: NSOutlineViewDataSource!
    fileprivate var capabilities: DataSourceCapabilities!

    init(dataSource: NSOutlineViewDataSource) {
        self.dataSource = dataSource
        self.capabilities = dataSource.capabilities
        super.init()
    }

    override public func responds(to aSelector: Selector!) -> Bool {
        if let selector = aSelector {
            switch selector {
            case .numberOfChildrenForItem: return capabilities.respondsToNumberOfChildren
            case .childOfItem: return capabilities.respondsToChildForItem
            case .isItemExpandable: return capabilities.respondsToIsItemExpandable
            case .persistentObjectForItem: return capabilities.respondsToPersistentObjectForItem
            case .itemForPersistentObject: return capabilities.respondsToItemForPersistentObject
            case .pasteboardWriter: return capabilities.respondsToPasteboardWriterForItem
            case .writeItems: return capabilities.respondsToWriteItems
            case .sortDescriptorsDidChange: return capabilities.respondsToSortDescriptorsDidChange
            case .objectValueForColumn: return capabilities.respondsToObjectValueForTableColumnGet
            case .setObjectValueForColumn: return capabilities.respondsToObjectValueForTableColumnSet
            case .updateDraggingItems: return capabilities.respondsToUpdateDraggingItemsForDrag
            case .acceptDrop: return capabilities.respondsToAcceptDrop
            case .validateDrop: return capabilities.respondsToValidateDrop
            case .dragBegan: return capabilities.respondsToDragSessionBegan
            case .dragEnded: return capabilities.respondsToDragSessionEnded
            default: break
            }
        }
        return super.responds(to: aSelector)
    }

    // Defaults are to satisfy the compiler.
    // If the underlying data source doesn't respond, we'll handle it in responds(to:)
    public func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        return dataSource.outlineView?(outlineView, numberOfChildrenOfItem: item) ?? 0
    }

    public func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        return dataSource.outlineView?(outlineView, child: index, ofItem: item) ?? ""
    }

    public func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return dataSource.outlineView?(outlineView, isItemExpandable: item) ?? false
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

fileprivate struct DataSourceCapabilities {
    var respondsToNumberOfChildren: Bool = false
    var respondsToChildForItem: Bool = false
    var respondsToIsItemExpandable: Bool = false
    var respondsToPersistentObjectForItem: Bool = false
    var respondsToItemForPersistentObject: Bool = false
    var respondsToUpdateDraggingItemsForDrag: Bool = false
    var respondsToPasteboardWriterForItem: Bool = false
    var respondsToSortDescriptorsDidChange: Bool = false
    var respondsToWriteItems: Bool = false
    var respondsToObjectValueForTableColumnSet: Bool = false
    var respondsToObjectValueForTableColumnGet: Bool = false
    var respondsToAcceptDrop: Bool = false
    var respondsToValidateDrop: Bool = false
    var respondsToDragSessionBegan: Bool = false
    var respondsToDragSessionEnded: Bool = false
}

extension Selector {
    static let numberOfChildrenForItem = #selector(NSOutlineViewDataSource.outlineView(_:numberOfChildrenOfItem:))
    static let childOfItem = #selector(NSOutlineViewDataSource.outlineView(_:child:ofItem:))
    static let isItemExpandable = #selector(NSOutlineViewDataSource.outlineView(_:isItemExpandable:))

    static let persistentObjectForItem = #selector(NSOutlineViewDataSource.outlineView(_:persistentObjectForItem:))
    static let itemForPersistentObject = #selector(NSOutlineViewDataSource.outlineView(_:itemForPersistentObject:))
    static let pasteboardWriter = #selector(NSOutlineViewDataSource.outlineView(_:pasteboardWriterForItem:))
    static let writeItems = #selector(NSOutlineViewDataSource.outlineView(_:writeItems:to:))
    static let sortDescriptorsDidChange = #selector(NSOutlineViewDataSource.outlineView(_:sortDescriptorsDidChange:))

    static let objectValueForColumn = #selector(NSOutlineViewDataSource.outlineView(_:objectValueFor:byItem:))
    static let setObjectValueForColumn = #selector(NSOutlineViewDataSource.outlineView(_:setObjectValue:for:byItem:))

    static let updateDraggingItems = #selector(NSOutlineViewDataSource.outlineView(_:updateDraggingItemsForDrag:))
    static let acceptDrop = #selector(NSOutlineViewDataSource.outlineView(_:acceptDrop:item:childIndex:))
    static let validateDrop = #selector(NSOutlineViewDataSource.outlineView(_:validateDrop:proposedItem:proposedChildIndex:))
    static let dragBegan = #selector(NSOutlineViewDataSource.outlineView(_:draggingSession:willBeginAt:forItems:))
    static let dragEnded = #selector(NSOutlineViewDataSource.outlineView(_:draggingSession:endedAt:operation:))
}

fileprivate extension NSOutlineViewDataSource {

    var capabilities: DataSourceCapabilities {
        var ret = DataSourceCapabilities()

        ret.respondsToNumberOfChildren = responds(to: .numberOfChildrenForItem)
        ret.respondsToChildForItem = responds(to: .childOfItem)
        ret.respondsToIsItemExpandable = responds(to: .isItemExpandable)

        ret.respondsToPersistentObjectForItem = responds(to: .persistentObjectForItem)
        ret.respondsToItemForPersistentObject = responds(to: .itemForPersistentObject)
        ret.respondsToPasteboardWriterForItem = responds(to: .pasteboardWriter)
        ret.respondsToWriteItems = responds(to: .writeItems)
        ret.respondsToSortDescriptorsDidChange = responds(to: .sortDescriptorsDidChange)

        ret.respondsToObjectValueForTableColumnGet = responds(to: .objectValueForColumn)
        ret.respondsToObjectValueForTableColumnSet = responds(to: .setObjectValueForColumn)

        ret.respondsToUpdateDraggingItemsForDrag = responds(to: .updateDraggingItems)
        ret.respondsToAcceptDrop = responds(to: .acceptDrop)
        ret.respondsToValidateDrop = responds(to: .validateDrop)
        ret.respondsToDragSessionBegan = responds(to: .dragBegan)
        ret.respondsToDragSessionEnded = responds(to: .dragEnded)

        return ret
    }
}

extension DataSourceCapabilities {
    var isDragTarget: Bool { return respondsToAcceptDrop }
    var isDragSource: Bool {
        return
            respondsToDragSessionBegan ||
            respondsToUpdateDraggingItemsForDrag ||
            respondsToPasteboardWriterForItem
    }
}
