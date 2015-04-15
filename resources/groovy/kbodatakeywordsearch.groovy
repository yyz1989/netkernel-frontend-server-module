/**
 *
 * Elephant Bird Consulting - KBO data.
 *
 * @author Tom Geudens. 2014/05/10.
 *
 */

/**
 * Accessor Imports.
 */
import org.netkernel.layer0.nkf.*;
import org.netkernel.layer0.representation.*
import org.netkernel.layer0.representation.impl.*;
import org.netkernel.layer0.representation.impl.HDSBuilder;

/**
 *
 * KBO data keyword search Accessor.
 *
 */

// context
INKFRequestContext aContext = (INKFRequestContext)context;
//

String vSearch;
if (aContext.exists("httpRequest:/param/search")) {
	vSearch = aContext.source("httpRequest:/param/search", String.class);
}
else if (aContext.getThisRequest().argumentExists("search")) {
	vSearch = aContext.source("arg:search", String.class);
}
else throw new NKFException("Keyword search request does not have a valid \"search\" argument");
String vDefaultMimetype = aContext.source("kbodata:mimetypes-keywordsearch-default", String.class);
String acceptHeaders = (String)aContext.source("httpRequest:/header/Accept", String.class);
String[] extractedHeaders = acceptHeaders.split(";");
String[] extractedTypes = extractedHeaders[0].split(",");
String vMimetype = extractedTypes[0];

INKFRequest keywordsearchrequest = aContext.createRequest("active:httpGet");
HDSBuilder headers = new HDSBuilder();
keywordsearchrequest.addArgument("url", "http://localhost:8083/module/sparql/search?query=" + vSearch);
if (vMimetype.equals("text/html")) {
	headers.addNode("Accept", vDefaultMimetype);
}
else {
	headers.addNode("Accept", vMimetype);
}
keywordsearchrequest.addArgumentByValue("headers", headers.getRoot());
Object vResult = aContext.issueRequest(keywordsearchrequest);
//

// response
INKFResponse vResponse = null;
if (vMimetype.equals("text/html")) {
	INKFRequest xsltrequest = aContext.createRequest("active:xslt2");
	xsltrequest.addArgumentByValue("operand", vResult);
	xsltrequest.addArgumentByValue("keyword", vSearch);
	xsltrequest.addArgument("operator", "res:/resources/xsl/kbokeyword.xsl");
	Object vHTML = aContext.issueRequest(xsltrequest);
	
	vResponse = aContext.createResponseFrom(vHTML);
}
else {
	vResponse = aContext.createResponseFrom(vResult);
}
vResponse.setMimeType(vMimetype);
String vCORSOrigin = null;
try {
	vCORSOrigin = aContext.source("httpRequest:/header/Origin", String.class);
}
catch (Exception e){
	//
}
if (vCORSOrigin != null) {
	// No CORS verification yet, I just allow the origin
	vResponse.setHeader("httpResponse:/header/Access-Control-Allow-Origin","*");
}
vResponse.setHeader("httpResponse:/header/Vary","Accept");
vResponse.setExpiry(INKFResponse.EXPIRY_DEPENDENT);
//
