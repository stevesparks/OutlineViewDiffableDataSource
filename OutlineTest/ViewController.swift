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

class ViewController: NSViewController {
    @IBOutlet weak var outlineView: NSOutlineView!

    let ds = ReorderableArrayDataSource()

    var diff: OutlineViewDiffableDataSource<String>!

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

        diff.applySnapshot()
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
        ds.contents["A"] = ["A2"]
        ds.contents["A1"] = ["A1b", "A1a", "A1c"]
        ds.contents["B"] = ["B2", "B1", "A1"]
        diff.applySnapshot()
    }
}
