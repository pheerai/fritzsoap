import std.stdio;
import soapsocket;

enum string THost = "10.166.0.2";
enum string TPort = "49000";
enum Actions[] TAction = [Actions.GetDownstream, Actions.GetUpstream, Actions.GetConnStatus , Actions.GetExtIP]; 

void main() {
  // Usally: ask for Host, port by arguments
  // ToDo: Argument parsing

  auto soap = new soapsocket.SoapAction(THost, TPort, TAction);
  string[string] replies = soap.getReplies();
  writeln(replies);
}
