//
//  ContentView.swift
//  SUITodo
//
//  Created by Tommie Carter on 8/30/19.
//  Copyright © 2019 MING Technology LLC. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var newTodoItem:String = ""
    
    var body: some View {
        ToDoListView(newTodoItem: $newTodoItem)
    }
}

struct ToDoListView:View {
    @Binding  var newTodoItem:String
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: ToDoItem.getAllToDoItems()) var todoItems:FetchedResults<ToDoItem>
    
    func dateCreated(dt:Date?) -> String {
        guard dt != nil else {return ""}
        let df:DateFormatter = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        df.dateStyle = .medium
        return df.string(from: dt!)
    }
    
    func titled(named:String?)->String {
        guard named != nil, !named!.trimmingCharacters(in: .whitespaces).isEmpty else {return ""}
        return named!
    }
    var body: some View {
        NavigationView{
            List{
                Section(header: Text("What's Next")){
                    HStack {
                        TextField("New Item",text:$newTodoItem)
                        Button(action: {
                            if !self.$newTodoItem.wrappedValue.trimmingCharacters(in: .whitespaces).isEmpty {
                                
                            let todoItem = ToDoItem(context: self.managedObjectContext)
                            todoItem.createdAt = Date()
                            todoItem.title = self.newTodoItem
                          
                            do {
                                try self.managedObjectContext.save()
                            } catch {
                                print(error)
                                }
                                self.newTodoItem = ""
                            }
                        }) {
                            //#imageLiteral(resourceName: "np_plus-circle_1144108_000000")
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                                .imageScale(.large)
                        }
                    }
                }.font(.headline)
                Section(header:Text("To Do's")){
                    ForEach(self.todoItems){ todoItem in
                        ToDoItemView(title: self.titled(named:todoItem.title), createdAt: self.dateCreated(dt:todoItem.createdAt))
                        
                    }.onDelete { indexSet in
                        if let currentIndex = indexSet.first{
                            let deleteItem = self.todoItems[currentIndex]
                            do{
                                self.managedObjectContext.delete(deleteItem)
                                try self.managedObjectContext.save()
                            }catch{
                                print(error)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(Text("My Items"))
            .navigationBarItems(trailing: EditButton())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
