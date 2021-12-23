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
    
    // Current Question
    @Published var currentQuestion: Question?
    var currentQuestionIndex = 0
    
    // Current lesson explanation
    @Published var codeText = NSAttributedString()
    
    // current selected content and test
    @Published var currentContentSelected: Int?
    @Published var currentTestSelected: Int?
    
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
        codeText = addStyling(currentLesson!.explanation)
        
        
    }
    
    func nextLesson() {
        // Advance the lesson index
        currentLessonIndex += 1
        
        // Check that it is range
        if  currentLessonIndex < currentModule!.content.lessons.count {
            // set the current lesson property
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            codeText = addStyling(currentLesson!.explanation)
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
    
    func beginTest(_ moduleId: Int) {
        
        // Set the current module
        beginModule(moduleId)
        
        // Set the current question
        currentQuestionIndex = 0
        
        // if there are questions set teh current question to the first one
        if currentModule?.test.questions.count ?? 0 > 0 {
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            
            // Set the question content as well
            codeText = addStyling(currentQuestion!.content)
            
        }
        
    }
    
    func nextQuestion() {
        
        // Advance the question index
        currentQuestionIndex += 1
        
        // Check that its within the range of questions
        if currentQuestionIndex < currentModule!.test.questions.count {
            
            // Set the current question
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeText = addStyling(currentQuestion!.content)
        }
        // If not then reset the properties
        else {
            currentQuestionIndex = 0
            currentQuestion = nil
        }
        
    }
    
    // MARK: Code Styling
    private func  addStyling(_ htmlString: String) -> NSAttributedString {
        
        var resultString = NSAttributedString()
        var data = Data()
        
        // Add the styling data
        if styleData != nil {
            data.append(self.styleData!)
        }
        
        // Add the html data
        data.append(Data(htmlString.utf8))
        
        // Convert to attributed String
            // Can use a do catch block if you take out the if and the question mark -> Used when you need to handle the error
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            resultString = attributedString
        }
        
        return resultString

    }
}

