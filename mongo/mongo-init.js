db = db.getSiblingDB('admin');

db.createUser({
    user: "$MONGO_INITDB_ROOT_USERNAME",
    pwd: "$MONGO_INITDB_ROOT_PASSWORD",
    roles: [
        {
            role: "root",
            db: "admin"
        },
    ]
})

db = db.getSiblingDB('$MONGO_INITDB_DATABASE');

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
