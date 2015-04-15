/**
 *
 * Elephant Bird Consulting - KBO data.
 *
 * @author Tom Geudens. 2014/01/22.
 *
 */

/**
 * Accessor Imports.
 */
import org.netkernel.layer0.nkf.*;
import org.netkernel.layer0.representation.*
import org.netkernel.layer0.representation.impl.*;


/**
 * Processing Imports.
 */
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 *
 * KBO data sparql Accessor.
 *
 */


// context
INKFRequestContext aContext = (INKFRequestContext)context;
//

String vQuery = aContext.source("httpRequest:/param/query", String.class);

// processing
if (vQuery != null) {
	// protect against injection
	Pattern vInjectionPattern = Pattern.compile("(?i)\\bINSERT|DELETE|LOAD|CLEAR|CREATE|DROP|COPY|MOVE|ADD\\b");
	Matcher vInjectionMatcher = vInjectionPattern.matcher(vQuery);
	Boolean vInjectionFound = vInjectionMatcher.find();

	if (vInjectionFound) {
		throw new NKFException("SPARQL query operation is not supported");
	}
}

Pattern vConstructPattern = Pattern.compile("(?i)\\bCONSTRUCT\\b");
Matcher vConstructMatcher = vConstructPattern.matcher(vQuery);
Boolean vConstructFound = vConstructMatcher.find();

Pattern vDescribePattern = Pattern.compile("(?i)\\bDESCRIBE\\b");
Matcher vDescribeMatcher = vDescribePattern.matcher(vQuery);
Boolean vDescribeFound = vDescribeMatcher.find();

Pattern vAskPattern = Pattern.compile("(?i)\\bASK\\b");
Matcher vAskMatcher = vAskPattern.matcher(vQuery);
Boolean vAskFound = vAskMatcher.find();

String vAcceptHeader = (String)aContext.source("httpRequest:/header/Accept", String.class);
if (vAcceptHeader == null) {
	if (vConstructFound || vDescribeFound) {
		vAcceptHeader = "application/rdf+xml";
	}
	else if (vAskFound) {
		vAcceptHeader = "text/boolean";
	}
	else {
		vAcceptHeader = "application/sparql-results+xml";
	}
}

INKFRequest sparqlrequest = aContext.createRequest("active:httpPost");
HDSBuilder body = new HDSBuilder();
body.pushNode("query", vQuery);
sparqlrequest.addArgumentByValue("nvp", body.getRoot());
sparqlrequest.addArgument("url", "http://localhost:8083/module/sparql/query");
HDSBuilder newHeaders = new HDSBuilder();
if (vAcceptHeader.startsWith("text/html")) {
	if (vConstructFound || vDescribeFound) {
		newHeaders.addNode("Accept", "application/rdf+xml");
	}
	else if (vAskFound) {
		newHeaders.addNode("Accept", "text/boolean");
	}
	else {
		newHeaders.addNode("Accept", "application/sparql-results+xml");
	}
}
else {
	newHeaders.addNode("Accept", vAcceptHeader);
}
sparqlrequest.addArgumentByValue("headers", newHeaders.getRoot());
@SuppressWarnings("rawtypes")
INKFResponseReadOnly sparqlresponse = aContext.issueRequestForResponse(sparqlrequest);
String vException;
if (sparqlresponse.hasHeader("exception"))
	vException = (String)sparqlresponse.getHeader("exception");
Object vResult = sparqlresponse.getRepresentation();
//

String vMimetype = null;
if (vAcceptHeader.startsWith("text/html")) {
	if (vConstructFound || vDescribeFound) {
		vMimetype = "application/rdf+xml";
	}
	else if (vAskFound) {
		vMimetype = "text/boolean";
	}
	else {
		vMimetype = "text/html";
	}
}
else {
	vMimetype = vAcceptHeader;
}

// response
INKFResponse vResponse = null;
if (vException.equals("true")) {
	vResponse = aContext.createResponseFrom(vResult);
	vResponse.setMimeType("text/plain");
	vResponse.setExpiry(INKFResponse.EXPIRY_ALWAYS);
}
else {
	if (vAcceptHeader.startsWith("text/html")) {
		
			if (vConstructFound || vDescribeFound || vAskFound) {
				vResponse = aContext.createResponseFrom(vResult);
			}
			else {
				
				INKFRequest xsltrequest = aContext.createRequest("active:xslt2");
				xsltrequest.addArgumentByValue("operand", vResult);
				xsltrequest.addArgument("operator", "res:/resources/xsl/kbosparql.xsl");
				Object vHTML = aContext.issueRequest(xsltrequest);
		
				INKFRequest serializerequest = aContext.createRequest("active:saxonSerialize");
				serializerequest.addArgumentByValue("operand", vHTML);
				serializerequest.addArgumentByValue("operator", "<serialize><indent>yes</indent><omit-declaration>yes</omit-declaration><encoding>UTF-8</encoding><method>xhtml</method><mimeType>text/html</mimeType></serialize>");
				IReadableBinaryStreamRepresentation vRBSHTML = (IReadableBinaryStreamRepresentation)aContext.issueRequest(serializerequest);
			
				vResponse = aContext.createResponseFrom(vRBSHTML);
			}
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
		// No CORS verification yet, I just allow everything
		vResponse.setHeader("httpResponse:/header/Access-Control-Allow-Origin","*");
	}
	vResponse.setHeader("httpResponse:/header/Vary","Accept");
	vResponse.setExpiry(INKFResponse.EXPIRY_DEPENDENT);
}
//
