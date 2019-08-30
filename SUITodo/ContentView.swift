//
//  ContentView.swift
//  SUITodo
//
//  Created by Tommie Carter on 8/30/19.
//  Copyright © 2019 MING Technology LLC. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: ToDoItem.getAllToDoItems()) var todoItems:FetchedResults<ToDoItem>
    @State private var newTodoItem = ""
    
    var body: some View {
        NavigationView{
            List{
                Section(header: Text("What's Next")){
                    HStack{
                        TextField("New Item",text:$newTodoItem)
                        Button(action: {
                            let todoItem = ToDoItem(context: self.managedObjectContext)
                            todoItem.createdAt = Date()
                            todoItem.title = self.newTodoItem
                            
                            do{
                                try self.managedObjectContext.save()
                            }catch{
                                print(error)
                            }
                            
                            self.newTodoItem = ""
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                                .imageScale(.large)
                        }
                    }
                }.font(.headline)
                Section(header:Text("To Do's")){
                    ForEach(self.todoItems){ todoItem in
                        ToDoItemView(title:todoItem.title!,createdAt:"\(String(describing: todoItem.createdAt))")
                    }.onDelete { indexSet in
                        let deleteItem = self.todoItems[indexSet.first!]
                        self.managedObjectContext.delete(deleteItem)
                        do{
                            try self.managedObjectContext.save()
                        }catch{
                            print(error)
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
