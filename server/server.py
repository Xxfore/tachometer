
#-*- coding:utf8 -*-
 
import threading
import hashlib
import socket
import base64
import time
import signal
import json
import random

global clients
clients = {}

class CanRawData:
    def __init__(self, speed, rpm):
        self.rfu1 = rfu1
        self.rfu2 = rfu2
        self.speed = speed
        self.rpm = rpm

def convert2json(canRawData):
    return {
        5,"99999",
        {'event':'WTF/messages.vehicle.average.speed',
         'data':{'value':canRawData.speed}}
    }

#通知客户端
def notify(message):
    for connection in clients.values():
        connection.send('%c%c%s' % (0x81, len(message), message))
 
#客户端处理线程
class Websocket_thread(threading.Thread):
    def __init__(self, connection, username):
        super(Websocket_thread, self).__init__()
        self.connection = connection
        self.username = username
    
    def run(self):
        print 'new websocket client joined!'
        data = self.connection.recv(1024)
        headers = self.parse_headers(data)
        token = self.generate_token(headers['Sec-WebSocket-Key'])
        self.connection.send('\
HTTP/1.1 101 WebSocket Protocol Hybi-10\r\n\
Upgrade: WebSocket\r\n\
Connection: Upgrade\r\n\
Sec-WebSocket-Accept: %s\r\n\r\n' % token)
        while not is_exit:
            try:
                #canRawData = CanRawData(120, 1200)
                #canRaw_json = json.dumps(canRawData, default=convert2json)
                #print(canRaw_json)
                speed = 120 + random.randint(1,50)
                rpm = 1200 + random.randint(1, 3000)
                notify('[5,"99999", {"event":"WTF/messages.vehicle.average.speed","data":{"value":"'+str(speed)+'"}}]')
                notify('[5,"99999", {"event":"WTF/messages.engine.speed","data":{"value":"'+ str(rpm)+'"}}]')
                time.sleep(0.01)
            except socket.error,e:
                print "error : ",e
                clients.pop(self.username)
                break
        
    def parse_headers(self, msg):
        headers = {}
        header, data = msg.split('\r\n\r\n', 1)
        for line in header.split('\r\n')[1:]:
            key, value = line.split(': ', 1)
            headers[key] = value
        headers['data'] = data
        return headers
 
    def generate_token(self, msg):
        key = msg + '258EAFA5-E914-47DA-95CA-C5AB0DC85B11'
        ser_key = hashlib.sha1(key).digest()
        return base64.b64encode(ser_key)
 
#服务端
class Websocket_server(threading.Thread):
    def __init__(self, port):
        super(Websocket_server, self).__init__()
        self.port = port
 
    def run(self):
        print(threading.current_thread().name)
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        sock.bind(('127.0.0.1', self.port))
        sock.listen(5)
        print 'websocket server started!'
        while True:
            connection, address = sock.accept()
            try:
                username = "ID" + str(address[1])
                thread = Websocket_thread(connection, username)
                thread.start()
                clients[username] = connection
            except socket.timeout:
                print 'websocket connection timeout!'
is_exit=0
def f(signum, frame):
    global is_exit
    is_exit=1

if __name__ == '__main__':
    signal.signal(signal.SIGINT,f)
    signal.signal(signal.SIGTERM,f)
    server = Websocket_server(3000)
    # need Intercept for exit
    # server.start()
    server.run()
