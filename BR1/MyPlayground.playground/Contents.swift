import Foundation
import CreateML

let data = try MLDataTable(contentsOf: URL(fileURLWithPath: "/Users/tommy/Desktop/better-rest.json"))
 // take data from file


let (trainingData, testingData) = data.randomSplit(by: 0.8)
// 80% of traing data
// sometimes 90% data for testing, the rest to evaluate and make sure


let regressor = try MLRegressor(trainingData: trainingData, targetColumn: "actualSleep")
// tell swift to find a model for actualSleep

let evaluationMetrics = regressor.evaluation(on: trainingData)
// lets evaluate the training data
// lets see how good it is => we are gonna test it with data we've never seen before

print(evaluationMetrics.rootMeanSquaredError)
// rootmeansquareerror : evaluation the deviation
print(evaluationMetrics.maximumError) // biggest difference it found

// now create the file for iOs to use

let metadata = MLModelMetadata(author: "Truong Tommy", shortDescription: "A model trained to predict optium sleep time for coffee drinkers", version: "1.0")

try regressor.write(
    to:URL(fileURLWithPath: "/Users/tommy/Desktop/SleepCalculator.mlmodel"), metadata: metadata)

                    
