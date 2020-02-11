//
//  ViewController.swift
//  OutlineTest
//
//  Created by Steve Sparks on 2/11/20.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import Cocoa
import OutlineViewDiffableDataSource

var acceptableTypes = [NSPasteboard.PasteboardType.string]

class MyArrayDataSource: ArrayDataSource {
    var draggedItem: String?

    var replacementDest: AnyHashable?
    var replacementIndex: Int?
}

class ViewController: NSViewController {
    @IBOutlet weak var outlineView: NSOutlineView!

    let ds = MyArrayDataSource()

    var diff: OutlineViewDiffableDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()

        outlineView.registerForDraggedTypes(Array(acceptableTypes))
        ds.contents =  [
            ArrayDataSource.RootIdentfier: ["A", "B"],
            "A": ["A1", "A2"],
            "A1": ["A1a", "A1b"],
            "B": ["B1", "B2"],
            "B2": ["B2b"]
        ]

        diff = OutlineViewDiffableDataSource(baseDataSource: ds, targetView: outlineView, delegate: ds)

        outlineView.dataSource = diff
        outlineView.delegate = diff
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear() {
        super.viewDidAppear()

        outlineView.expandItem(nil, expandChildren: true)
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }

    @objc
    @IBAction func moveStuff(_ sender: Any?) {
        ds.contents["A1"] = ["A1b", "A1a", "A1c"]
        ds.contents["B"] = ["B2", "B1", "XX"]
        diff.applySnapshot()
    }
}


extension MyArrayDataSource {
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
            print("Winder!")
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

}
