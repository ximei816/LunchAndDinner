//
//  MealView.swift
//  LunchAndDinner
//
//  Created by 満尾希美 on 2/1/21.
//

import SwiftUI
import CoreData

struct MealDishRow: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Dish.name, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Dish>
    
    @State var name: String
    
    var body: some View {
        HStack{
            Image(systemName: "circle.fill")
                .foregroundColor(Color(getDishType(dishName: name)))
                .font(.system(size: 10))
            Text(name).font(.caption).lineLimit(nil)
        }
    }
    
    func getDishType(dishName: String) -> String {
        let dishes = items.filter{$0.name == dishName}
        if dishes.count > 0 {
            return dishes[0].type ?? "other"
        }else{
            return "other"
        }
    }
}

struct MealView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Meal.dt, ascending: true)],
        animation: .default)
    var meals: FetchedResults<Meal>
    
    @State private var didSave =  NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)

    @State private var toDishList = false
    @State private var dishNames: [String] = []

    @State var mealdt: Date
    @State var mealLd: String
    
    var body: some View {

        HStack{
            List{
                ForEach(dishNames, id: \.self) {dish in
                    MealDishRow(name: dish).environment(\.managedObjectContext, viewContext)
                }.listRowBackground(Color.clear)
            }.environment(\.defaultMinListRowHeight, 15)
            
            Button(action: {toDishList.toggle()}) {
                Label("", systemImage: "pencil.circle")
                    .foregroundColor(.eggplant)
                    .frame(width: 15.0, height: 15.0)
            }.buttonStyle(PlainButtonStyle())
        }
        .fullScreenCover(isPresented: self.$toDishList){
            DishListView(isEdit: true, selections: dishNames, fromMealList: false, fromMealDt: mealdt, fromMealLd: mealLd).environment(\.managedObjectContext, viewContext)
        }
        .onAppear(perform: {
            setDishNames()
        })
        .onReceive(self.didSave) { _ in
            setDishNames()
        }
        
    }
    
    func setDishNames() {
        let meal = getMeal(ld: mealLd, dt: mealdt)
        if meal?.dishes?.count ?? 0 > 0 {
            let dishes = meal?.dishes
            dishNames = dishes?.components(separatedBy: ",") ?? []
        }else{
            dishNames = []
        }
    }
    
    func getMeal(ld:String,dt:Date) -> Meal? {
        let meal = meals.filter{
            $0.ld == ld && getLongDateString(dt: $0.dt!) == getLongDateString(dt: dt)
        }
        
        if meal.count > 0 {
            return meal[0]
        }else{
            return nil
        }
    }
    
    func getLongDateString(dt:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/M/d"
        let dateString = dateFormatter.string(from: dt)
        return dateString
    }
}
