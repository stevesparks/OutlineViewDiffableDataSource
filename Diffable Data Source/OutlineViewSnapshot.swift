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
        var raw = root.instructions(forMorphingInto: destination.root, from: IndexPath())
        raw.reduce()
        return raw
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

extension OutlineViewSnapshotDiff {
    mutating func reduce() {
        // search for all removed, then try to pair with an inserted
        let removeds = allRemoved
        for removed in removeds {
            let inserteds = allInserted
            if let item = removed.item,
                let inserted = inserteds.first(where: { $0.item == item }) {
                let newInstruction = OutlineChangeInstruction.move(removed.targetIndexPath, inserted.targetIndexPath)
                delete(removed)
                guard let insertIdx = firstIndex(where: { $0 == inserted }) else {
                    preconditionFailure("how does this happen")
                }
                insert(newInstruction, at: insertIdx)
            }
        }
    }

    mutating func delete(_ item: OutlineChangeInstruction) {
        if let removeIdx = firstIndex(where: { $0 == item }) {
            remove(at: removeIdx)
        }
    }
    var allRemoved: [OutlineChangeInstruction] {
        return self.filter { if case OutlineChangeInstruction.remove = $0 { return true } else { return false } }
    }
    var allInserted: [OutlineChangeInstruction] {
        return self.filter { if case OutlineChangeInstruction.insert = $0 { return true } else { return false } }
    }
}

extension OutlineChangeInstruction: Equatable {
    public static func ==(lhs: OutlineChangeInstruction, rhs: OutlineChangeInstruction) -> Bool {
        switch (lhs, rhs) {
        case (.insert(let l, let l2), .insert(let r, let r2)): return l == r && l2 == r2
        case (.remove(let l, let l2), .remove(let r, let r2)): return l == r && l2 == r2
        case (.move(let l, let l2), .move(let r, let r2)): return l == r && l2 == r2
        default: break
        }

        return false
    }

    var item: AnyHashable? {
        switch self {
        case .remove(let item, _): return item
        case .insert(let item, _): return item
        default: return nil
        }
    }

    var targetIndexPath: IndexPath {
        switch self {
        case .remove(_, let indexPath): return indexPath
        case .insert(_, let indexPath): return indexPath
        case .move(_, let indexPath): return indexPath
        }
    }
}
