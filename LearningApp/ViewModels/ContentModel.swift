//
//  ContentModel.swift
//  LearningApp
//
//  Created by Andrew Mullen on 2021-12-06.
//

import Foundation

class ContentModel: ObservableObject {
    
    // List of modules
    @Published var modules = [Module]()
    
    // Current module
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    // Current lesson
    @Published var currentLesson: Lessons?
    var currentLessonIndex = 0
    
    var styleData: Data?
    
    init() {
        getLocalData()
    }
    
    // MARK: Data Methods
    
    func getLocalData() {
        // Get url to JSON file
        let jsonURL = Bundle.main.url(forResource: "data", withExtension: "json")
        do {
            // Read the file into a data object
            let jsonData = try Data(contentsOf: jsonURL!)
            let jsonDecoder = JSONDecoder()
            
            // Try to decode the JSON into an array of modules
            let moduleArray = try jsonDecoder.decode([Module].self, from: jsonData)
            
            // Assign parsed modules to modules property
            self.modules = moduleArray
        }
        catch {
            print(error)
        }
        
        // Parse the style data
        let styleURL = Bundle.main.url(forResource: "style", withExtension: "html")
        
        do {
            // Read the file into a data object
            let styleData = try Data(contentsOf: styleURL!)
            
            self.styleData = styleData
        }
        catch {
            print(error)
        }
    }
    
    // MARK: Module Navigation Methods
    
    func beginModule(_ moduleid:Int) {
        // Find the index for this module id
        for index in 0..<modules.count {
            if modules[index].id == moduleid {
                // Found the matching module
                currentModuleIndex = index
                break
            }
        }
        // Set current module
        currentModule = modules[currentModuleIndex]
    }
    
    func beginLesson(_ lessonIndex: Int) {
        
        // Check that the lesson index is within range of module lessons
        if lessonIndex < currentModule!.content.lessons.count {
            currentLessonIndex = lessonIndex
        }
        else {
            currentLessonIndex = 0
        }
        // Set the lesson index
        currentLesson = currentModule!.content.lessons[currentLessonIndex]
        
        
    }
    
    func nextLesson() {
        // Advance the lesson index
        currentLessonIndex += 1
        
        // Check that it is range
        if  currentLessonIndex < currentModule!.content.lessons.count {
            // set the current lesson property
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
        }
        else {
            // Reset the lesson state
            currentLessonIndex = 0
            currentLesson = nil
        }
        
    }
    
    func hasNextLesson() -> Bool {
        return currentLessonIndex + 1 < currentModule!.content.lessons.count
    }
}

