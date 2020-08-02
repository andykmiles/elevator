from dbs.connect import MongoDBConnection


def print_mdb_collection(collection_name):
    for doc in collection_name.find():
        print(doc)


def main():
    mongo = MongoDBConnection()

    with mongo:
        # mongodb database; it all starts here
        db = mongo.connection.media

        # collection in database
        cd = db["cd"]

        cd_ip = {"artist": "The Who", "Title": "By Numbers"}
        result = cd.insert_one(cd_ip)

        cd_ip = [
            {"artist": "Deep Purple", "Title": "Made In Japan", "name": "Andy"},
            {"artist": "Led Zeppelin", "Title": "House of the Holy", "name": "Andy"},
            {"artist": "Pink Floyd", "Title": "DSOM", "name": "Andy"},
            {"artist": "Albert Hammond", "Title": "Free Electric Band", "name": "Sam"},
            {"artist": "Nilsson", "Title": "Without You", "name": "Sam"},
        ]

        result = cd.insert_many(cd_ip)

        print_mdb_collection(cd)

        # another collection
        collector = db["collector"]

        collector_ip = [
            {"name": "Andy", "preference": "Rock"},
            {"name": "Sam", "preference": "Pop"},
        ]
        result = collector.insert_many(collector_ip)

        print_mdb_collection(collector)

        # related data
        for name in collector.find():
            print(f'List for {name["name"]}')
            query = {"name": name["name"]}
            for a_cd in cd.find(query):
                print(f'{name["name"]} has collected {a_cd}')

        # start afresh next time?
        yorn = input("Drop data?")
        if yorn.upper() == "Y":
            cd.drop()
            collector.drop()


if __name__ == "__main__":
    main()
