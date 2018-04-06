//
//  ClassGenerator.swift
//  ViperModules
//
//  Created by Jonathan Pacheco on 29/12/15.
//  Copyright © 2015 Jonathan Pacheco. All rights reserved.
//

import Cocoa

private enum ClassGeneratorKeys: String {
    case ModuleName         = "{{module_name}}"
    case ProjectName        = "{{project_name}}"
    case DeveloperName      = "{{developer_name}}"
    case OrganizationName   = "{{organization_name}}"
    case CurrentDate        = "{{current_date}}"
}

class ClassGenerator {

    class func generateClass(_ fileUrl: URL, templateUrl: URL, model: ModuleModel) {
        self.generateFile(templateUrl, urlFile: fileUrl, model: model)
    }
    
    fileprivate class func generateFile(_ templateUrl: URL, urlFile: URL, model: ModuleModel) {
        self.createFile(urlFile)
        let path = urlFile.path
        let templatePath = templateUrl.path
        if var text = self.readFileTemplate(templatePath) {
            self.replaceModuleNames(&text, model: model)
            self.writeFile(path, text: text)
        }
    }
    
    fileprivate class func createFile(_ url: URL) {
        let path = url.path
        
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: path) {
            fileManager.createFile(atPath: path, contents: nil, attributes: nil)
        }
    }
    
    fileprivate class func replaceModuleNames(_ text: inout String, model: ModuleModel) {
        text = text.replacingOccurrences(of: ClassGeneratorKeys.ModuleName.rawValue, with: model.moduleName)
        text = text.replacingOccurrences(of: ClassGeneratorKeys.ProjectName.rawValue, with: model.projectName)
        text = text.replacingOccurrences(of: ClassGeneratorKeys.DeveloperName.rawValue, with: model.developerName)
        text = text.replacingOccurrences(of: ClassGeneratorKeys.OrganizationName.rawValue, with: model.organizationName)
        text = text.replacingOccurrences(of: ClassGeneratorKeys.CurrentDate.rawValue, with: self.getCurrentDate())
    }
    
    fileprivate class func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: Date())
    }
    
    fileprivate class func readFileTemplate(_ path: String) -> String? {
        do {
            return try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue).description
        } catch { return nil }
    }
    
    fileprivate class func writeFile(_ path: String, text: String) {
        do {
            try text.write(toFile: path, atomically: false, encoding: String.Encoding.utf8)
        } catch {}
    }
}
