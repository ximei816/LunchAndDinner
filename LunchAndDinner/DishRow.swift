//
//  DishRow.swift
//  LunchAndDinner
//
//  Created by 満尾希美 on 31/12/20.
//

import SwiftUI
import CoreData

struct DishRow: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var item: Dish

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
                deleteItems(item: item)
            }, label: {
                Image(systemName: "trash").foregroundColor(.gray)
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
    
    private func deleteItems(item: NSManagedObject) {
        viewContext.delete(item)
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
