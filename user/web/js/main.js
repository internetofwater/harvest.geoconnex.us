/* jshint esversion: 8 */
import {
  html,
  render
} from '/js/lit-html.js';
import '/js/pako.js';
// import '/js/tribute.js';


// Tribute section
var tribute = new Tribute({
  collection: [{
    // symbol or string that starts the lookup
    trigger: 'type:',

    // element to target for @mentions
    iframe: null,

    // class added in the flyout menu for active item
    selectClass: 'highlight',

    // class added to the menu container
    containerClass: 'tribute-container',

    // class added to each list item
    itemClass: '',

    // function called on select that returns the content to insert
    selectTemplate: function (item) {
      return 'type:' + item.original.value;
    },

    // template for displaying item in menu
    menuItemTemplate: function (item) {
      return item.string;
    },

    // template for when no match is found (optional),
    // If no template is provided, menu is hidden.
    noMatchTemplate: null,

    // specify an alternative parent container for the menu
    // container must be a positioned element for the menu to appear correctly ie. `position: relative;`
    // default container is the body
    menuContainer: document.body,

    // column to search against in the object (accepts function or string)
    lookup: 'key',

    // column that contains the content to insert by default
    fillAttr: 'value',

    // REQUIRED: array of objects to match or a function that returns data (see 'Loading remote data' for an example)
    values: [ { key: "Course", value: "Course" }, { key: "Dataset", value: "Dataset" }, { key: "Person", value: "Person" },{ key: "Org", value: "Organization" }],

    // When your values function is async, an optional loading template to show
    loadingItemTemplate: null,

    // specify whether a space is required before the trigger string
    requireLeadingSpace: true,

    // specify whether a space is allowed in the middle of mentions
    allowSpaces: false,

    // optionally specify a custom suffix for the replace text
    // (defaults to empty space if undefined)
    replaceTextSuffix: '\n',

    // specify whether the menu should be positioned.  Set to false and use in conjuction with menuContainer to create an inline menu
    // (defaults to true)
    positionMenu: true,

    // when the spacebar is hit, select the current match
    spaceSelectsMatch: false,

    // turn tribute into an autocomplete
    autocompleteMode: false,

    // Customize the elements used to wrap matched strings within the results list
    // defaults to <span></span> if undefined
    searchOpts: {
      pre: '<span>',
      post: '</span>',
      skip: false // true will skip local search, useful if doing server-side search
    },

    // Limits the number of items in the menu
    menuItemLimit: 25,

    // specify the minimum number of characters that must be typed before menu appears
    menuShowMinLength: 0
  }]
});

tribute.attach(document.getElementById("search"));
// end tribute

var mytext = getUrlParam('search', '');
var res = mytext.replaceAll("+", " ").replaceAll("%3A", ":");
var box = document.getElementById("search");
if (res) {
  box.value = res;
}

if (res) {
   graphcall(res, 30, 0);
}

function getUrlVars() {
  var vars = {};
  var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function (m, key, value) {
    vars[key] = value;
  });
  return vars;
}

function getUrlParam(parameter, defaultvalue) {
  var urlparameter = defaultvalue;
  if (window.location.href.indexOf(parameter) > -1) {
    urlparameter = getUrlVars()[parameter];
  }
  return urlparameter;
}

// Conduct the SPARQL call and call the lithtml functions to render results
function graphcall(q, n, o) {
  console.log("Graph Call");
  console.log(n);

  // process types
  const re = /type:.+?\b/;
  var rem = res.match(re);
  var ressparql = q;
  var typereq = "";
  if (rem) {
    console.log(rem[0]);
    ressparql = res.replace(rem[0], '');
    typereq = rem[0];
  }

  console.log(decodeURIComponent(res));
  console.log("resparql: " + ressparql);
  console.log(typereq);

  var tq = "?s rdf:type ?type . ";
  if (q.includes('type:')) {
    var splt = rem[0].split(":");
    tq = ` BIND (schema:${splt[1]} AS ?type) . ?s rdf:type ?type . `;
  }

  document.getElementById('resultsmain').style.display = "block";
  //document.getElementById('progress').style.visibility = "visible";

  (async () => {
       var url = new URL("https://graph.geoconnex.us/repositories/iow"),


        params = {
        query: `PREFIX luc: <http://www.ontotext.com/connectors/lucene#>
        PREFIX luc-index: <http://www.ontotext.com/connectors/lucene/instance#>
        PREFIX schema: <https://schema.org/>
        
        SELECT ?s ?score ?name ?desc ?label {
          ?search a luc-index:combined_one ;
              luc:query "${ressparql}" ;
              luc:entities ?s .
              ?s luc:score ?score .
            
            OPTIONAL { ?s schema:name ?name . }
            OPTIONAL { ?s schema:description ?desc . }
            OPTIONAL { ?s <http://www.w3.org/2000/01/rdf-schema#label> ?label .}
        }
        LIMIT 100
      ` };


    Object.keys(params).forEach(key => url.searchParams.append(key, params[key]));
    console.log(params.query);
    console.log(url);

    axios.get(url.toString())
      .then(function (response) {
        // handle success
        console.log(response);
        const el = document.querySelector('#article');
        render(showresults(response), el);
      })
      .catch(function (error) {
        // handle error
        console.log(error);
      })
      .then(function () {
        // always executed
      });


    // const content = await rawResponse.blob();  // .json();
  //document.getElementById('progress').style.display = "none";

  })();
}

// lithtml render function
const showresults = (content) => {
  console.log("--------------------------");

  var barval = content.data.results.bindings;
  var count = Object.keys(barval).length;
  const itemTemplates = [];
  // itemTemplates.push(html`<div class="container">`);

  // Start the card

  for (var i = 0; i < count; i++) {
    const headTemplate = [];  // write to this and then save to the itemTemplate
    const containerTemplate = [];  // write to this and then save to the itemTemplate

    // console.log("--- in  NEW data files loop ---")
    // itemTemplates.push(html`<div class="row" style="margin-top:30px"> <div class="col-12"> <pre> <code>`);

    var s;
    if (getSafe(() => barval[i].s.value)) {
      s = barval[i].s.value;
    }

    var so;
    if (getSafe(() => barval[i].label.value)) {
      so = barval[i].label.value;
    }

    var name = "";
    var nameshort = "Name unavailable";
    if (getSafe(() => barval[i].name.value)) {
      name = barval[i].name.value;
      nameshort = truncate.apply(barval[i].name.value, [90, true]);
    }

    var desc;
    if (getSafe(() => barval[i].desc.value)) {
      desc = truncate.apply(barval[i].desc.value, [900, true]);
    }

    itemTemplates.push(html`
        <h5 style="margin-bottom:0;margin-top:0"> Resource: <a target="_blank" href="${s}" > ${so} </a></h5>
        <small>  <ins> <a class="secondary" target="_blank" href="${s}">  ${name}</a> </ins> </small>
        <p style="margin-bottom:10px">
            ${desc}
        </p> `);

  }

  // Add in button for next set
  itemTemplates.push(html` <a href="#" class="secondary" ">Next Page</a>`);



  return html`
	<div style="margin:30px">
	   ${itemTemplates}
    </div>
	`;
};

// Helper function: See if an object is undefine
function getSafe(fn) {
  try {
    return fn();
  } catch (e) {
    return undefined;
  }
}

// Helper function: truncate a block of text to a length n
function truncate(n, useWordBoundary) {
  if (this.length <= n) { return this; }
  var subString = this.substr(0, n - 1);
  return (useWordBoundary ? subString.substr(0, subString.lastIndexOf(' '))
    : subString) + "...";
}
