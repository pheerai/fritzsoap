/**********
 * Authors: Oliver Rümpelein
 * Date: 2016-01-24
 * License: MIT
 */
module soapsocket;

import std.conv;
import std.format;
import std.string;
import soapquery;
public import soaptypes;

/**
 * Manages the data received from the single actions
 */
class SoapAction {
 private:
  string host;
  string port;
  string url;
  Actions[] actions;
  string[SoapActionData] reply;
  
public:
  /**
   * Create a prepared instance for SOAP-actions.
   * 
   * Params:
   *    host = Hostname/IP of router
   *    port = Port of UPnP-Connection, usually 49000
   *    actions = Array of Actions to perform, see soaptyes
   */
  this(in string host, in string port,
	   in Actions[] actions) {
	// open connection
	this.host = host;
	this.port = port;
	this.url = host~":"~port;
	this.actions = actions.dup();
  }

  string[string] getReplies() {
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
	  this.reply[lAction.description] ~= to!string(query);
	}
  }
  
  /**
   * Execute queries.
   *
   * Returns:
   *    Associative array of the form `[Action: "reply1", …]`
   */
  string[SoapActionData] getReplies() {
	return this.reply;
  }
		  
  override string toString() const {
	/** 
	 * Returns string represesentation.
	 * 
	 * Returns:
	 *    String of the form
	 *    `reply1\nreply2`
	 */
	string result;
	result ~= format("%-(%s%|\n%)", reply.values);
	return result;
  }
}
