//
//  ContnetView+ViewModel.swift
//  OnlineFoodOrderingClassifier
//
//  Created by Sharan Thakur on 20/04/24.
//

import Observation
import SwiftUI

extension ContentView {
    @Observable
    final class ViewModel {
        // Inputs
        var date: Date = Date()
        var monthlyIncome: MonthlyIncome = .noIncome
        var gender: Gender = .female
        var maritalStatus: MaritalStatus = .preferNotToSay
        var education: EducationalQualification = .uneducated
        var feedback: Feedback = .neutral
        var occupation: Occupation = .selfEmployeed
        var familySize: Int64 = 1
        
        // Output
        var predictionProbability: [String : Double] = [:]
        var prediction: String?
        
        var showError = false
        var error: AppError?
        
        private var mlModel: OnlineFoodOrderingClassifier?
        
        func loadModel() throws {
            do {
                self.mlModel = try OnlineFoodOrderingClassifier(configuration: .init())
            } catch {
                print(error)
                throw AppError.modelLoadError
            }
        }
        
        func predict() throws {
            guard let mlModel else {
                throw AppError.outputError
            }
            Task {
                do {
                    let age = NSCalendar.current.dateComponents([.year], from: date, to: .now).year!
                    let prediction = try mlModel.prediction(
                        Age: Int64(age),
                        Gender: Int64(gender.rawValue),
                        Marital_Status: Int64(maritalStatus.rawValue),
                        Occupation: Int64(occupation.rawValue),
                        Monthly_Income: Int64(monthlyIncome.rawValue),
                        Educational_Qualifications: Int64(education.rawValue),
                        Family_size: familySize,
                        Feedback: Int64(feedback.rawValue)
                    )
                    
                    self.predictionProbability = [:]
                    self.prediction = nil
                    
                    try await Task.sleep(nanoseconds: 5 * UInt64(pow(10.0, 8.0)))
                    
                    self.predictionProbability = prediction.OutputProbability
                    self.prediction = prediction.Output
                } catch {
                    print(error)
                    throw AppError.outputError
                }
            }
        }
    }
}

enum AppError: String, LocalizedError, CustomStringConvertible {
    case modelLoadError = "Couldn't load Classifier Model"
    case outputError = "Couldn't run prediction"
    
    var description: String {
        self.rawValue
    }
}

// MARK: - Data Models for App
enum MonthlyIncome: Int, CaseIterable {
    case noIncome = 1
    case below10k = 2
    case moreThan50k = 3
    case between10To25k = 4
    case between25kto50k = 5
    
    var description: String {
        switch self {
        case .noIncome:
            "No Income"
        case .below10k:
            "Below Rs.10,000"
        case .moreThan50k:
            "More than Rs.50,000"
        case .between10To25k:
            "Between Rs. 10,000 to 25,000"
        case .between25kto50k:
            "Between Rs. 25,000 to 50,000"
        }
    }
}

enum Gender: Int, CaseIterable {
    case male = 1
    case female = 2
    
    var description: String {
        switch self {
        case .male:
            "Male"
        case .female:
            "Female"
        }
    }
}

enum MaritalStatus: Int, CaseIterable {
    case single = 1
    case married = 2
    case preferNotToSay
    
    var description: String {
        switch self {
        case .single:
            "Single"
        case .married:
            "Married"
        case .preferNotToSay:
            "Prefer Not To Say"
        }
    }
}

enum EducationalQualification: Int, CaseIterable {
    case uneducated = 0
    case school = 1
    case graduate = 2
    case postGrad = 3
    case phd = 4
    
    var description: String {
        switch self {
        case .uneducated:
            "Uneducated"
        case .school:
            "School"
        case .graduate:
            "Graduate"
        case .postGrad:
            "Post Graduate"
        case .phd:
            "Ph.D"
        }
    }
}

enum Feedback: Int, CaseIterable {
    case neutral = -1
    case positive = 1
    case negative = 0
    
    var description: String {
        switch self {
        case .neutral:
            "Neutral"
        case .positive:
            "Positive"
        case .negative:
            "Negative"
        }
    }
}

enum Occupation: Int, CaseIterable {
    case student = 1
    case houseWife = 2
    case selfEmployeed = 3
    case employee = 4
    
    var description: String {
        switch self {
        case .student:
            "Student"
        case .houseWife:
            "House Wife"
        case .selfEmployeed:
            "Self Employeed"
        case .employee:
            "Employee"
        }
    }
}
