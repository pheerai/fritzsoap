module soapquery;

import std.net.curl;
import std.format;
import std.conv;
import soaptypes;
import queryparser;

// Template for generation of the XML-Data
// %1 UpnpAction
// %2 UpnpService

private enum string xmlData_T =
  "<?xml version=\"1.0\" encoding=\"utf-8\"?>
<s:Envelope s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\">
<s:Body>
<u:%1$s xmlns:u=\"%2$s\" />
</s:Body>
</s:Envelope>";

class SoapQuery {
private:
  string stringData;
  string stringReply;
  string replyValue;
  
public:
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

  override string toString() const {
	return replyValue;
  }
}
