//
//  AddDishView.swift
//  LunchAndDinner
//
//  Created by 満尾希美 on 16/12/20.
//

import SwiftUI

struct AddDishView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Dish.name, ascending: true)],
        animation: .default)
    var items: FetchedResults<Dish>
    
    @State private var name = ""
    @State private var type_cd = 0
    @State private var showingAlert = false
    @State private var toContinue = false
    
    var catArray = ["main", "side", "soup", "carb", "other", "eatout"]
    
    var body: some View {
        NavigationView{
            
            Form {
                Section(header: Text("Update Setting")) {
                    Toggle(isOn: $toContinue) {
                        Text("Continue adding")
                    }
                }
                Section(header: Text("Dish")) {
                    
                    Picker(selection: $type_cd, label: Text("Type")) {
                        ForEach(0 ..< catArray.count) {
                            Text(self.catArray[$0])
                        }
                    }
                    TextField("Dish Name", text: $name)
                }
                Button("Add", action: {
                    addItem()
                    
                    if !toContinue {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }).alert(isPresented: $showingAlert) {
                    Alert(title: Text("Dish Name Error"), message: Text("Already has \(name). Please change dish name."), dismissButton: .default(Text("OK")){
                            showingAlert = false
                    })
                }
            }
        }
    }
    
    private func addItem() {
        withAnimation {
            
            if items.filter({$0.name == name}).count > 0 {
                showingAlert = true
            }else{
                let newItem = Dish(context: viewContext)
                newItem.id = UUID()
                newItem.type = catArray[type_cd]
                newItem.name = name

                do {
                    try viewContext.save()
                } catch {
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
                
                name = ""
                type_cd = 0
            }
        }
    }
}
