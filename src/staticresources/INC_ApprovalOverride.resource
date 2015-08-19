<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js" type="text/javascript"></script>
<script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.10.4/jquery-ui.min.js" type="text/javascript"></script>

<script>
var j$ = jQuery.noConflict();
function clickOver(){
	j$('a:contains("Back to")').bind('click', function(e){
		 var sPageURL = window.location.pathname;
		  var sId = sPageURL.substr(sPageURL.lastIndexOf('/') + 1);
		  alert('Working');
		  if(sId.indexOf("a5x") == 0){
		    e.preventDefault();
		    window.location="apex/INC_EnrollmentApprovalOveride?id=" +sId;
		  }
		})
}

j$( document ).ready(function() {
    clickOver();
});
</script>