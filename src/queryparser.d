/**
 * Authors: Oliver Rümpelein
 * Date: 2016-01-24
 * License: MIT
 */
module queryparser;

import std.exception: enforce;
import kxml.xml;

/**********
 * Parse `text` for XML-Node `argument`.
 */
class QueryParser {
private:
  string argument;
  string result;
  XmlNode node;
  
public:
  /**
   * Construct a QueryParser.
   *
   * Params:
   *    text = String containing XML-text to be parsed
   *    argument = Name of tag to seach for
   *
   * Enforces:
   *    `text` has to be valid XML and must contain exactly one leaf of type `result`
   */
  this(in string text, in string argument) {
	this.argument = argument;
	XmlNode xml= readDocument(text);
	auto xmlResult = xml.parseXPath("//"~this.argument);
	enforce(xmlResult.length == 1);
	node = xmlResult[0];
	result = node.getCData();
  }

  /**
   * Returns the CData found in `text` below `argument`
   */
  override string toString() const {
	return result;
  }
}
