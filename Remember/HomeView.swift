//
//  ContentView.swift
//  Remember
//
//  Created by Clayton Vanfleet on 2/22/23.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var nowDate: Date = Date()
    let calendar = Calendar(identifier: .gregorian)
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.eventDate, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    var timer: Timer{
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
            self.nowDate = Date()
        }
    }

    var body: some View {
        NavigationView {
            List {
                if(items.count != 0){
                    ForEach(items) { item in
                        if(items[0] == item){
                        label: do{
                            VStack (alignment: .center){
                                    Text(item.eventName!).font(.system(size: 25))
                                    Text(countDownString(from: item.eventDate!, until: nowDate)).onAppear(perform: {
                                        let _ = self.timer
                                })
                                    //Text(item.eventDate!, formatter: itemFormatter)
                                }
                            }
                        } else {
                            NavigationLink {
                                Text(item.eventName!).font(.system(size: 30))
                                Text(countDownString(from: item.eventDate!, until: nowDate)).onAppear(perform: {
                                    let _ = self.timer
                                }).font(.system(size: 25))
                            } label: {
                                Text(item.eventName!)
                            }
                        }
                    }
                    .onDelete(perform: deleteItems).frame(maxWidth: .infinity, alignment: .center)
                    
                } else {
                    Text("Add an event!").frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                label: do {
                    Text("Remember?!").font(.largeTitle)
                }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    NavigationLink(destination: AddEventView()) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.eventDate = Date()
            newItem.eventName = "Added Event"

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    func countDownString(from date: Date, until nowDate: Date) -> String {
        let components = calendar.dateComponents([.day, .hour, .minute, .second],from: nowDate,
                                                 to: date)
        return String(format: "%02dd:%02dh:%02dm:%02ds",
                      components.day ?? 00,
                      components.hour ?? 00,
                      components.minute ?? 00,
                      components.second ?? 00)
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
