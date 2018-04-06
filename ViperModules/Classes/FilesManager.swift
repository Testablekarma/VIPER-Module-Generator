//
//  FilesManager.swift
//  ViperModules
//
//  Created by Jonathan Pacheco on 29/12/15.
//  Copyright © 2015 Jonathan Pacheco. All rights reserved.
//

import Cocoa

enum FilesManagerType {
    case file
    case folder
    case invalid
}

class FilesManager {
    
    var moduleModel: ModuleModel
    fileprivate var baseURL: String?
    fileprivate var templatePath: URL! {
        get { return Bundle.main.url(forResource: "Templates", withExtension: nil)! }
    }
    
    init(moduleModel: ModuleModel) {
        self.moduleModel = moduleModel
    }
    
    func generateModule() {
        self.loadBaseFolder { path in
            self.createFolders((path, self.moduleModel))
            self.createFolders((path, self.moduleModel))
        }
    }
    
    fileprivate func createFolders(_ params: (baseUrl: URL?, model: ModuleModel)) {
        guard let baseUrl = params.baseUrl?.appendingPathComponent(params.model.moduleName) else { return }
        self.createFolder(baseUrl)
        guard let enumerator = FileManager.default.enumerator(at: self.templatePath,
            includingPropertiesForKeys: [URLResourceKey.isDirectoryKey],
            options: FileManager.DirectoryEnumerationOptions.init(rawValue: 0), errorHandler:  { _, _ in return true })
            else { return }
        for url in enumerator {
            guard let url = url as? URL else { break }
            let fileType = FilesManager.isPathDirectory(url.path)
            let fileName: String? = (fileType == .file ? params.model.moduleName : nil)
            if let fileUrl = self.getNewUrlWithBase(baseUrl, template: url, fileName: fileName) {
                print(fileUrl)
                switch fileType {
                case .folder:
                    self.createFolder(fileUrl)
                case .file:
                    ClassGenerator.generateClass(fileUrl, templateUrl: url, model: params.model)
                default: break
                }
            }
        }
        self.showResults(baseUrl)
    }
    
    fileprivate func createFolder(_ url: URL) {
        let path = url.path
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: path) {
            do {
                try fileManager.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
            } catch {}
        }
    }

    fileprivate func getNewUrlWithBase(_ base: URL, template: URL, fileName: String?) -> URL? {
        let templateBasePath = self.templatePath.path
        let templatePath = template.path
        let range = (templateBasePath.endIndex ..< templatePath.endIndex)
        let newPath = templatePath[range]
        let newUrl = base.appendingPathComponent(newPath)
        
        if let fileName = fileName {
            var lastPathComponent = newUrl.lastPathComponent
            lastPathComponent = lastPathComponent.replacingOccurrences(of: "Template", with: fileName)
            lastPathComponent = (lastPathComponent as NSString).deletingPathExtension
            lastPathComponent += ".swift"
            return newUrl.deletingLastPathComponent().appendingPathComponent(lastPathComponent)
        }
        
        return newUrl
    }
    
    fileprivate func loadBaseFolder(_ callback: @escaping (_ path: URL) -> Void) {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.canCreateDirectories = true
        panel.begin { result in
            if result == NSFileHandlingPanelOKButton {
                if let theDoc = panel.urls.first {
                    callback(theDoc)
                }
            }
        }
    }
}

// Utils

extension FilesManager {
    
    func showResults(_ baseUrl: URL) {
        let path = (baseUrl.path) + "/"
        NSWorkspace.shared().selectFile(nil, inFileViewerRootedAtPath: path)
    }
    
    class func isPathDirectory(_ path: String) -> FilesManagerType {
        var isDirectory: ObjCBool = ObjCBool(false)
        if FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) {
            return isDirectory.boolValue ? .folder : .file
        }
        return .invalid
    }
}
