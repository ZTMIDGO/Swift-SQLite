# Swift-SQLite

支持ios 16或更高的版本，xcode 15 (Support iOS 16 or later, XCODE 15)

### 创建表 (Create a table)
``` swift
override func onCreate() throws {
    DBUtils.createTable(db!, SQLUtils.tableSQL(UserSchema.NAME, autoincrementKey, UserSchema.Cols.ARRAY))
}
```

### 升级数据库 (Upgrade the database)
``` swift
override func onUpgrade(oldVersion: Int, newVersion: Int) throws { }
```

### 查询表数据 (Query table data)
``` swift
db.query(SQLQuery("SELECT * FROM \(UserSchema.NAME)", nil), UserFactory())
```

### 插入数据 (Insert data)
``` swift
let user = User()
var values:[String:Any] = [:]
values[UserSchema.Cols.UID] = user.uid
values[UserSchema.Cols.NAME] = user.name
values[UserSchema.Cols.SEX] = user.sex
values[UserSchema.Cols.AGE] = user.age
db.insert(SQLInsert(UserSchema.NAME, values))
```

### 更新数据 (Update the data)
``` swift
var values:[String:Any] = [:]
values[UserSchema.Cols.NAME] = item.name
values[UserSchema.Cols.SEX] = item.sex
values[UserSchema.Cols.AGE] = item.age
db.update(SQLUpdate(UserSchema.NAME, values, "\(UserSchema.Cols.UID)=?", [item.uid]))
```

### 删除数据 (Deletion of data)
``` swift
db.delete(SQLDelete(UserSchema.NAME, "\(UserSchema.Cols.UID)=?", [item.uid]))
```

![sqlite](https://github.com/user-attachments/assets/0196a95a-873b-4f0d-aa99-3420b03d4e0a)
