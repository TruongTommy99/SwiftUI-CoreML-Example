//
//  ContentView.swift
//  BR1
//
//  Created by Truong Tommy on 12/11/21.
//

import CoreML
import SwiftUI


struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var coffeeCup = 1
    @State private var sleepAmount = 8
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    static var defaultWakeTime :Date{
    var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    
    var body: some View {
        NavigationView {
            Form{
                VStack(alignment: .center, spacing: 0){
                Text("When do you want to wake up?")
                    .font(.headline)
                DatePicker("Enter your time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                }
                VStack(alignment: .leading, spacing: 0){
                Text("How much sleep do you want?")
                    .font( .headline)
                Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 1)
                }
                VStack(alignment: .leading, spacing: 0){
                Text("Daily coffee intake")
                    .font(.headline)
                Stepper(coffeeCup == 1 ?"1 cup" : "\(coffeeCup) cups of Coffee", value:$coffeeCup, in : 1...15)
                }
            }
            .navigationTitle("UniSleep")
            .toolbar{
                Button("Calculate",action : calculateSleepTime)
                    .alert(alertTitle, isPresented: $showingAlert){
                        Button("OK") {}
                    } message: {
                        Text(alertMessage)
                    }
                
            }
        }
    }
    func calculateSleepTime(){
        do{
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            let components = Calendar.current.dateComponents([.hour,.minute], from: wakeUp)
            let hour = (components.hour ?? 0 ) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour+minute), estimatedSleep: Double(sleepAmount), coffee: Double(coffeeCup))
            
            let sleepTime = wakeUp - prediction.actualSleep
            alertTitle = "Your ideal sleep time is ..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        }
        
        
        catch {
            alertTitle = "YIKES"
            alertMessage = "something went wrong"
        }
    showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
