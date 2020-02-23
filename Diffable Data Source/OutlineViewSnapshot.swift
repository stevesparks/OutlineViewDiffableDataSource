//
//  Snapshot.swift
//  OutlineViewDiffableDataSource
//
//  Created by Steve Sparks on 2/8/20.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import Cocoa

public class OutlineViewSnapshot<T: Hashable>: NSObject {
    private var root: OutlineViewSnapshotMember<T>

    init(from ds: NSOutlineViewDataSource, for view: NSOutlineView) {
        root = OutlineViewSnapshot.member(using: ds, in: view)
        super.init()
    }

    override init() {
        root = OutlineViewSnapshotMember()
        super.init()
    }

    var isEmpty: Bool { return root.children.isEmpty }

    private static func member(for item: T? = nil, using ds: NSOutlineViewDataSource, in view: NSOutlineView, recursive: Bool = true) -> OutlineViewSnapshotMember<T> {
        let itemCount = ds.outlineView?(view, numberOfChildrenOfItem: item) ?? 0
        var children = [OutlineViewSnapshotMember<T>]()
        if recursive && itemCount > 0 {
            (0..<itemCount).forEach { counter in
                if let child = ds.outlineView?(view, child: counter, ofItem: item) as? T {
                    children.append(member(for: child, using: ds, in: view, recursive: recursive))
                }
            }
        }

        let exp: Bool = {
            if let item = item {
                return ds.outlineView?(view, isItemExpandable: item) ?? false
            } else {
                return false
            }
        }()

        return OutlineViewSnapshotMember(item: item, children: children, isExpandable: exp)
    }

//    static let empty = OutlineViewSnapshot()

    func parent(of member: OutlineViewSnapshotMember<T>) -> OutlineViewSnapshotMember<T>? {
        return root.parent(of: member)
    }

    func instructions(forMorphingInto destination: OutlineViewSnapshot) -> OutlineViewSnapshotDiff {
        return root.instructions(forMorphingInto: destination.root, from: IndexPath())
    }

    func numberOfChildren(ofItem item: T?) -> Int {
        if let item = item {
            if let member = root.search(for: item) {
                return member.children.count
            }
        } else {
            return root.children.count
        }
        return 0
    }

    func child(_ index: Int, ofItem item: T?) -> T? {
        if let item = item {
            if let member = root.search(for: item) {
                return member.children[index].item
            }
        } else {
            return root.children[index].item
        }
        return nil
    }

    func isItemExpandable(_ item: T) -> Bool {
        if let member = root.search(for: item) {
            return member.isExpandable
        }
        return false
    }
}
