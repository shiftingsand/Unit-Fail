//
//  ContentView.swift
//  compile fail unit
//
//  Created by Chris Wu on 7/23/24.
//

import SwiftUI
import WeatherKit

struct Outer : Identifiable {
    let id = UUID()
    let name : String
    let data : [(month: Date, sales: Measurement<UnitTemperature>)]
}

// the compiler isn't able to catch that UnitLength is used where a UnitTemperature should be.
struct ContentView: View {
    let tempFormatter = MeasurementFormatter()
    
    var allData : [Outer] {
        var rc : [Outer] = []
        
        let next = Calendar.current.date(byAdding: .day, value: 1, to: .now)
        rc.append(Outer(name: "first", data: [(month: Date.now, sales: .init(value: 90, unit: .fahrenheit))]))
        rc.append(Outer(name: "second", data: [(month: next!, sales: .init(value: 80, unit: .fahrenheit))]))
        
        return rc
    }
    
    var tempUnitToUse : UnitTemperature {
        return .fahrenheit
    }
    
    var lengthUnitToUse : UnitLength {
        return .inches
    }
    
    var body: some View {
        VStack {
            ForEach(allData) { series in
                ForEach(series.data, id: \.month) { element in
                    Text("hello \(element.month) \(element.sales.converted(to: tempUnitToUse).value)")
                        .accessibilityLabel("\(element.month.formatted(.dateTime.month(.wide)))")
                        // incorrect line
                        .accessibilityValue(Text("\(tempFormatter.string(from: element.sales.converted(to: lengthUnitToUse)))"))
                        // correct line
                        //.accessibilityValue(Text("\(tempFormatter.string(from: element.sales.converted(to: tempUnitToUse)))"))
                }
            }
        }
        .padding()
    }
}
