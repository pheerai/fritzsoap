import std.stdio;
import std.socket;
import std.conv;

enum string fritzHost = "10.166.0.2";
enum string fritzPort = "49000";
enum string fritzBaseUrl = "/igdupnp/control/";
enum string fritzSCPDshort = "WANIPConn1";
enum string fritzSCPDlong = "WANIPConnection:1";
enum string upnpAction = "GetExternalIPAddress";


enum string fritzUrl = "http://" ~ fritzHost ~ ":" ~ fritzPort ~ fritzBaseUrl ~ fritzSCPDshort;
enum string xmlData =
  "<?xml version=\"1.0\" encoding=\"utf-8\"?>
<s:Envelope s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\">
<s:Body>
<u:" ~ upnpAction ~" xmlns:u=\"urn:schemas-upnp-org:service:" ~ fritzSCPDlong ~ "\" />
</s:Body>
</s:Envelope>";

enum string postRequest =
  "POST "~ fritzBaseUrl ~ fritzSCPDshort ~ " HTTP/1.1\r\n"
  ~ "Host: " ~ fritzHost ~":"~ fritzPort ~ "\r\n"
  ~ "SoapAction: \"urn:schemas-upnp-org:service:" ~fritzSCPDlong ~ "#" ~ upnpAction ~ "\"\r\n"
  ~ "Content-Type: text/xml; charset=\"utf-8\"\r\n"
  ~ "Content-Length: " ~ to!string(xmlData.length) ~ "\r\n"
  ~ "\r\n";


void main() {
  auto addresses = getAddress(fritzHost, 49000);
  assert(addresses.length != 0);
  Socket sock = new TcpSocket(addresses[0]);
  scope(exit) sock.close();
  
  sock.send(postRequest ~ xmlData);
  char[2048] buf;
  auto datLength = sock.receive(buf[]);
  
  if (datLength == Socket.ERROR) {
	writeln("Socket Error.");
  } else if (datLength != 0) {
	writefln("%s", buf[0..datLength]);
  } else {
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
  
  sock.close();
	
}
