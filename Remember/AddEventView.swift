//
//  AddEventView.swift
//  Remember
//
//  Created by Clayton Vanfleet on 3/2/23.
//

import SwiftUI
import CoreData

struct AddEventView: View {
    @State var enteredEvent: String = ""
    @State var enteredDate: Date = Date()
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    var body: some View {
        
        Form{
            Text("Event Name")
                .font(.title)
            TextField("Enter your Event", text: $enteredEvent)
            
            Text("Event Date")
                .font(.title)
            DatePicker(
                "Choose your event date",
                selection: $enteredDate,
                in: Date()...,
                displayedComponents: [.date, .hourAndMinute]
            )
            .datePickerStyle(.graphical)
            Button("Add Event", action: {
                let successful = addEvent(event: enteredEvent, date: enteredDate)
                if(successful){
                    presentationMode.wrappedValue.dismiss()
                    
                }
            })
        }
        
    }
    private func addEvent(event: String, date: Date) -> Bool{
        if(event != "" && date != Date()){
            let newItem = Item(context: viewContext)
            newItem.eventName = event
            newItem.eventDate = date
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")

            }
            return true
        } else {
            print("Invalid data")
            return false
        }
    }
}

struct AddEventView_Previews: PreviewProvider {
    static var previews: some View {
        AddEventView()
    }
}



