//
//  DishRow.swift
//  LunchAndDinner
//
//  Created by 満尾希美 on 31/12/20.
//

import SwiftUI
import CoreData

struct DishRowSelect: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var item: Dish
    @State var isChecked: Bool
    @Binding var selections: [String]
    
    var fromMealDt: Date
    var fromMealLd: String

    var body: some View {
        
        HStack{
            
            Image(systemName: "circle.fill")
                .foregroundColor(Color(item.type ?? "other"))
                .font(.system(size: 20))
            
            VStack(alignment: .leading){
                Text(item.name ?? "")
                if item.last != nil {
                    Text("last time \(dateToString(dt: item.last!))").font(.caption)
                }else{
                    Text("no record").font(.caption)
                }
            }
            
            Spacer()
            
            Button(action: {
                self.isChecked.toggle()
                if self.isChecked{
                    self.selections.append(self.item.name ?? "?")
                }else{
                    self.selections.remove(at: (self.selections.firstIndex(of: self.item.name!)!))
                }
            }, label: {
                isChecked ? Image(systemName: "checkmark.circle.fill") : Image(systemName: "checkmark.circle")
            })
        }
    }
    
    func dateToString(dt: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .none
        f.locale = Locale(identifier: "ja_JP")
        let return_dt = dt
        return f.string(from: return_dt)
    }
}
