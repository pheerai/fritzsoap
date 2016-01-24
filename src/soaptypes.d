module soaptypes;

enum Actions {GetExtIP, GetUpstream, GetDownstream, GetConnStatus};

struct SoapActionData {
  string controlUrl;
  string service;
  string action;
  string argument;
  string description;
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
