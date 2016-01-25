module soapsocket;

import std.conv;
import std.format;
import std.string;
import soapquery;
public import soaptypes;

class SoapAction {
 private:
  string host;
  string port;
  string url;
  Actions[] actions;
  string[SoapActionData] reply;
  
public:
  this(in string host, in string port,
	   in Actions[] actions) {
	// open connection
	this.host = host;
	this.port = port;
	this.url = host~":"~port;
	this.actions = actions.dup();
	foreach(action; actions) {
	  SoapActionData lAction;
	  final switch(action) {
		case Actions.GetExtIP:
		  lAction = SoapGetExtIP;
		  break;
		case Actions.GetUpstream:
		  lAction = SoapGetUpstream;
		  break;
		case Actions.GetDownstream:
		  lAction = SoapGetDownstream;
		  break;
		case Actions.GetConnStatus:
		  lAction = SoapGetConnStatus;
		  break;
		}
	  import std.stdio;
	  auto query = new SoapQuery(lAction, this.url);
	  this.reply[lAction] = to!string(query);
	}
  }

  string[SoapActionData] getReplies() {
	return reply;
  }
  
  override string toString() const {
	string result;
	result ~= format("%-(%s%|\n%)", reply.values);
	return result;
  }
}
