/**********
 * Authors: Oliver Rümpelein
 * Date: 2016-01-25
 * License: MIT
 */
module soaptypes;

import std.format;

/// Currently implemented actions for use with SoapAction
enum Actions {GetExtIP, GetUpstream, GetDownstream, GetConnStatus};

/**********
 * Wrapper for necessary information.
 */
struct SoapActionData {
  string controlUrl;
  string service;
  string action;
  string argument;
  string description;

  /**
   * Get the description of the Instance
   *
   * This supports formatting.
   */
  final string toString() const{
	return description;
  }
  
  /// ditto
  final void toString(scope void delegate(const(char)[]) sink,
					  FormatSpec!char fmt) const
  {
	sink.formatValue(description, fmt);
  }
}

/// URLs and other Informations for SOAP-Queries
enum SoapActionData SoapGetExtIP = {"/igdupnp/control/WANIPConn1",
									"urn:schemas-upnp-org:service:WANIPConnection:1",
									"GetExternalIPAddress",
									"NewExternalIPAddress",
									"Ip-Address"};
/// Ditto
enum SoapActionData SoapGetUpstream = {"/igdupnp/control/WANCommonIFC1",
									   "urn:schemas-upnp-org:service:WANCommonInterfaceConfig:1",
									   "GetCommonLinkProperties",
									   "NewLayer1UpstreamMaxBitRate",
									   "Upstream"};
/// Ditto
enum SoapActionData SoapGetDownstream = {"/igdupnp/control/WANCommonIFC1",
										 "urn:schemas-upnp-org:service:WANCommonInterfaceConfig:1",
										 "GetCommonLinkProperties",
										 "NewLayer1DownstreamMaxBitRate",
										 "Downstream"};
/// Ditto
enum SoapActionData SoapGetConnStatus = {"/igdupnp/control/WANCommonIFC1",
										 "urn:schemas-upnp-org:service:WANCommonInterfaceConfig:1",
										 "GetCommonLinkProperties",
										 "NewPhysicalLinkStatus",
										 "Status"};
