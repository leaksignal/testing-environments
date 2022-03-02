from http.server import BaseHTTPRequestHandler, HTTPServer

class WebServerHandler(BaseHTTPRequestHandler):

    def do_GET(self):
        if self.path.endswith("/hello"):
            self.send_response(200)
            self.send_header('Test', 'Normal Header')
            self.end_headers()
            message = b"<html><body>Hello!  <table><tr colspan=2><td>Example SSN1</td><td>123114567</td></tr><tr colspan=2><td>Example SSN2</td><td>123-11-4567</td></tr></table> </body></html>"
            self.wfile.write(message)
            print (message)
            return
        else:
            self.send_error(404, 'File Not Found: %s' % self.path)


def main():
    try:
        port = 3001
        server = HTTPServer(('', port), WebServerHandler)
        print ("Web Server running on port %s" % port)
        server.serve_forever()
    except KeyboardInterrupt:
        print (" ^C entered, stopping web server....")
        server.socket.close()

if __name__ == '__main__':
    main()
