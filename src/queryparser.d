module queryparser;

import std.exception: enforce;
import kxml.xml;

class QueryParser {
private:
  string result;
  
public:
  this(in string text, in string argument) {
	auto xml= readDocument(text);
	auto xmlResult = xml.parseXPath("//"~argument);
	enforce(xmlResult.length == 1);
	auto node = xmlResult[0];
	result = node.getCData();
  }
  
  override string toString() const {
	return result;
  }
}

  
 
