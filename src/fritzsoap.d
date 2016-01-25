import std.stdio;
import soapsocket;

enum string THost = "10.166.0.2";
enum string TPort = "49000";
enum Actions[] TAction = [Actions.GetDownstream, Actions.GetUpstream, Actions.GetConnStatus , Actions.GetExtIP]; 

void main() {
  // Usally: ask for Host, port by arguments
  // ToDo: Argument parsing

  auto soap = new soapsocket.SoapAction(THost, TPort, TAction);
  string[SoapActionData] replies = soap.getReplies();
  foreach(key, val; replies) {
	writefln("%-10s:%18s", key, val);
  }
}
