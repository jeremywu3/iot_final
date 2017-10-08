# Echo server program
import socket
#from pymongo import MongoClient
from datetime import datetime

HOST = '192.168.43.14'                 # Symbolic name meaning all available interfaces
PORT = 8080              # Arbitrary non-privileged port
while 1:
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.bind((HOST, PORT))
        s.listen(1)
        conn, addr = s.accept()
        with conn:
            print('Connected by', addr)
            while True:
                data = conn.recv(1024)
                if not data: break
                data = data.decode()
                print(data)
                #client = MongoClient("mongodb://localhost:27017/")
                #db = client['iot']
                #collect = db['temperature']
                #tmp_post = { "datetime" : datetime.utcnow(),"temperature" : data}
                #post_id = collect.insert_one(tmp_post).inserted_id
                #client.close()
                if float(data)>29.0:
                    conn.sendall(b'0')
                else:
                    conn.sendall(b'1')