/**
 * Authors: Oliver Rümpelein
 * Date: 2016-01-24
 * License: MIT
 */
/*********
 * Basic fritzsoap frontend
 *
 * Querys THost:TPort for Informations specified in TAction
 *
 * Writes actions specified in TAction to stdout,
 * in the form ["desc1": "value1", "desc2": "value2"]
 */

import std.stdio;
import soapsocket;

/********* 
 * These replace arguments
 *
 * THost:    Hostname or IP of router to Query
 * TPort:    SOAP-Port, usually 49000
 * TAction:  Contains one or severall Actions as given in
 *           soaptypes
 */
enum string THost = "10.166.0.2";
/// ditto
enum string TPort = "49000";
/// ditto
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
