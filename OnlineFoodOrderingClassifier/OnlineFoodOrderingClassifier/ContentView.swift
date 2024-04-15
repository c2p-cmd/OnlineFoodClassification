//
//  ContentView.swift
//  OnlineFoodOrderingClassifier
//
//  Created by Sharan Thakur on 15/04/24.
//

import SwiftUI

struct ContentView: View {
    @State private var prediction = "0.0"
    
    let classifier = try! Classifier()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world! \(prediction)")
            Button("Predict", action: classifier.predict)
        }
        .padding()
    }
}

class Classifier {
    private let mlModel: OnlineFoodOrderingClassifier
    
    init() throws {
        self.mlModel = try OnlineFoodOrderingClassifier(configuration: .init())
    }
    
    func predict() {
        let prediction = try? self.mlModel.prediction(
            Age: 22,
            Gender: 1,
            Marital_Status: 2,
            Occupation: 4,
            Monthly_Income: 4,
            Educational_Qualifications: 2,
            Family_size: 4,
            Feedback: 0
        )
        
        print(prediction?.Output)
        print(prediction?.OutputProbability)
    }
}

#Preview {
    ContentView()
}
