//
//  OutlineViewDataSource+Passthrough.swift
//  OutlineViewDiffableDataSource
//
//  Created by Steve Sparks on 2/9/20.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import Cocoa

public extension NSObject {
}

public class PassthroughOutlineViewDataSource: NSObject, NSOutlineViewDataSource, NSOutlineViewDelegate {
    func report(_ message: String = "", _ preamble: String = "", function: String = #function) {
//        let fn = String(describing: type(of: self))
//        print("--> \(preamble)\(fn) \(function) \(message) ")
    }

    var dataSource: NSOutlineViewDataSource!
    var delegate: NSOutlineViewDelegate?

    init(dataSource: NSOutlineViewDataSource, delegate: NSOutlineViewDelegate? = nil) {
        self.dataSource = dataSource
        self.delegate = delegate
        super.init()
    }

    enum OverriddenSelectors: String, CaseIterable {
        case outlineViewNumberOfChildrenOfItem = "outlineView:numberOfChildrenOfItem:"
        case outlineViewChildOfItem = "outlineView:child:ofItem:"
        case outlineViewIsItemExpandable = "outlineView:isItemExpandable:"
    }

    enum DataSourceSelectors: String, CaseIterable {
        case outlineViewPersistentObjectForItem = "outlineView:persistentObjectForItem:"
        case outlineViewItemForPersistentObject = "outlineView:itemForPersistentObject:"
        case outlineViewObjectValueForByItem = "outlineView:objectValueForTableColumn:byItem:"
        case outlineViewSetObjectValueForByItem = "outlineView:setObjectValue:forTableColumn:byItem:"
        case outlineViewSortDescriptorsDidChange = "outlineView:sortDescriptorsDidChange:"
        case outlineViewUpdateDraggingItemsForDrag = "outlineView:updateDraggingItemsForDrag:"
        case outlineViewPasteboardWriterForItem = "outlineView:pasteboardWriterForItem:"
        case outlineViewWriteItemsTo = "outlineView:writeItems:to:"
        case outlineViewValidateDrop = "outlineView:validateDrop:proposedItem:proposedChildIndex:"
        case outlineViewAcceptDrop = "outlineView:acceptDrop:item:childIndex:"
        case outlineViewDraggingBegin = "outlineView:draggingSession:willBeginAt:forItems:"
        case outlineViewDraggingEnd = "outlineView:draggingEndedAt:operation:"
    }

    enum DelegateSelectors: String, CaseIterable {
        case outlineViewColumnDidMove = "outlineViewColumnDidMove:"
        case outlineViewIsGroupItem = "outlineView:isGroupItem:"
        case outlineViewDidClick = "outlineView:didClick:"
        case outlineViewDidDrag = "outlineView:didDrag:"
        case outlineViewMouseDownInHeaderOf = "outlineView:mouseDownInHeaderOf:"
        case outlineViewShouldExpandItem = "outlineView:shouldExpandItem:"
        case outlineViewShouldCollapseItem = "outlineView:shouldCollapseItem:"
        case outlineViewShouldSelectItem = "outlineView:shouldSelectItem:"
        case outlineViewShouldSelectTableColumn = "outlineView:shouldSelect:"
        case outlineViewShouldEditTableColumn = "outlineView:shouldEdit:item:"
        case outlineViewViewForTableColumnItem = "outlineView:viewForTableColumn:item:"
        case outlineViewItemWillExpand = "outlineViewItemWillExpand:"
        case outlineViewItemWillCollapse = "outlineViewItemWillCollapse:"
        case outlineViewItemDidExpand = "outlineViewItemDidExpand:"
        case outlineViewItemDidCollapse = "outlineViewItemDidCollapse:"
        case outlineViewWillDisplayCellForTableColumnItem = "outlineView:willDisplayCell:forTableColumn:item:"
        case outlineViewWillDisplayOutlineCellForTableColumnItem = "outlineView:willDisplayOutlineCell:forTableColumn:item:"
    }

    override public func responds(to aSelector: Selector!) -> Bool {
        let sel = aSelector.description
        var ret = false
        var ident = "???"

        if let _ = OverriddenSelectors(rawValue: sel) {
            ident = "OVR"
            ret = true
        } else if let _ = DataSourceSelectors(rawValue: sel) {
            ident = "DS "
            ret = dataSource.responds(to: aSelector)
        } else if let _ = DelegateSelectors(rawValue: sel) {
            ident = "DLG"
            ret = delegate?.responds(to: aSelector) ?? false
        } else {
            ret = super.responds(to: aSelector)
        }

        // change this to print() if you wish
        _ = "\(ident) \(sel) -> \(ret)"
        return ret
    }

