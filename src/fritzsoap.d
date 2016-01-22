import std.stdio;
import std.socket;
import std.conv;
import std.exception: enforce;

enum string Host = "shark";
enum string Port = "49000";
enum string BaseControlUrl = "/igdupnp/control/";
enum string ServiceControlName = "WANCommonIFC1";
enum string UpnpService = "WANCommonInterfaceConfig:1";
enum string UpnpAction = "GetCommonLinkProperties";

// SOAP Payload is XML-based and has a huge overhead
enum string xmlData =
  "<?xml version=\"1.0\" encoding=\"utf-8\"?>
<s:Envelope s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\">
<s:Body>
<u:" ~ UpnpAction ~" xmlns:u=\"urn:schemas-upnp-org:service:" ~ UpnpService ~ "\" />
</s:Body>
</s:Envelope>";

// POST is quite large, as well
enum string postRequest =
  "POST "~ BaseControlUrl ~ ServiceControlName ~ " HTTP/1.1\r\n"
  ~ "Host: " ~ Host ~":"~ Port ~ "\r\n"
  ~ "SoapAction: \"urn:schemas-upnp-org:service:" ~ UpnpService ~ "#" ~ UpnpAction ~ "\"\r\n"
  ~ "Content-Type: text/xml; charset=\"utf-8\"\r\n"
  ~ "Content-Length: " ~ to!string(xmlData.length) ~ "\r\n"
  ~ "\r\n";


void main() {

  // In case of hostname: get addresses, but IPv4 only
  auto addresses = getAddress(Host, 49000);
  // addresses is of type Address[]
  // Continue if there was a match
  enforce(addresses.length != 0, "Could not resolve Hostname");
  Socket sock;
  scope(exit) sock.close();

  foreach (address; addresses) {
	try {
	  sock = new TcpSocket(address); // Use first entry for now, later let user select;
	  writeln("Using ", address );
	  break;
	}
	catch(std.socket.SocketOSException) {
	  continue;
	}
	assert(false, "No replying Host found");
  }
  sock.send(postRequest ~ xmlData);
  char[2048] buf;

  auto datLength = sock.receive(buf[]);

  string answer;
  if (datLength == Socket.ERROR) {
	writeln("Socket Error.");
  } else if (datLength != 0) {
	answer = buf[0..datLength].idup();
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
  writefln("%s", answer);
}
