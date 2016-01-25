module soaptypes;

import std.format;

enum Actions {GetExtIP, GetUpstream, GetDownstream, GetConnStatus};

struct SoapActionData {
  string controlUrl;
  string service;
  string action;
  string argument;
  string description;
  final string toString() const{
	return description;
  }

  final void toString(scope void delegate(const(char)[]) sink,
					  FormatSpec!char fmt) const
  {
	sink.formatValue(description, fmt);
  }
}

enum SoapActionData SoapGetExtIP = {"/igdupnp/control/WANIPConn1",
									"urn:schemas-upnp-org:service:WANIPConnection:1",
									"GetExternalIPAddress",
									"NewExternalIPAddress",
									"Ip-Address"};
enum SoapActionData SoapGetUpstream = {"/igdupnp/control/WANCommonIFC1",
									   "urn:schemas-upnp-org:service:WANCommonInterfaceConfig:1",
									   "GetCommonLinkProperties",
									   "NewLayer1UpstreamMaxBitRate",
									   "Upstream"};
enum SoapActionData SoapGetDownstream = {"/igdupnp/control/WANCommonIFC1",
										 "urn:schemas-upnp-org:service:WANCommonInterfaceConfig:1",
										 "GetCommonLinkProperties",
										 "NewLayer1DownstreamMaxBitRate",
										 "Downstream"};
enum SoapActionData SoapGetConnStatus = {"/igdupnp/control/WANCommonIFC1",
										 "urn:schemas-upnp-org:service:WANCommonInterfaceConfig:1",
										 "GetCommonLinkProperties",
										 "NewPhysicalLinkStatus",
										 "Status"};
