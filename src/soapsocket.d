module soapsocket;

import std.conv;
import std.socket;
import std.format;

// Template for generation of the XML-Data
// %1 UpnpAction
// %2 UpnpService

enum string xmlData_T =
  "<?xml version=\"1.0\" encoding=\"utf-8\"?>
<s:Envelope s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\">
<s:Body>
<u:%1$s xmlns:u=\"urn:schemas-upnp-org:service:%2$s\" />
</s:Body>
</s:Envelope>";

// Template for generation of the postRequest. Requires the length of xmlData.
// %1 BaseControlUrl
// %2 ServiceControlName
// %3 Host
// %4 Port
// %5 UpnpService
// %6 UpnpAction
// %7 to!string (xmlData.length)

enum string postRequest_T =
  "POST %1$s%2$s HTTP/1.1\r\n" // 1,2
  ~ "Host: %3$s:%4$s\r\n" // 3,4
  ~ "SoapAction: \"urn:schemas-upnp-org:service:%5$s#%6$s\"\r\n" // 5,6
  ~ "Content-Type: text/xml; charset=\"utf-8\"\r\n"
  ~ "Content-Length: %7$s\r\n" // 7
  ~ "\r\n";

class SoapAction {
 private:
  Socket sock;
  string host;
  string port;
  string baseControlUrl;
  string serviceControlName;
  string upnpService;
  string upnpAction;
  string xmlData;
  string postRequest;
  char[2048] buf;

public:
  this(ref Socket sock, in string host,
	   in string port, in string bcu,
	   in string scn, in string service,
	   in string action) {
	this.sock = sock;
	this.host = host;
	this.port = port;
	this.baseControlUrl = bcu;
	this.serviceControlName = scn;
	this.upnpService = service;
	this.upnpAction = action;
	this.xmlData = xmlData_T.format(this.upnpAction,
									 this.upnpService);
	this.postRequest
	  = postRequest_T.format(this.baseControlUrl,
							 this.serviceControlName,
							 this.host,
							 this.port,
							 this.upnpService,
							 this.upnpAction,
							 to!string(this.xmlData.length));
  }
  
  void request() {
	sock.send(postRequest ~ xmlData);
  }
  
  string receive() {
	auto datLength = sock.receive(buf[]);
	string answer;
	if (datLength == Socket.ERROR) {
	  assert(false);
	} else if (datLength != 0) {
	  answer = buf[0..datLength].idup();
	} else {
	  import std.stdio;
	  try
		{
		  // if the connection closed due to an error, remoteAddress() could fail
		  writefln("Connection from %s closed.", sock.remoteAddress().toString());
		}
	  catch (SocketException)
		{
		  writeln("Connection closed.");
	  }
	}
	return answer;
  }
}
