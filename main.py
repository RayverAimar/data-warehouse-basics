import psycopg2
from config import config

def connect():
    connection = None
    try:
        params = config()
        connection = psycopg2.connect(**params)
        cursor = connection.cursor()
        print("PostgreSQL database version: ")
        cursor.execute('SELECT version()')
        db_version = cursor.fetchone()
        cursor.close()
        print(db_version)
    except(Exception, psycopg2.DatabaseError) as error:
        print(error)
    
    finally:
        if connection is not None:
            connection.close()
            print("Database connection terminated")
            
if __name__ == "__main__":
    connect()
    

