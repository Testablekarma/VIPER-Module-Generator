//
//  Constants.swift
//  ViperModules
//
//  Created by Jonathan Pacheco on 29/12/15.
//  Copyright © 2015 Jonathan Pacheco. All rights reserved.
//

import Cocoa

enum ModuleFolderNames: String {
    
    case DataFolderName         = "Data"
    case LogicFolderName        = "Logic"
    case ModuleFolderName       = "Module"
    case UIFolderName           = "UI"
    
}

enum ModuleFileNames: String {
    
    case InteractorFileName     = "Interactor"
    case ProtocolsFileName      = "Protocols"
    case PresenterFileName      = "Presenter"
    case WireframeFileName      = "Wireframe"
    case ViewControllerFileName = "ViewController"
    
    var nameWithExtension: String {
        get { return self.rawValue + ".swift" }
    }
    
}

enum ModuleFolders {
    
    case defaultFolder(baseUrl: Foundation.URL, moduleName: String)
    case dataFolder(Foundation.URL)
    case logicFolder(Foundation.URL)
    case moduleFolder(Foundation.URL)
    case uiFolder(Foundation.URL)

    var URL: Foundation.URL {
        get {
            switch self {
            case .defaultFolder(let baseURL, let moduleName):
                return baseURL.appendingPathComponent(moduleName)
                
            case .dataFolder(let baseURL):
                return baseURL.appendingPathComponent(ModuleFolderNames.DataFolderName.rawValue)
            case .logicFolder(let baseURL):
                return baseURL.appendingPathComponent(ModuleFolderNames.LogicFolderName.rawValue)
            case .moduleFolder(let baseURL):
                return baseURL.appendingPathComponent(ModuleFolderNames.ModuleFolderName.rawValue)
            case .uiFolder(let baseURL):
                return baseURL.appendingPathComponent(ModuleFolderNames.UIFolderName.rawValue)
            }
        }
    }
    
}

enum ModuleFiles {

    case interactorFile(baseURL: Foundation.URL, module: ModuleModel)
    case presenterFile(baseURL: Foundation.URL, module: ModuleModel)
    case viewControllerFile(baseURL: Foundation.URL, module: ModuleModel)
    case wireframeFile(baseURL: Foundation.URL, module: ModuleModel)
    case protocolFile(baseURL: Foundation.URL, module: ModuleModel)
    
    var URL: Foundation.URL {
        get {
            switch self {
                
            case .interactorFile(let baseURL, let module):
                let fileName = ModuleFileNames.InteractorFileName.nameWithExtension
                return ModuleFolders.logicFolder(baseURL).URL.appendingPathComponent("\(module.moduleName)\(fileName)")
                
            case .presenterFile(let baseURL, let module):
                let fileName = ModuleFileNames.PresenterFileName.nameWithExtension
                return ModuleFolders.uiFolder(baseURL).URL.appendingPathComponent("\(module.moduleName)\(fileName)")
                
            case .viewControllerFile(let baseURL, let module):
                let fileName = ModuleFileNames.WireframeFileName.nameWithExtension
                return ModuleFolders.uiFolder(baseURL).URL.appendingPathComponent("\(module.moduleName)\(fileName)")
                
            case .wireframeFile(let baseURL, let module):
                let fileName = ModuleFileNames.ViewControllerFileName.nameWithExtension
                return ModuleFolders.moduleFolder(baseURL).URL.appendingPathComponent("\(module.moduleName)\(fileName)")
            
            case .protocolFile(let baseURL, let module):
                let fileName = ModuleFileNames.ProtocolsFileName.nameWithExtension
                return ModuleFolders.moduleFolder(baseURL).URL.appendingPathComponent("\(module.moduleName)\(fileName)")
            }
        }
    }
    
}

