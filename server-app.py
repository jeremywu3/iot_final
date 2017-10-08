import socket

HOST = '192.168.31.213'
PORT = 5000
global res_x, res_y

#socket.AF_INET : create socket between servers
#socket.SOCK_STREAM : use TCP
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((HOST, PORT))
s.listen(5) #at most 5 connection

print ('app is waiting for connection...')

while True:
	conn, addr = s.accept()
	print ('Connected by ', addr)

	while True:
		try:
			data = conn.recv(1024)
			data = data.decode()
			print(data)
			#message = input()
			#conn.send(message.encode())
		except:
			conn.close()
			print("connetion close!")
			break
