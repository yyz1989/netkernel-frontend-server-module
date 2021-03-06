
/* kbodata-config.js */

(function($) {
	
	window['kbodata-config'] = {
        // search
        searchExamples: 'config/search-examples.txt',                   // path or url
        searchEndpoint: 'http://id.vlaanderen.be/keywordsearch',         // path or url
        // query
        sparqlExamples: 'config/sparql-examples.txt',                   // path or url
        sparqlEndpoint: 'http://id.vlaanderen.be/sparql',                // path or url
        // lookup
        lookupExamples: 'config/lookup-examples.txt',                   // path or url
        // fragment
        fragmentExamples: 'config/fragment-examples.txt',               // path or url
        fragmentEndpoint: 'http://id.vlaanderen.be/fragments',           // path or url
        // reconciliation
        reconciliationExamples: 'config/reconciliation-examples.txt',   // path or url
        reconciliationEndpoint: 'http://id.vlaanderen.be/reconcile'      // path or url
	};
	
})(jQuery);
