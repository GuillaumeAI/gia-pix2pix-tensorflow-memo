import os
import argparse
from http.server import HTTPServer, SimpleHTTPRequestHandler


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--port", default=8000, type=int, help="port to listen on")
    parser.add_argument("--host", default="127.0.0.1", type=str, help="host of the server")

    args = parser.parse_args()

    os.chdir('static')
    server_address = (args.host, args.port)
    httpd = HTTPServer(server_address, SimpleHTTPRequestHandler)
    print('serving at \nhttp://'+ args.host + ':' + str(args.port) )
    httpd.serve_forever()


main()
