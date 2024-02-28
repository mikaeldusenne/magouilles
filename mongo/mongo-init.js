db.createUser({
    user: "$MONGO_INITDB_ROOT_USERNAME",
    pwd: "$MONGO_INITDB_ROOT_PASSWORD",
    roles: [
        {
            role: "userAdminAnyDatabase",
            db: "admin",
        },
        {
            role: "dbAdminAnyDatabase",
            db: "admin",
        },
        {
            role: "readWriteAnyDatabase",
            db: "admin",
        },
    ]
})

db.createUser(
	  {
		    user: "$MONGO_INITDB_USER_USERNAME",
		    pwd: "$MONGO_INITDB_USER_PASSWORD",
		    roles: [
            {
			          role: "dbAdmin",
			          db: "$MONGO_INITDB_DATABASE"
		        },
            {
			          role: "readWrite",
			          db: "$MONGO_INITDB_DATABASE"
            }
        ]
	  }
)
