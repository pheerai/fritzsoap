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
  string result;
  
public:
  /**
   * Construct a QueryParser.
   *
   * Params:
   *    text = String containing XML-text to be parsed
   *    argument = Name of tag to seach for
   *
   * Enforces:
   *    `text` has to be valid XML and (currently) must contain exactly one leaf of type `result`
   */
  this(in string text, in string argument) {
	auto xml= readDocument(text);
	auto xmlResult = xml.parseXPath("//"~argument);
	enforce(xmlResult.length == 1);
	auto node = xmlResult[0];
	result = node.getCData();
  }

  /**
   * Returns the CData found in `text` below `argument`
   */
  override string toString() const {
	return result;
  }
}
