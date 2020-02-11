//
//  NSOutlineView+Snapshot.swift
//  OutlineViewDiffableDataSource
//
//  Created by Steve Sparks on 2/8/20.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import Cocoa

// Turn a diff into commands
extension NSOutlineView {
    func apply(_ snapshot: OutlineViewSnapshotDiff, with animation: NSTableView.AnimationOptions = [.effectFade]) {
        beginUpdates()
        snapshot.forEach { instr in
            switch instr {
            case .insert(_, let indexPath):
                let parent = lastParent(for: indexPath)
                if let childIndex = indexPath.last {
                    insertItems(at: [childIndex], inParent: parent, withAnimation: animation)
                }
            case .move(let src, let dst):
                let srcParent = lastParent(for: src)
                let dstParent = lastParent(for: dst)

                if let srcChild = src.last, let dstChild = dst.last {
                    moveItem(at: srcChild, inParent: srcParent, to: dstChild, inParent: dstParent)
                }
            case .remove(let indexPath):
                let parent = lastParent(for: indexPath)
                if let childIndex = indexPath.last {
                    removeItems(at: [childIndex], inParent: parent, withAnimation: animation)
                }
            }
        }
        endUpdates()
    }

    func lastParent(for indexPath: IndexPath) -> Any? {
        var parent: Any?

        var ip = indexPath
        ip.removeLast()

        for index in ip {
            if let g = child(index, ofItem: parent) {
                parent = g
            }
        }
        return parent
    }
}
