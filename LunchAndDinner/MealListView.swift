//
//  MealListView.swift
//  LunchAndDinner
//
//  Created by 満尾希美 on 4/1/21.
//

import SwiftUI

struct MealListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var mealWidth: CGFloat = UIScreen.main.bounds.size.width / 2.7
    @State private var mealHeight: CGFloat = UIScreen.main.bounds.size.height / 10.5
    @State private var toDishList = false
    @State private var startDt = Date()
    
    var body: some View {
        Color.shell
            .ignoresSafeArea()
            .overlay(
                VStack{
                    HStack(spacing: 40){
                        Button(action: {
                            startDt = Calendar.current.date(byAdding: .day, value: -7, to: startDt)!
                        }, label: {
                            Image(systemName: "arrowtriangle.left.fill").foregroundColor(.eggplant)
                        })
                        Text(getLongDateString(dt: startDt))
                        Button(action: {
                            startDt = Calendar.current.date(byAdding: .day, value: 7, to: startDt)!
                        }, label: {
                            Image(systemName: "arrowtriangle.right.fill").foregroundColor(.eggplant)
                        })
                    }.padding()
                    
                    List{
                        ForEach(0..<7) { row in
                            HStack{
                                VStack{
                                    //date - M/d
                                    Text(getDateString(dt: Calendar.current.date(byAdding: .day, value: row, to: startDt)!))
                                    
                                    //day of week - E
                                    Text(getDayOfWeekString(dt: Calendar.current.date(byAdding: .day, value: row, to: startDt)!))
                                }
                                
                                //lunch
                                MealView(mealdt: Calendar.current.date(byAdding: .day, value: row, to: startDt)!,
                                         mealLd: "l")
                                    .frame(width: mealWidth, height: mealHeight)
                                    
                                
                                //dinner
                                MealView(mealdt: Calendar.current.date(byAdding: .day, value: row, to: startDt)!,
                                         mealLd: "d")
                                    .frame(width: mealWidth, height: mealHeight)
                            }
                        }
                    }
                    
                    Button(action: {
                        toDishList.toggle()
                    }, label: {Text("Show Dish List")})
                    
                }.fullScreenCover(isPresented: self.$toDishList){
                    DishListView(isEdit: false, selections: [], fromMealList: true, fromMealDt: Date(), fromMealLd: "d")
                }
                .onAppear(perform:{
                    //Set startDt - Sunday of current week
                    let today = Date()
                    let addDays = (getDayOfWeekNumber(dt: today)-1) * (-1)
                    startDt = Calendar.current.date(byAdding: .day, value: addDays, to: today)!
                    
                })
            )
    }
    
    
    
    func getDayOfWeekNumber(dt:Date) -> Int {
        let weekDay = Calendar.current.component(.weekday, from: dt)
        return weekDay
    }
    
    func getLongDateString(dt:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/M/d"
        let dateString = dateFormatter.string(from: dt)
        return dateString
    }
    
    func getDateString(dt:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d"
        let dateString = dateFormatter.string(from: dt)
        return dateString
    }
    
    func getDayOfWeekString(dt:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        let weekDayString = dateFormatter.string(from: dt)
        return weekDayString
    }
}
