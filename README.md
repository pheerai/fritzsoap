# FRITZSoap #

fritzsoap is a simple SOAP-Implementation for AVM FRITZ!Boxes that targets upon getting Information from CLI. You may either used the shipped `fritzsoap`-main (see below), or use the `soapsocket.SoapAction`-class do it's work..

## Status ##

Currently, fritzsoap supports the following actions:

 * Get the current maximum downstream
 * Get the current maximum upstream
 * Get current DSL connection status
 * Get current external IP
 
The following will hopefully be implemented in future:

 * Reconnect DSL
 * Get information like URL and possible actions from the router
 * Nice front-end
 * Unittests / Contracts
 * Docs

## Usage ##

### Using fritzsoap ###

Set the enums `THost`, `TPort` and `TAction` to match your desired behaviour, then recompile using `dub build`.

### Using the soapsocket class ###

You may also use the class `soapsocket.SoapAction` to implement your own front-end. For this, just pass a hostname, a port and an array of `soaptype.Actions` to the generator. The most useful return value would be "SoapAction.getReplies()", which returns an associative array `string[string]`, where the keys are descriptions like "IP-Address", and values are the corresponding answers from the remote. Example:

```
import std.stdio;
import soapsocket;

void main() {
	auto soap = new soapsocket.SoapAction("fritz.box",
		                                  "49000",
										  [Actions.GetConnStatus]);
	auto replies = soap.getReplies();
	writeln(replies);
}
```

This gives something like `["Status":"Up"]`.

## License ##

fritzsoap is published under MIT-License, see [LICENSE](LICENSE) file for further information.
