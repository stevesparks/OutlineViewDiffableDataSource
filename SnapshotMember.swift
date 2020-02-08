//
//  SnapshotMember.swift
//  OutlineViewDiffableDataSource
//
//  Created by Steve Sparks on 2/8/20.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import Foundation

struct SnapshotMember {
    var item: OutlineMemberItem?
    var children: [SnapshotMember] = []
    var isExpandable = false

    func indexPath(of member: SnapshotMember) -> IndexPath? {
        for (idx, child) in children.enumerated() {
            if child == member {
                return IndexPath(indexes: [idx])
            } else if let childIP = child.indexPath(of: member) {
                return IndexPath(indexes: [idx]).appending(childIP)
            }
        }
        return nil
    }

    func parent(of member: SnapshotMember) -> SnapshotMember? {
        for child in children {
            if child == member { return self }
            if let p = child.parent(of: member) { return p }
        }
        return nil
    }

    func search(for item: OutlineMemberItem) -> SnapshotMember? {
        if item == self.item { return self }
        for child in children {
            if let hit = child.search(for: item) {
                return hit
            }
        }
        return nil
    }
}

extension SnapshotMember: CustomStringConvertible {
    var description: String {
        let thing: Any = item ?? "-nil-"
        return "<OutlineMember: \(String(describing: thing))>"
    }
}

extension SnapshotMember: Equatable {
    static func ==(lhs: SnapshotMember, rhs: SnapshotMember) -> Bool {
        return lhs.item == rhs.item
    }
}

extension SnapshotMember: Hashable {
    func hash(into hasher: inout Hasher) {
        item.hash(into: &hasher)
    }
}


public enum ChangeInstruction: CustomStringConvertible {
    case remove(IndexPath)
    case insert(AnyHashable, IndexPath)
    case move(IndexPath, IndexPath)

    public var description: String {
        switch self {
        case .remove(let idx): return "Removing @ \(idx)"
        case .insert(let item, let idx): return "Inserting @ \(idx): \(item)"
        case .move(let from, let to): return "Move from \(from) to \(to)"
        }
    }
}

public typealias SnapshotDiff = [ChangeInstruction]


// Here is where the old snapshot and new snapshot are rectified
extension SnapshotMember {
    func instructions(forMorphingInto other: SnapshotMember, from baseIndexPath: IndexPath) -> SnapshotDiff {
        let src = children
        let dst = other.children

        var result = SnapshotDiff()

        func log(_ str: String) {
            // Uncomment for logging info
            //            print(str)
        }

        var work = src
        if src != dst {

            log("\(baseIndexPath) BEGIN")
            log("\(src) -> \(dst)")
            log(" -> \(work)")

            func appendResult(_ inst: ChangeInstruction) {
                result.append(inst)
                log("APPEND: \(inst)\n -> \(work)")
            }

            log("\(baseIndexPath) DELETE PHASE")
            // 1. Find things that don't belong and remove them.
            var deletables = [SnapshotMember]()
            for item in work {
                if !dst.contains(item) {
                    deletables.append(item)
                }
            }
            for deletable in deletables {
                if let delIdx = work.firstIndex(of: deletable) {
                    work.remove(at: delIdx)
                    appendResult(.remove(baseIndexPath.appending(delIdx)))
                }
            }

            log("\(baseIndexPath) INSERT PHASE")
            // 2. Insert missing items.
            for (dstIdx, item) in dst.enumerated() {
                if work.firstIndex(of: item) == nil {
                    // insert
                    work.insert(item, at: dstIdx)
                    appendResult(.insert(item, baseIndexPath.appending(dstIdx)))
                }
            }

            // 3. Moves
            // At this point src and dst have the same contents
            // possibly in different order

            log("\(baseIndexPath) MOVE PHASE")
            for (dstIdx, item) in dst.enumerated() {
                if let workIdx = work.firstIndex(of: item) {
                    if workIdx != dstIdx {
                        work.remove(at: workIdx)
                        work.insert(item, at: dstIdx)
                        appendResult(.move(baseIndexPath.appending(workIdx), baseIndexPath.appending(dstIdx)))
                    }
                }
            }
        }

        log("\(baseIndexPath) RECURSION PHASE")

        // 4. Recurse
        // The hash value is based on the actual item, and not its children.
        // Ergo each item must generate its own instruction set.
        for (index, item) in dst.enumerated() {
            let indexPath = baseIndexPath.appending(index)
            if let workIdx = work.firstIndex(of: item) {
                let workItem = work[workIdx]
                result.append(contentsOf: workItem.instructions(forMorphingInto: item, from: indexPath))
            }
        }

        return result
    }
}
