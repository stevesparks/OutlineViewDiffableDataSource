//
//  ReorderableArrayDataSource.swift
//  OutlineTest
//
//  Created by Steve Sparks on 2/11/20.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import Cocoa

class ReorderableArrayDataSource: ArrayDataSource {
    var draggedItem: String?

    var replacementDest: AnyHashable?
    var replacementIndex: Int?

    // Set the string
    func outlineView(_ outlineView: NSOutlineView, pasteboardWriterForItem item: Any) -> NSPasteboardWriting? {
        let pasteboardItem = NSPasteboardItem()
        pasteboardItem.setString(String(describing: item), forType: NSPasteboard.PasteboardType.string)
        return pasteboardItem
    }

    // Decide if it's okay to land here
    func outlineView(_ outlineView: NSOutlineView, validateDrop info: NSDraggingInfo, proposedItem item: Any?, proposedChildIndex index: Int) -> NSDragOperation {
        if let item = item as? String,
            let sourceText = info.draggingPasteboard.string(forType: .string),
            item != sourceText {
            return .move
        }
        if item == nil { return .move }
        return []
    }

    func outlineView(_ outlineView: NSOutlineView, acceptDrop info: NSDraggingInfo, item: Any?, childIndex index: Int) -> Bool {
        guard let sourceText = info.draggingPasteboard.string(forType: .string) else { return false }
        if let item = item as? String {
            if item == sourceText { return false }
            let targetDescription: String = {
                return index == -1 ? "onto \(item)" : "into index \(index) of \(item)"
            }()
            report("drop `\(sourceText)` \(targetDescription)")
            if var arr = contents[item] {
                if index >= 0, index <= arr.count {
                    arr.insert(sourceText, at: index)
                } else {
                    arr.append(sourceText)
                }
                contents[item] = arr
            } else {
                contents[item] = [sourceText]
            }
            return true
        } else if item == nil {
            print("Dropped into window but not on a row")
            contents[ArrayDataSource.RootIdentfier]?.append(sourceText)
            return true
        } else {
            return false
        }
    }

    func outlineView(_ outlineView: NSOutlineView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forItems draggedItems: [Any]) {
        if let item = draggedItems.first as? String {
            draggedItem = item
            if let (dest, idx) = self.remove(item) {
                replacementDest = dest
                replacementIndex = idx
            }
        }

        report(" \(draggedItems.map({ return String.init(describing: $0) }).joined(separator: " "))")
    }

    public func outlineView(_ outlineView: NSOutlineView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation) {
        guard let sourceText = session.draggingPasteboard.string(forType: .string) else { return }
        guard operation == .move else {
            if let dest = replacementDest, let idx = replacementIndex {
                var arr = contents[dest]!
                arr.insert(sourceText, at: idx)
                contents[dest] = arr
            }
            return
        }
        report("\(operation) \(sourceText)")
    }

    func report(_ message: String = "", _ preamble: String = "", function: String = #function) {
        let fn = String(describing: type(of: self))
        print("--> \(preamble)\(fn) \(function) \(message) ")
    }
}
