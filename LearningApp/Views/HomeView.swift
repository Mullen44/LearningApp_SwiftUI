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
                                NavigationLink {
                                    ContentView()
                                        .onAppear(perform: {
                                            model.beginModule(module.id)
                                        })
                                } label: {
                                    HomeViewRow(image: module.content.image, title: "Learn \(module.category)", description: module.content.description, count: "\(module.content.lessons.count) Lessons", time: module.content.time)
                                }
                                
                                // Test Card
                                HomeViewRow(image: module.test.image, title: "\(module.category) Test", description: module.test.description, count: "\(module.test.questions.count) Questions", time: module.test.time)
                            }// End VStack
                            
                            
                        }// End For Each
                    }// End Lazy VStack
                    .accentColor(.black)
                    .padding()
                }// End ScrollView
            }.navigationTitle("Get Started")
        }
    }
}
    
    struct HomeView_Previews: PreviewProvider {
        static var previews: some View {
            HomeView().environmentObject(ContentModel())
        }
    }
