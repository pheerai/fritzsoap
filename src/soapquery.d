/**
 * Authors: Oliver Rümpelein
 * Date: 2016-01-24
 * License: MIT
 */
module soapquery;

import std.net.curl;
import std.format;
import std.conv;
import soaptypes;
import queryparser;

/**
 * Template for generation of the XML-Data in the query.
 * 
 * Replace %1 with a UpnpAction and %2 with UpnpService.
 */
private enum string xmlData_T =
  "<?xml version=\"1.0\" encoding=\"utf-8\"?>
<s:Envelope s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\">
<s:Body>
<u:%1$s xmlns:u=\"%2$s\" />
</s:Body>
</s:Envelope>";

/**********
 * Query `url` for action specified in `action`.
 */
class SoapQuery {
private:
  string stringData;
  string stringReply;
  string replyValue;
  
public:
  /**
   * Execute a SoapQuery
   *
   * This gets the data from tho router using a HTTP-Socket,
   * then creates a parser and returns its result.
   *
   * Params:
   *    action = The action to perform
   *    url = Host:Port to query
   */
  this(in SoapActionData action, in string url) {

	import std.stdio;
	
	this.stringData = xmlData_T.format(action.action, action.service);

	auto http = HTTP(url~action.controlUrl);
	scope(failure) http.shutdown();
	http.method = HTTP.Method.post;
	http.addRequestHeader("SoapAction", action.service~"#"~action.action);
	http.contentLength = this.stringData.length;
	http.setPostData(this.stringData, "text/xml; charset=\"utf-8\"");
	http.onReceive = (ubyte[] data) { stringReply ~= data; return data.length;};
	http.perform();
	http.shutdown();
	
	auto parser = new QueryParser(this.stringReply, action.argument);
	replyValue = to!string(parser);
  }

  /**
   * Returns the data extracted from the SOAP-Query
   */
  override string toString() const {
	return replyValue;
  }
}
