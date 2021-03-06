//
//  ContentView.swift
//  LearningApp
//
//  Created by Andrew Mullen on 2021-12-06.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var model:ContentModel
    
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("What do you want to do today?")
                    .padding(.leading, 20)
                ScrollView {
                    LazyVStack {
                        ForEach(model.modules) {module in
                            VStack(spacing: 20) {
                                // Learning Card
                                NavigationLink(
                                    destination:
                                        ContentView()
                                            .onAppear(perform: {
                                                model.getLessons(module: module){
                                                    model.beginModule(module.id)
                                                }
                                            }),
                                    tag: module.id.hash,
                                    selection: $model.currentContentSelected,
                                    label: {
                                        HomeViewRow(image: module.content.image, title: "Learn \(module.category)", description: module.content.description, count: "\(module.content.lessons.count) Lessons", time: module.content.time)
                                    })
                                
                                
                                NavigationLink(
                                    destination: TestView()
                                        .onAppear(perform: {
                                            model.getQuestions(module: module) {
                                                model.beginTest(module.id)
                                            }
                                        }),
                                    tag: module.id.hash,
                                    selection: $model.currentTestSelected,
                                    label: {
                                                    // Test Card
                                        HomeViewRow(image: module.test.image, title: "\(module.category) Test", description: module.test.description, count: "\(module.test.questions.count) Questions", time: module.test.time)
                                    
                                })// End Navigation Link label
                                               
                            }// End VStack
                            .padding(.bottom, 10)
                            
                            
                        }// End For Each
                    }// End Lazy VStack
                    .accentColor(.black)
                    .padding()
                }// End ScrollView
            }.navigationTitle("Get Started")
        }
        .navigationViewStyle(.stack)
    }
}
    
    struct HomeView_Previews: PreviewProvider {
        static var previews: some View {
            HomeView().environmentObject(ContentModel())
        }
    }
