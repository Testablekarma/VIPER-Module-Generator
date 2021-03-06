//
//  ViewController.swift
//  ViperModules
//
//  Created by Jonathan Pacheco on 29/12/15.
//  Copyright © 2015 Jonathan Pacheco. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var moduleNameCell:          NSFormCell!
    @IBOutlet weak var projectNameCell:         NSFormCell!
    @IBOutlet weak var developerNameCell:       NSFormCell!
    @IBOutlet weak var organizationNameCell:    NSFormCell!

//    override var representedObject: AnyObject? {
//        didSet {
//        // Update the view, if already loaded.
//        }
//    }
    
    @IBAction func generateModule(_ sender: AnyObject) {
        let model = ModuleModel().then {
            $0.moduleName           = self.moduleNameCell.stringValue
        }
        let filesManager = FilesManager(moduleModel: model)
        filesManager.generateModule()
    }

}

