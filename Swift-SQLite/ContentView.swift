//
//  ContentView.swift
//  Swift-SQLite
//
//  Created by ztm on 2024/9/10.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var count:DataObserved<Int> = DataObserved(data: 0)
    @ObservedObject var list:DataObserved<[User]> = DataObserved(data: [])
    var db = TestHelper.INSTANCE
    
    init(){
        refresh()
    }
    
    var body: some View {
        GeometryReader{ geometry in
            VStack {
                HStack{
                    Button(action: {
                        add()
                    }, label: {
                        Text("Add")
                    }).frame(width: geometry.size.width * 0.33)
                    
                    Button(action: {
                        db.clearTable(UserSchema.NAME)
                    }, label: {
                        Text("clean")
                    }).frame(width: geometry.size.width * 0.33)
                    
                    Button(action: {
                        
                    }, label: {
                        Text("count: \(count.data)")
                    }).frame(width: geometry.size.width * 0.33)
                }
                List {
                    ForEach(list.data){ item in
                        Holder(item: item, list: list, db:db)
                    }
                }
                .refreshable {
                    refresh()
                }
            }
            .padding(0)
        }
    }
    
    func refresh(){
        count.data = db.getItemCount(UserSchema.NAME)
        list.data.removeAll()
        list.data.append(contentsOf: db.query(SQLQuery("SELECT * FROM \(UserSchema.NAME)", nil), UserFactory()))
    }
    
    func add(){
        let user = User()
        var values:[String:Any] = [:]
        values[UserSchema.Cols.UID] = user.uid
        values[UserSchema.Cols.NAME] = user.name
        values[UserSchema.Cols.SEX] = user.sex
        values[UserSchema.Cols.AGE] = user.age
        
        db.insert(SQLInsert(UserSchema.NAME, values))
        list.data.append(user)
    }
}

struct Holder: View {
    @State var name:String
    @State var age:String
    @State var sex:String
    
    @State var item:User
    var list:DataObserved<[User]>
    var db:TestHelper
    
    init(item: User, list:DataObserved<[User]>, db:TestHelper){
        self.item = item
        self.list = list
        self.db = db
        self.name = item.name
        self.age = "\(item.age)"
        self.sex = item.sex
    }
    
    var body: some View {
        HStack{
            TextField("name", text: $name)
                .frame(width:60)
            
            TextField("sex", text: $sex)
                .frame(width:60)
            
            TextField("age", text: $age)
                .keyboardType(.decimalPad)
                .frame(width:60)
            
            Spacer()
            
            Button(action: {
                update()
            }, label: {
                Text("save")
            })
            .buttonStyle(BorderlessButtonStyle())
            
            Button(action: {
                remove()
            }, label: {
                Text("del")
            })
            .buttonStyle(BorderlessButtonStyle())
        }
    }
    
    func update(){
        item.name = name
        item.sex = sex
        item.age = Int(age)!
        
        var values:[String:Any] = [:]
        values[UserSchema.Cols.NAME] = item.name
        values[UserSchema.Cols.SEX] = item.sex
        values[UserSchema.Cols.AGE] = item.age
        db.update(SQLUpdate(UserSchema.NAME, values, "\(UserSchema.Cols.UID)=?", [item.uid]))
    }
    
    func remove(){
        if db.delete(SQLDelete(UserSchema.NAME, "\(UserSchema.Cols.UID)=?", [item.uid])){
            let index = list.data.firstIndex(of: item)
            list.data.remove(at: index!)
        }
    }
}

#Preview {
    ContentView()
}
