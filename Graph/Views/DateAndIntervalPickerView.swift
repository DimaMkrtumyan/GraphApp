//
//  IntervalPicker.swift
//  Graph
//
//  Created by Dmitriy Mkrtumyan on 22.02.24.
//

import SwiftUI

struct TimeIntervalModel {
    var day: Date
    var startTime: Date
    var endTime: Date
}

struct DateAndIntervalPickerView: View {
    
    @State private var timeInterval = TimeIntervalModel(day: Date(), startTime: Date(), endTime: Date())
    var doneOnTap: (TimeIntervalModel) -> Void
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            HStack {
                Text("Choose Day:")
                DatePicker("", selection: $timeInterval.day, displayedComponents: [.date])
                    .labelsHidden()
            }
            
            HStack {
                Text("Start Time:")
                DatePicker("", selection: $timeInterval.startTime, displayedComponents: [.hourAndMinute])
                    .labelsHidden()
            }
            
            HStack {
                Text("End Time:")
                DatePicker("", selection: $timeInterval.endTime, displayedComponents: [.hourAndMinute])
                    .labelsHidden()
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 50, trailing: 0))
            
            Button("Done") {
                doneOnTap(timeInterval)
            }
            .foregroundStyle(.white)
            .font(.system(size: 18, weight: .medium))
            .background(
                RoundedRectangle(cornerRadius: 10.0)
                    .foregroundStyle(.blue)
                    .frame(width: 100, height: 40)
            )
            
            Spacer()
        }
        .padding()
    }
}

struct DateAndIntervalPickerView_Previews: PreviewProvider {
    static var previews: some View {
        DateAndIntervalPickerView()
    }
}
