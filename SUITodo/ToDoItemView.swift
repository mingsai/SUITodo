//
//  ToDoItemView.swift
//  SUITodo
//
//  Created by Tommie Carter on 8/30/19.
//  Copyright © 2019 MING Technology LLC. All rights reserved.
//

import SwiftUI

struct ToDoItemView: View {
    var title:String = ""
    var createdAt:String = ""
    
    var body: some View {
        HStack{
            VStack (alignment:.leading){
                Text(title)
                    .font(.headline)
                Text(createdAt)
                    .font(.caption)
                
            }
        }
    }
}

struct ToDoItemView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoItemView(title: "Headline", createdAt: "Today")
    }
}
