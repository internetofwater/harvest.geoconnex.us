// jshint esversion: 8 
import {
  html,
  render
} from '/js/lit-html.js';
import '/js/pako.js';
// import '/js/tribute.js';
//import { MeiliSearch  } from 'meilisearch';

var mytext = getUrlParam('search', '');
var res = mytext.replaceAll("+", " ").replaceAll("%3A", ":");
var box = document.getElementById("search");
if (res) {
  box.value = res;
}

if (res) {
  textcall(res, 30, 0);
}


function textcall(q, n, o) {
  console.log("Text Call");
  console.log(q);
  console.log(n);
  console.log(0);

  document.getElementById('resultsmain').style.display = "block";


  (async () => {


    const client = new MeiliSearch({
      host: 'https://index.geoconnex.us',
      apiKey: 'masterKey',
    });
    const index = client.index('iow');

    const search = await index.search(res);
    console.log(search);


    //     // const content = await rawResponse.blob();  // .json();
    // document.getElementById('progress').style.display = "none";
    const el = document.querySelector('#article');
    render(showresults(search), el);

  })();
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


// lithtml render function
const showresults = (content) => {
  console.log("-----------------------")

  var barval = content.hits;
  var count = Object.keys(barval).length;
  const itemTemplates = [];
  // itemTemplates.push(html`<div class="container">`);

  // Start the card

  for (var i = 0; i < count; i++) {
    const headTemplate = [];  // write to this and then save to the itemTemplate
    const containerTemplate = [];  // write to this and then save to the itemTemplate

    // console.log("--- in  NEW data files loop ---")
    // itemTemplates.push(html`<div class="row" style="margin-top:30px"> <div class="col-12"> <pre> <code>`);

    console.log(barval[i].id);

    var s;

    if (getSafe(() => barval[i]["@graph"][2]["@id"])) {
      s = barval[i]["@graph"][2]["@id"];
    }

    var so;
    if (getSafe(() => barval[i]["@graph"][2]["@id"])) {
      so = barval[i]["@graph"][2]["@id"];
    }

    var name;
    var nameshort = "Name unavailable";
    if (getSafe(() => barval[i]["@graph"][2].label)) {
      name = barval[i]["@graph"][2].label;
      nameshort = truncate.apply(barval[i]["@graph"][2].label, [90, true]);
    }

    var desc;
    if (getSafe(() => barval[i]["@graph"][2].label)) {
      desc = truncate.apply(barval[i]["@graph"][2].label, [900, true]);
    }

    itemTemplates.push(html` <small>  <ins> <a class="secondary" target="_blank" href="${s}">  ${name}</a> </ins> </small><br>
        <h5 style="margin-bottom:0;margin-top:0"> Resource: <a target="_blank" href="${so}" > ${so} </a></h5>
        <p style="margin-bottom:80px">
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



// // Conduct the SPARQL call and call the lithtml functions to render results
// function graphcall(q, n, o) {
//   console.log("Graph Call");
//   console.log(n);

//   // process types
//   const re = /type:.+?\b/;
//   var rem = res.match(re);
//   var ressparql = q;
//   var typereq = "";
//   if (rem) {
//     console.log(rem[0]);
//     ressparql = res.replace(rem[0], '');
//     typereq = rem[0];
//   }

//   console.log(decodeURIComponent(res));
//   console.log("resparql: " + ressparql);
//   console.log(typereq);

//   var tq = "?s rdf:type ?type . ";
//   if (q.includes('type:')) {
//     var splt = rem[0].split(":");
//     tq = ` BIND (schema:${splt[1]} AS ?type) . ?s rdf:type ?type . `;
//   }

//   document.getElementById('resultsmain').style.display = "block";
//   //document.getElementById('progress').style.visibility = "visible";

//   (async () => {
//        var url = new URL("https://graph.geoconnex.us/repositories/iowdev"),


//         params = {
//         query: `prefix prov: <http://www.w3.org/ns/prov#>
//         PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
//         PREFIX schema: <https://schema.org/>

//         select DISTINCT ?s ?name ?desc ?so where {
//             ?s schema:description ?desc .
//             ?s schema:name ?name .
//             ?s schema:subjectOf  ?so .
//             FILTER regex(?desc, "${ressparql}", "i")  .

//         }
//         LIMIT 100
//       ` };


//     Object.keys(params).forEach(key => url.searchParams.append(key, params[key]));
//     console.log(params.query);
//     console.log(url);

//     axios.get(url.toString())
//       .then(function (response) {
//         // handle success
//         console.log(response);
//         const el = document.querySelector('#article');
//         render(showresults(response), el);
//       })
//       .catch(function (error) {
//         // handle error
//         console.log(error);
//       })
//       .then(function () {
//         // always executed
//       });


//     // const content = await rawResponse.blob();  // .json();
//   //document.getElementById('progress').style.display = "none";

//   })();
// }