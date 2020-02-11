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
    var delegate: NSOutlineViewDelegate?

    init(dataSource: NSOutlineViewDataSource, delegate: NSOutlineViewDelegate? = nil) {
        self.dataSource = dataSource
        self.delegate = delegate
        super.init()
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

    public func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
        //        report()
        return dataSource.outlineView?(outlineView, objectValueFor: tableColumn, byItem: item)
    }

    public func outlineView(_ outlineView: NSOutlineView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, byItem item: Any?) {
        report()
        dataSource.outlineView?(outlineView, setObjectValue: object, for: tableColumn, byItem: item)
    }

    public func outlineView(_ outlineView: NSOutlineView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        report()
        dataSource.outlineView?(outlineView, sortDescriptorsDidChange: oldDescriptors)
    }

    // MARK: - Dragging

    public func outlineView(_ outlineView: NSOutlineView, updateDraggingItemsForDrag draggingInfo: NSDraggingInfo) {
        report()
        dataSource.outlineView?(outlineView, updateDraggingItemsForDrag: draggingInfo)
    }

    public func outlineView(_ outlineView: NSOutlineView, pasteboardWriterForItem item: Any) -> NSPasteboardWriting? {
        report()
        return dataSource.outlineView?(outlineView, pasteboardWriterForItem: item)
    }

    public func outlineView(_ outlineView: NSOutlineView, writeItems items: [Any], to pasteboard: NSPasteboard) -> Bool {
        report()
        return dataSource.outlineView?(outlineView, writeItems: items, to: pasteboard) ?? false
    }

    public func outlineView(_ outlineView: NSOutlineView, acceptDrop info: NSDraggingInfo, item: Any?, childIndex index: Int) -> Bool {
        return dataSource.outlineView?(outlineView, acceptDrop: info, item: item, childIndex: index) ?? false
    }

    public func outlineView(_ outlineView: NSOutlineView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation) {
        dataSource.outlineView?(outlineView, draggingSession: session, endedAt: screenPoint, operation: operation)
    }

    public func outlineView(_ outlineView: NSOutlineView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forItems draggedItems: [Any]) {
        report()
        dataSource.outlineView?(outlineView, draggingSession: session, willBeginAt: screenPoint, forItems: draggedItems)
    }

    public func outlineView(_ outlineView: NSOutlineView, validateDrop info: NSDraggingInfo, proposedItem item: Any?, proposedChildIndex index: Int) -> NSDragOperation {
        return dataSource.outlineView?(outlineView, validateDrop: info, proposedItem: item, proposedChildIndex: index) ?? NSDragOperation.generic
    }
}

extension PassthroughOutlineViewDataSource: NSOutlineViewDelegate {
//    public func outlineViewColumnDidMove(_ notification: Notification) {
//        report()
//        delegate?.outlineViewColumnDidMove?(notification)
//    }
//
//    public func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
//        report()
//        return delegate?.outlineView?(outlineView, isGroupItem: item) ?? false
//    }
//
//    public func outlineView(_ outlineView: NSOutlineView, didClick tableColumn: NSTableColumn) {
//        report()
//        delegate?.outlineView?(outlineView, didClick: tableColumn)
//    }
//    public func outlineView(_ outlineView: NSOutlineView, didDrag tableColumn: NSTableColumn) {
//        report()
//        delegate?.outlineView?(outlineView, didDrag: tableColumn)
//    }
//    public func outlineView(_ outlineView: NSOutlineView, mouseDownInHeaderOf tableColumn: NSTableColumn) {
//        report()
//        delegate?.outlineView?(outlineView, mouseDownInHeaderOf: tableColumn)
//    }

//
    public func outlineView(_ outlineView: NSOutlineView, shouldExpandItem item: Any) -> Bool {
        report()
        return delegate?.outlineView?(outlineView, shouldExpandItem: item) ?? true
    }
    public func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
        report()
        return delegate?.outlineView?(outlineView, shouldSelectItem: item) ?? true
    }
    public func outlineView(_ outlineView: NSOutlineView, shouldCollapseItem item: Any) -> Bool {
        report()
        return delegate?.outlineView?(outlineView, shouldCollapseItem: item) ?? true
    }
    public func outlineView(_ outlineView: NSOutlineView, shouldSelect tableColumn: NSTableColumn?) -> Bool {
        report()
        return delegate?.outlineView?(outlineView, shouldSelect: tableColumn) ?? false
    }
    public func outlineView(_ outlineView: NSOutlineView, shouldEdit tableColumn: NSTableColumn?, item: Any) -> Bool {
        report()
        return delegate?.outlineView?(outlineView, shouldCollapseItem: item) ?? false
    }
    public func outlineView(_ outlineView: NSOutlineView, shouldShowCellExpansionFor tableColumn: NSTableColumn?, item: Any) -> Bool {
        report()
        return delegate?.outlineView?(outlineView, shouldShowCellExpansionFor: tableColumn, item: item) ?? false
    }
    public func outlineView(_ outlineView: NSOutlineView, shouldReorderColumn columnIndex: Int, toColumn newColumnIndex: Int) -> Bool {
        report()
        return delegate?.outlineView?(outlineView, shouldReorderColumn: columnIndex, toColumn: newColumnIndex) ?? false
    }

    public func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        report()
        return delegate?.outlineView?(outlineView, heightOfRowByItem: item) ??
            delegate?.outlineView?(outlineView, viewFor: nil, item: item)?.fittingSize.height ??
            16.0
    }