    public func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        report()
        return dataSource.outlineView!(outlineView, numberOfChildrenOfItem: item)
    }

    public func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        report()
        return dataSource.outlineView!(outlineView, child: index, ofItem: item)
    }

    public func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        report()
        return dataSource.outlineView!(outlineView, isItemExpandable: item)
    }

    ////

    public func outlineView(_ outlineView: NSOutlineView, persistentObjectForItem item: Any?) -> Any? {
        report()
        return dataSource.outlineView!(outlineView, persistentObjectForItem: item)
    }

    public func outlineView(_ outlineView: NSOutlineView, itemForPersistentObject object: Any) -> Any? {
        report()
        return dataSource.outlineView!(outlineView, itemForPersistentObject: object)
    }

    public func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
        report()
        return dataSource.outlineView!(outlineView, objectValueFor: tableColumn, byItem: item)
    }

    public func outlineView(_ outlineView: NSOutlineView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, byItem item: Any?) {
        report()
        dataSource.outlineView!(outlineView, setObjectValue: object, for: tableColumn, byItem: item)
    }

    public func outlineView(_ outlineView: NSOutlineView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        report()
        dataSource.outlineView!(outlineView, sortDescriptorsDidChange: oldDescriptors)
    }

    public func outlineView(_ outlineView: NSOutlineView, updateDraggingItemsForDrag draggingInfo: NSDraggingInfo) {
        report()
        dataSource.outlineView!(outlineView, updateDraggingItemsForDrag: draggingInfo)
    }

    public func outlineView(_ outlineView: NSOutlineView, pasteboardWriterForItem item: Any) -> NSPasteboardWriting? {
        report()
        return dataSource.outlineView?(outlineView, pasteboardWriterForItem: item)
    }

    public func outlineView(_ outlineView: NSOutlineView, writeItems items: [Any], to pasteboard: NSPasteboard) -> Bool {
        report()
        return dataSource.outlineView!(outlineView, writeItems: items, to: pasteboard)
    }

    public func outlineView(_ outlineView: NSOutlineView, validateDrop info: NSDraggingInfo, proposedItem item: Any?, proposedChildIndex index: Int) -> NSDragOperation {
        report()
        return dataSource.outlineView?(outlineView, validateDrop: info, proposedItem: item, proposedChildIndex: index) ?? .generic
    }

    public func outlineView(_ outlineView: NSOutlineView, acceptDrop info: NSDraggingInfo, item: Any?, childIndex index: Int) -> Bool {
        report()
        return dataSource.outlineView?(outlineView, acceptDrop: info, item: item, childIndex: index) ?? false
    }

    public func outlineView(_ outlineView: NSOutlineView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forItems draggedItems: [Any]) {
        report()
        dataSource.outlineView?(outlineView, draggingSession: session, willBeginAt: screenPoint, forItems: draggedItems)
    }

    public func outlineView(_ outlineView: NSOutlineView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation) {
        report()
        dataSource.outlineView?(outlineView, draggingSession: session, endedAt: screenPoint, operation: operation)
    }

    // MARK: - NSOutlineViewDelegate

    public func outlineViewColumnDidMove(_ notification: Notification) {
        report()
        delegate!.outlineViewColumnDidMove?(notification)
    }

    public func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
        report()
        return delegate!.outlineView!(outlineView, isGroupItem: item)
    }

    public func outlineView(_ outlineView: NSOutlineView, didClick tableColumn: NSTableColumn) {
        report()
        delegate!.outlineView!(outlineView, didClick: tableColumn)
    }

    public func outlineView(_ outlineView: NSOutlineView, didDrag tableColumn: NSTableColumn) {
        report()
        delegate!.outlineView!(outlineView, didDrag: tableColumn)
    }

    public func outlineView(_ outlineView: NSOutlineView, mouseDownInHeaderOf tableColumn: NSTableColumn) {
        report()
        delegate!.outlineView!(outlineView, mouseDownInHeaderOf: tableColumn)
    }

    public func outlineView(_ outlineView: NSOutlineView, shouldExpandItem item: Any) -> Bool {
        report()
        return delegate!.outlineView!(outlineView, shouldExpandItem: item)
    }

    public func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
        report()
        return delegate!.outlineView!(outlineView, shouldSelectItem: item)
    }

    public func outlineView(_ outlineView: NSOutlineView, shouldCollapseItem item: Any) -> Bool {
        report()
        return delegate!.outlineView!(outlineView, shouldCollapseItem: item)
    }

    public func outlineView(_ outlineView: NSOutlineView, shouldSelect tableColumn: NSTableColumn?) -> Bool {
        report()
        return delegate!.outlineView!(outlineView, shouldSelect: tableColumn)
    }

    public func outlineView(_ outlineView: NSOutlineView, shouldEdit tableColumn: NSTableColumn?, item: Any) -> Bool {
        report()
        return delegate!.outlineView!(outlineView, shouldEdit: tableColumn, item: item)
    }

    public func outlineViewItemWillCollapse(_ notification: Notification) {
        report()
        delegate!.outlineViewItemWillCollapse!(notification)
    }

    public func outlineViewItemWillExpand(_ notification: Notification) {
        report()
        delegate!.outlineViewItemWillExpand!(notification)
    }

    public func outlineViewItemDidCollapse(_ notification: Notification) {
        report()
        delegate!.outlineViewItemDidCollapse!(notification)
    }

    public func outlineViewItemDidExpand(_ notification: Notification) {
        report()
        delegate!.outlineViewItemDidExpand!(notification)
    }
    public func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        report()
        return delegate!.outlineView!(outlineView, viewFor: tableColumn, item: item) ?? nil
    }
    // MARK: - To Do
    // TODO: Implement the loop:
    //      - contrive a use of the method
    //      - note the selector logged in `responds(to:)`
    //      - add the selector to the DelegateSelectors array
    //      - uncomment the method down below
    //      - correct the code as necessary
    //
    //    public func outlineView(_ outlineView: NSOutlineView, shouldShowCellExpansionFor tableColumn: NSTableColumn?, item: Any) -> Bool {
    //        report()
    //        return delegate!.outlineView!(outlineView, shouldShowCellExpansionFor: tableColumn, item: item) ?? false
    //    }
    //    public func outlineView(_ outlineView: NSOutlineView, shouldReorderColumn columnIndex: Int, toColumn newColumnIndex: Int) -> Bool {
    //        report()
    //        return delegate!.outlineView!(outlineView, shouldReorderColumn: columnIndex, toColumn: newColumnIndex) ?? false
    //    }
    //    public func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
    //        report()
    //        return delegate!.outlineView!(outlineView, heightOfRowByItem: item) ??
    //            delegate!.outlineView!(outlineView, viewFor: nil, item: item)?.fittingSize.height ??
    //            16.0
    //    }
    //    public func outlineView(_ outlineView: NSOutlineView, sizeToFitWidthOfColumn column: Int) -> CGFloat {
    //        report()
    //        return delegate!.outlineView!(outlineView, sizeToFitWidthOfColumn: column) ?? 0.0
    //    }
    //    public func outlineView(_ outlineView: NSOutlineView, rowViewForItem item: Any) -> NSTableRowView? {
    //        report()
    //        return delegate!.outlineView!(outlineView, rowViewForItem: item) ?? nil
    //    }
    //    public func outlineView(_ outlineView: NSOutlineView, dataCellFor tableColumn: NSTableColumn?, item: Any) -> NSCell? {
    //        report()
    //        return delegate!.outlineView!(outlineView, dataCellFor: tableColumn, item: item) ?? nil
    //    }
    //    public func outlineView(_ outlineView: NSOutlineView, typeSelectStringFor tableColumn: NSTableColumn?, item: Any) -> String? {
    //        report()
    //        return delegate!.outlineView!(outlineView, typeSelectStringFor: tableColumn, item: item) ?? nil
    //    }
    //    public func outlineView(_ outlineView: NSOutlineView, shouldShowOutlineCellForItem item: Any) -> Bool {
    //        report()
    //        return delegate!.outlineView!(outlineView, shouldShowOutlineCellForItem: item) ?? false
    //    }
    //
    //    public func outlineView(_ outlineView: NSOutlineView, didAdd rowView: NSTableRowView, forRow row: Int) {
    //        report()
    //    }
    //    public func outlineView(_ outlineView: NSOutlineView, didRemove rowView: NSTableRowView, forRow row: Int) {
    //        report()
    //    }
    //
    //    public func outlineView(_ outlineView: NSOutlineView, willDisplayCell cell: Any, for tableColumn: NSTableColumn?, item: Any) {
    //        report()
    //    }
    //    public func outlineView(_ outlineView: NSOutlineView, willDisplayOutlineCell cell: Any, for tableColumn: NSTableColumn?, item: Any) {
    //        report()
    //    }
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

