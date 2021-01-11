//
//  ContentView.swift
//  LunchAndDinner
//
//  Created by 満尾希美 on 14/12/20.
//

import SwiftUI
import CoreData

extension Color {
    static let eggplant = Color("eggplant")
    static let grape = Color("grape")
    static let myblack = Color("myblack")
    static let sand = Color("sand")
    static let shell = Color("shell")
    static let main = Color("main")
    static let side = Color("side")
    static let soup = Color("soup")
    static let other = Color("other")
    static let carb = Color("carb")
    static let eatout = Color("eatout")
    
}

struct DishListView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Dish.name, ascending: true)],
        animation: .default)
    var items: FetchedResults<Dish>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Meal.dt, ascending: true)],
        animation: .default)
    var meals: FetchedResults<Meal>

    @State private var showingAlert = false
    @State private var toAdd = false
    @State var isEdit: Bool
    @State var selections: [String]
    
    var fromMealList: Bool
    var fromMealDt: Date
    var fromMealLd: String
    
    var catArray = ["main", "side", "soup", "carb", "other", "eatout"]
    //1: main, 2: side, 3: soup, 4: carb, 5:other, 6:eatout
    
    var body: some View {
        Color.shell
            .ignoresSafeArea()
            .overlay(
                    VStack{
                        HStack{
                            Button(isEdit ? "Cancel" : "", action: {
                                self.presentationMode.wrappedValue.dismiss()
                            })
                            Spacer()
                            Button(action: {toAdd.toggle()}) {
                                Label("New Dish", systemImage: "plus")
                            }
                        }.padding()
                        
                        List {
                            ForEach(catArray, id: \.self){ cat in
                                Text(cat).fontWeight(.bold).foregroundColor(.white)
                                    
                                ForEach(items.filter{$0.type == cat}, id: \.self) {item in
                                    
                                    if isEdit {
                                        DishRowSelect(item: item, isChecked: selections.contains(item.name!) ? true : false, selections: self.$selections, fromMealDt: fromMealDt, fromMealLd: fromMealLd)
                                    }else{
                                        DishRow(item: item)
                                    }
                                    
                                }.listRowBackground(Color.clear)
                            }.listRowBackground(Color.grape)
                        }
                        
                        if fromMealList {
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                Label("Back to Meal List", systemImage: "arrowshape.turn.up.left")
                            }
                        }else{
                            Button(action: {
                                addMeal()
                            }) {
                                Label("Save Dishes to Meal", systemImage: "square.and.arrow.down")
                                    .alert(isPresented: $showingAlert) {
                                        Alert(title: Text("Show Alert"), message: Text("\(selections.count) items updated"), dismissButton: .default(Text("OK")){
                                            
                                            //TODO - Save Meal
                                            self.presentationMode.wrappedValue.dismiss()
                                            
                                        })
                                    }
                            }.disabled(selections.count <= 0)
                        }
                    }.sheet(isPresented: self.$toAdd){AddDishView().environment(\.managedObjectContext, viewContext)}
            )
    }
    
    private func addMeal() {
        withAnimation {
            var dishesStr = ""
            
            for dish in selections {
                dishesStr += ",\(dish)"
                
                if items.filter({$0.name == dish}).count > 0 {
                    items.filter{$0.name == dish}[0].last = Date()
                }
            }
            
            if meals.filter({$0.ld == fromMealLd && getLongDateString(dt: $0.dt!) == getLongDateString(dt: fromMealDt)}).count > 0
            {
                meals.filter({$0.ld == fromMealLd && getLongDateString(dt: $0.dt!) == getLongDateString(dt: fromMealDt)})[0].dishes = String(dishesStr.dropFirst(1))
            }else{
                let newItem = Meal(context: viewContext)
                newItem.dt = fromMealDt
                newItem.ld = String(fromMealLd)
                newItem.dishes = String(dishesStr.dropFirst(1))
            }
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
            self.showingAlert = true
        }
    }
    
    func getLongDateString(dt:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/M/d"
        let dateString = dateFormatter.string(from: dt)
        return dateString
    }
}
