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
    case PresenterFolderName    = "Presenter"
    case ViewsFolderName        = "View"
    case RoutingFolderName      = "Routing"
    case ControllerFolderName   = "Controllers"
    
}

enum ModuleFileNames: String {
    
    case ModelFileName          = "Model"
    case InteractorFileName     = "Interactor"
    case ModuleFileName         = "Module"
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
    
    indirect case presenterFolder(ModuleFolders)
    indirect case viewsFolder(ModuleFolders)
    indirect case routingFolder(ModuleFolders)
    indirect case controllersFolder(ModuleFolders)

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
                
            case .presenterFolder(let parentFolder):
                return parentFolder.URL.appendingPathComponent(ModuleFolderNames.PresenterFolderName.rawValue)
            case .viewsFolder(let parentFolder):
                return parentFolder.URL.appendingPathComponent(ModuleFolderNames.ViewsFolderName.rawValue)
            case .routingFolder(let parentFolder):
                return parentFolder.URL.appendingPathComponent(ModuleFolderNames.RoutingFolderName.rawValue)
            case .controllersFolder(let parentFolder):
                return parentFolder.URL.appendingPathComponent(ModuleFolderNames.ControllerFolderName.rawValue)
            }
        }
    }
    
}

enum ModuleFiles {
    
    case modelFile(baseURL: Foundation.URL, module: ModuleModel)
    case interactorFile(baseURL: Foundation.URL, module: ModuleModel)
    case moduleFile(baseURL: Foundation.URL, module: ModuleModel)
    case presenterFile(baseURL: Foundation.URL, module: ModuleModel)
    case viewControllerFile(baseURL: Foundation.URL, module: ModuleModel)
    case wireframeFile(baseURL: Foundation.URL, module: ModuleModel)
    
    var URL: Foundation.URL {
        get {
            switch self {
            case .modelFile(let baseURL, let module):
                let fileName = ModuleFileNames.ModelFileName.nameWithExtension
                return ModuleFolders.dataFolder(baseURL).URL.appendingPathComponent("\(module.moduleName)\(fileName)")
                
            case .interactorFile(let baseURL, let module):
                let fileName = ModuleFileNames.InteractorFileName.nameWithExtension
                return ModuleFolders.logicFolder(baseURL).URL.appendingPathComponent("\(module.moduleName)\(fileName)")
                
            case .moduleFile(let baseURL, let module):
                let fileName = ModuleFileNames.ModuleFileName.nameWithExtension
                return ModuleFolders.moduleFolder(baseURL).URL.appendingPathComponent("\(module.moduleName)\(fileName)")
                
            case .presenterFile(let baseURL, let module):
                let UIFolder = ModuleFolders.uiFolder(baseURL)
                let fileName = ModuleFileNames.PresenterFileName.nameWithExtension
                return ModuleFolders.presenterFolder(UIFolder).URL.appendingPathComponent("\(module.moduleName)\(fileName)")
                
            case .viewControllerFile(let baseURL, let module):
                let UIFolder = ModuleFolders.uiFolder(baseURL)
                let viewFolder = ModuleFolders.viewsFolder(UIFolder)
                let fileName = ModuleFileNames.WireframeFileName.nameWithExtension
                return ModuleFolders.controllersFolder(viewFolder).URL.appendingPathComponent("\(module.moduleName)\(fileName)")
                
            case .wireframeFile(let baseURL, let module):
                let UIFolder = ModuleFolders.uiFolder(baseURL)
                let fileName = ModuleFileNames.ViewControllerFileName.nameWithExtension
                return ModuleFolders.viewsFolder(UIFolder).URL.appendingPathComponent("\(module.moduleName)\(fileName)")

            }
        }
    }
    
}

