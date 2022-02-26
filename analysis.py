import pandas as pd
import mysql.connector

mydb = mysql.connector.connect(
    host="localhost",
    user="marcrng",
    password="Kaisersql0413$",
    database="parcel_data"
)

curs = mydb.cursor()

curs.execute("select * from site_types")

result = curs.fetchall()

print(result)