//    public func outlineView(_ outlineView: NSOutlineView, sizeToFitWidthOfColumn column: Int) -> CGFloat {
//        report()
//        return delegate?.outlineView?(outlineView, sizeToFitWidthOfColumn: column) ?? 0.0
//    }
//    public func outlineView(_ outlineView: NSOutlineView, rowViewForItem item: Any) -> NSTableRowView? {
//        report()
//        return delegate?.outlineView?(outlineView, rowViewForItem: item) ?? nil
//    }
    public func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        report()
        return delegate?.outlineView?(outlineView, viewFor: tableColumn, item: item) ?? nil
    }
//    public func outlineView(_ outlineView: NSOutlineView, dataCellFor tableColumn: NSTableColumn?, item: Any) -> NSCell? {
//        report()
//        return delegate?.outlineView?(outlineView, dataCellFor: tableColumn, item: item) ?? nil
//    }
//    public func outlineView(_ outlineView: NSOutlineView, typeSelectStringFor tableColumn: NSTableColumn?, item: Any) -> String? {
//        report()
//        return delegate?.outlineView?(outlineView, typeSelectStringFor: tableColumn, item: item) ?? nil
//    }
//    public func outlineView(_ outlineView: NSOutlineView, shouldShowOutlineCellForItem item: Any) -> Bool {
//        report()
//        return delegate?.outlineView?(outlineView, shouldShowOutlineCellForItem: item) ?? false
//    }
//
//    public func outlineView(_ outlineView: NSOutlineView, didAdd rowView: NSTableRowView, forRow row: Int) {
//        report()
//    }
//    public func outlineView(_ outlineView: NSOutlineView, didRemove rowView: NSTableRowView, forRow row: Int) {
//        report()
//    }

    public func outlineView(_ outlineView: NSOutlineView, willDisplayCell cell: Any, for tableColumn: NSTableColumn?, item: Any) {
        report()
    }
    public func outlineView(_ outlineView: NSOutlineView, willDisplayOutlineCell cell: Any, for tableColumn: NSTableColumn?, item: Any) {
        report()
    }
//    public func outlineView(_ outlineView: NSOutlineView, shouldTrackCell cell: NSCell, for tableColumn: NSTableColumn?, item: Any) -> Bool {
//        report()
//    }
//    public func outlineView(_ outlineView: NSOutlineView, selectionIndexesForProposedSelection proposedSelectionIndexes: IndexSet) -> IndexSet {
//        report()
//    }
//    public func outlineView(_ outlineView: NSOutlineView, shouldTypeSelectFor event: NSEvent, withCurrentSearch searchString: String?) -> Bool {
//        report()
//    }
//    public func outlineView(_ outlineView: NSOutlineView, nextTypeSelectMatchFromItem startItem: Any, toItem endItem: Any, for searchString: String) -> Any? {
//        report()
//    }
//    public func outlineView(_ outlineView: NSOutlineView, toolTipFor cell: NSCell, rect: NSRectPointer, tableColumn: NSTableColumn?, item: Any, mouseLocation: NSPoint) -> String {
//        report()
//    }
//    public func selectionShouldChange(in outlineView: NSOutlineView) -> Bool {
//        report()
//    }
}
