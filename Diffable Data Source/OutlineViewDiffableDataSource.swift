//
//  OutlineViewDiffableDataSource.swift
//  OutlineViewDiffableDataSource
//
//  Created by Steve Sparks on 2/8/20.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import Cocoa

/***
 * Created by Steve Sparks for Big Nerd Ranch
 *
 * I saw a demo of UITableViewDiffableDataSource and loved it. I was working on a
 * large Mac app with a complex NSOutlineView. Each time the contents of the outline
 * view changed, we were reloading, and had a TON of plumbing around hiding that fact.
 */
public class OutlineViewDiffableDataSource<T: Hashable>: PassthroughOutlineViewDataSource {
    private let outlineView: NSOutlineView!

    public init(baseDataSource: NSOutlineViewDataSource, targetView: NSOutlineView, delegate: NSOutlineViewDelegate? = nil) {
        self.outlineView = targetView
        super.init(dataSource: baseDataSource, delegate: delegate)
        snapshot = OutlineViewSnapshot(from: dataSource, for: outlineView)
        targetView.dataSource = self
    }

    private var snapshot = OutlineViewSnapshot<T>()

    // Use when the model has changed and you want animation
    public func applySnapshot() {
        guard Thread.current == Thread.main else {
            DispatchQueue.main.async { self.applySnapshot() }
            return
        }

        let oldSnapshot = snapshot
        guard !oldSnapshot.isEmpty else {
            refreshSnapshot()
            outlineView.reloadData()
            return
        }

        refreshSnapshot()
        let newSnapshot = snapshot
        outlineView.apply(oldSnapshot.instructions(forMorphingInto: newSnapshot))
    }

    public func refreshSnapshot() {
        snapshot = OutlineViewSnapshot(from: dataSource, for: outlineView)
    }

    var isEmpty: Bool {
        return snapshot.isEmpty
    }

    override public func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        guard let item = item as? T? else {
            return 0
        }
        let ret = snapshot.numberOfChildren(ofItem: item)
        return ret
    }

    override public func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if item == nil { return snapshot.child(index, ofItem: nil) ?? "" }

        guard let item = item as? T? else {
            return ""
        }
        let ret = snapshot.child(index, ofItem: item)
        return ret ?? ""
    }

    override public func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        guard let item = item as? T else {
            return false
        }
        let ret = snapshot.isItemExpandable(item)
        return ret
    }

    // Makes snapshots animate in and out
    public override func outlineView(_ outlineView: NSOutlineView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forItems draggedItems: [Any]) {
        super.outlineView(outlineView, draggingSession: session, willBeginAt: screenPoint, forItems: draggedItems)
//        applySnapshot()
    }

    public override func outlineView(_ outlineView: NSOutlineView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation) {
        super.outlineView(outlineView, draggingSession: session, endedAt: screenPoint, operation: operation)
        applySnapshot()
    }
}

public extension NSObject {
    func report(_ message: String = "", _ preamble: String = "", function: String = #function) {
                let fn = String(describing: type(of: self))
                print("--> \(preamble)\(fn) \(function) \(message) ")
    }
}

// Everything passes through.
