import std.stdio;
import std.socket;
import std.conv;
import std.exception: enforce;
import soapsocket;
//extern soapsocket;


enum string Host = "shark";
enum string Port = "49000";
enum string BaseControlUrl = "/igdupnp/control/";
enum string ServiceControlName = "WANCommonIFC1";
enum string UpnpService = "WANCommonInterfaceConfig:1";
enum string UpnpAction = "GetCommonLinkProperties";

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

  auto soap = new soapsocket.SoapAction(sock, Host,
										Port, BaseControlUrl,
										ServiceControlName, UpnpService,
										UpnpAction);
  soap.request();
  auto reply = soap.receive();
  writefln("%s", reply);
  writeln();
  
  auto soapIp = new soapsocket.SoapAction(sock, Host,
										  Port, BaseControlUrl,
										  "WANIPConn1", "WANIPConnection:1",
										  "GetExternalIPAddress");
  soapIp.request();
  reply = soapIp.receive();
	

  sock.close();
  writefln("%s", reply);
}
