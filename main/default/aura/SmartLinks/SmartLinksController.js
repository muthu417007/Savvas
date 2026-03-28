({
doInit : function(component, event, helper) {

function fixArticleLinks() {
//debugger;
$('.article-column').find('a').each(function(idx,e){
var href = e.getAttribute('href');
if (href && href.indexOf('/articles/')>=0) {
var terms = href.split('/');
var newhref = $A.get('$Site').siteUrlPrefix+'/article/'+terms[terms.length-1];
e.setAttribute('href',newhref);
}
});
}

function waitFor() {
//debugger;
var rootElement = document.querySelector('.article-column');

var listener = function(e) {
if (document.querySelector('.forceRecordLayout')) {// && !fixed) {
//debugger;
// the class we are interested is finally loaded
fixArticleLinks();
// remove the second we do a fix up
//rootElement.removeEventListener('DOMNodeInserted', listener);
}
}

// lets start waiting for all nodes inserted in center area
rootElement.addEventListener('DOMNodeInserted', listener, false);
}

$('body').bind('routeChangeSuccess', function(e) {
if (window.location.href.indexOf('/article')>=0) {

// node not loaded, lets wait for it
waitFor();
}
}); 
}
})