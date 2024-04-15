//: A Cocoa based Playground to present user interface

import CreateML
import Foundation

struct SomeError: LocalizedError {
    let message: String
}

guard let url = Bundle.main.url(forResource: "onlinefoods_mapped_copy", withExtension: "csv") else {
    throw SomeError(message: "Not found")
}

let dataTable = try MLDataTable(contentsOf: url)

print(dataTable.description)

let classifierColums = [
    "Age", "Gender", "Marital Status", "Occupation", "Monthly Income",
    "Educational Qualifications", "Family size", "Feedback", "Output"
]
let classifierTable = dataTable[classifierColums]

let (classifierEvaluationTable, classifierTrainingTable) = classifierTable.randomSplit(by: 0.20, seed: 5)

let classifier = try MLClassifier(trainingData: classifierTrainingTable, targetColumn: "Output")


/// Classifier training accuracy as a percentage
let trainingError = classifier.trainingMetrics.classificationError
let trainingAccuracy = (1.0 - trainingError) * 100


/// Classifier validation accuracy as a percentage
let validationError = classifier.validationMetrics.classificationError
let validationAccuracy = (1.0 - validationError) * 100


/// Evaluate the classifier
let classifierEvaluation = classifier.evaluation(on: classifierEvaluationTable)


/// Classifier evaluation accuracy as a percentage
let evaluationError = classifierEvaluation.classificationError
let evaluationAccuracy = (1.0 - evaluationError) * 100

let classifierMetadata = MLModelMetadata(author: "Sharan Thakur",
                                         shortDescription: "Predicts the likelyhood of online food ordering based on personal info.",
                                         version: "1.0")


/// Save the trained classifier model to the Desktop.
try classifier.write(to: URL.desktopDirectory.appendingPathComponent("OnlineFoodOrderingClassifier.mlmodel"),
                     metadata: classifierMetadata)

