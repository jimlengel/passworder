$(document).ready(function() {
  // This is called after the document has loaded in its entirety
  // This guarantees that any elements we bind to will exist on the page
  // when we try to bind to them
  $("form input:lt(1)").focus();

  // See: http://docs.jquery.com/Tutorials:Introducing_$(document).ready()
});
