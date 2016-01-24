module queryparser;

import std.exception: enforce;
import kxml.xml;

class QueryParser {
private:
  string argument;
  string result;
  XmlNode node;
  
public:
  this(in string text, in string argument) {
	this.argument = argument;
	XmlNode xml= readDocument(text);
	auto xmlResult = xml.parseXPath("//"~this.argument);
	enforce(xmlResult.length == 1);
	node = xmlResult[0];
	result = node.getCData();
  }
  
  override string toString() const {
	return result;
  }
}

  
 
