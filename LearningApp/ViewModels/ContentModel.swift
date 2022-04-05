//
//  ContentModel.swift
//  LearningApp
//
//  Created by Andrew Mullen on 2021-12-06.
//

import Foundation
import Firebase
import UIKit

class ContentModel: ObservableObject {
    
    let db = Firestore.firestore()
    
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
        // Parse local style.html
        getLocalStyles()
        
        // Get database modules
        getDatabaseModules()
        
        // Download remote json and parse data
        //getRemoteData()
    }
    
    // MARK: Data Methods
    func getLessons(module: Module, completion: @escaping () -> Void) {
        // Specify path
        let collection = db.collection("modules").document(module.id).collection("lessons")
        
        // Get documents
        collection.getDocuments { snapshot, error in
            if error == nil && snapshot != nil {
                // Array to track lessons
                var lessons = [Lessons]()
                
                // Loop through the documents and build array of lessons
                for doc in snapshot!.documents {
                    // New lesson
                    var l = Lessons()
                    
                    l.id = doc["id"] as? String ?? UUID().uuidString
                    l.title = doc["title"] as? String ?? ""
                    l.video = doc["video"] as? String ?? ""
                    l.duration = doc["duration"] as? String ?? ""
                    l.explanation = doc["explanation"] as? String ?? ""
                    
                    // Add lesson to array
                    lessons.append(l)
                }
                // Set lesson to module
                // module.content.lessons = lessons can't just do this
                // Loop through publsihed modules array and find one that id matches this one
                for (i, m) in self.modules.enumerated() {
                    // Find the module we want
                    if m.id == module.id {
                        // Set the lessons
                        self.modules[i].content.lessons = lessons
                        
                        // Call completion closure
                        completion()
                    }
                }
                
            }
        }
    }
    
    func getQuestions(module: Module, completion: @escaping () -> Void) {
        
        // Specify path
        let collection = db.collection("modules").document(module.id).collection("questions")
        
        // get documents
        collection.getDocuments { snapshot, error in
            // Array to track questions
            var questions = [Question]()
            
            // Loop through documents and build array of questions
            for doc in snapshot!.documents {
                // New Question
                var q = Question()
                
                q.id = doc["id"] as? String ?? ""
                q.answers = doc["answers"] as? [String] ?? [String]()
                q.content = doc["content"] as? String ?? ""
                q.correctIndex = doc["correctIndex"] as? Int ?? 0
                
                questions.append(q)
            }
            
            for (i, m) in self.modules.enumerated() {
                if m.id == module.id {
                    self.modules[i].test.questions = questions
                    
                    completion()
                }
            }
        }
        
    }
    
    func getDatabaseModules() {
        
        // Specify path
        let collection = db.collection("modules")
        
        // Get documents
        collection.getDocuments { snapshot, error in
            if error == nil && snapshot != nil {
                
                // Create an array for the modules
                var modules = [Module]()
                
                // Loop through documents returned
                for doc in snapshot!.documents {
        
                    // Create a new module instance
                    var m = Module()
                    
                    // Parse out the values from the document into the module instance
                    m.id = doc["id"] as? String ?? UUID().uuidString
                    m.category = doc["category"] as? String ?? ""
                    
                    // Parse the lesson content
                    let contentMap = doc["content"] as! [String:Any]
                    
                    m.content.id = contentMap["id"] as? String ?? ""
                    m.content.description = contentMap["description"] as? String ?? ""
                    m.content.image = contentMap["image"] as? String ?? ""
                    m.content.time = contentMap["time"] as? String ?? ""
                    
                    // Parse the test content
                    let testMap = doc["test"] as! [String:Any]
                    
                    m.test.id = testMap["id"] as? String ?? ""
                    m.test.description = testMap["description"] as? String ?? ""
                    m.test.image = testMap["image"] as? String ?? ""
                    m.test.time = testMap["time"] as? String ?? ""
                    
                    // Add it to our array
                    modules.append(m)
                }
                // Assign our module to the published properties
                DispatchQueue.main.async {
                    self.modules = modules
                }
            }
        }
        
    }
    
    func getLocalStyles() {
        // Get url to JSON file
//        let jsonURL = Bundle.main.url(forResource: "data", withExtension: "json")
//        do {
//            // Read the file into a data object
//            let jsonData = try Data(contentsOf: jsonURL!)
//            let jsonDecoder = JSONDecoder()
//
//            // Try to decode the JSON into an array of modules
//            let moduleArray = try jsonDecoder.decode([Module].self, from: jsonData)
//
//            // Assign parsed modules to modules property
//            self.modules = moduleArray
//        }
//        catch {
//            print(error)
//        }
        
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
    
    func getRemoteData() {
        
        // String path
        let urlString = "https://mullen44.github.io/learningapp-data/data2.json"
        
        // Create a url object
        let url = URL(string: urlString)
        
        guard url != nil else {
            // Couldn't create url
            return
        }
        
        // Create a url request object
        let request = URLRequest(url: url!)
        
        // Get the session and kick off the task
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            // Check if there's an error
            guard error == nil else {
                // Otherwise there was an error
                return
            }
            
            // Handle the response
            // JSON data is in the data property need to decode it locally now
            // Create JSON Decoder
            do {
                let decoder = JSONDecoder()
            
                // Decode
                let modules = try decoder.decode([Module].self, from: data!)
                
                DispatchQueue.main.async { // Assigns it to the main thread to take care of it
                    // Append parsed modules into modules property
                    self.modules += modules
                }
            }
            catch {
                // Couldn't parse JSON
            }
        }
        
        // Kick off teh data task
        dataTask.resume()
        
    }
    
    // MARK: Module Navigation Methods
    
    func beginModule(_ moduleid:String) {
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
    
    func beginTest(_ moduleId: String) {
        
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

