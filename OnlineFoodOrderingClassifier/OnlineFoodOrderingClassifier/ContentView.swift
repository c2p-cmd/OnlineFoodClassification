//
//  ContentView.swift
//  OnlineFoodOrderingClassifier
//
//  Created by Sharan Thakur on 15/04/24.
//

import SwiftUI

struct ContentView: View {
    @State private var vm = ViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Inputs") {
                    DatePicker(
                        "Birthdate",
                        selection: $vm.date,
                        in: ...Date(),
                        displayedComponents: .date
                    )
                    .datePickerStyle(.automatic)
                    
                    Picker("Monthly Income", selection: $vm.monthlyIncome) {
                        ForEach(MonthlyIncome.allCases, id: \.rawValue) {
                            Text($0.description)
                                .tag($0)
                        }
                    }
                    
                    Stepper {
                        Text("Family Size **\(vm.familySize)**")
                    } onIncrement: {
                        guard vm.familySize < 12 else {
                            return
                        }
                        vm.familySize += 1
                    } onDecrement: {
                        guard vm.familySize > 1 else {
                            return
                        }
                        vm.familySize -= 1
                    }
                    
                    Picker("Education", selection: $vm.education) {
                        ForEach(EducationalQualification.allCases, id: \.rawValue) {
                            Text($0.description)
                                .tag($0)
                        }
                    }
                    
                    Picker("Marital Status", selection: $vm.maritalStatus) {
                        ForEach(MaritalStatus.allCases, id: \.rawValue) {
                            Text($0.description)
                                .tag($0)
                        }
                    }
                    
                    Picker("Gender", selection: $vm.gender) {
                        ForEach(Gender.allCases, id: \.rawValue) {
                            Text($0.description)
                                .tag($0)
                        }
                    }
                    
                    Picker("Feedback", selection: $vm.feedback) {
                        ForEach(Feedback.allCases, id: \.rawValue) {
                            Text($0.description)
                                .tag($0)
                        }
                    }
                    
                    Picker("Occupation", selection: $vm.occupation) {
                        ForEach(Occupation.allCases, id: \.rawValue) {
                            Text($0.description)
                                .tag($0)
                        }
                    }
                }
                
                Section("Prediction") {
                    if let predictionOutput = vm.prediction {
                        HStack {
                            Spacer()
                            Text("*Likely to order? **\(predictionOutput)***")
                            Spacer()
                        }
                    }
                    if let yesPerc = vm.predictionProbability["Yes"] {
                        HStack {
                            Text("***Yes***")
                            Spacer()
                            Text("\(yesPerc, format: .percent)")
                        }
                    }
                    if let noPerc = vm.predictionProbability["No"] {
                        HStack {
                            Text("***No***")
                            Spacer()
                            Text("\(noPerc, format: .percent)")
                        }
                    }
                }
                
                Section("Predict") {
                    Button("Predict", systemImage: "play.circle.fill") {
                        Task {
                            do {
                                try vm.predict()
                            } catch let error as AppError {
                                vm.error = error
                                vm.showError = true
                            }
                        }
                    }
                }
            }
            .fontDesign(.rounded)
            .alert(isPresented: $vm.showError, error: vm.error) { err in
                EmptyView()
            } message: { error in
                Text(error.description)
            }
            .onAppear {
                do {
                    try vm.loadModel()
                } catch let error as AppError {
                    vm.error = error
                    vm.showError = true
                } catch {
                    print(error)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Online Food Classification")
        }
    }
}

#Preview {
    ContentView()
}
