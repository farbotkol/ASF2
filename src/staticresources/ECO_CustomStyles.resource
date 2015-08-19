/* GLOBAL BOOTSTRAP OVERWRITES - if everything is !important... nothing is !important */
html, body{
	height:100%;
	overflow-x:hidden;
} 
.btn:hover{
	-webkit-transition: background-color 200ms linear !important;
    -moz-transition: background-color 200ms linear !important;
    -o-transition: background-color 200ms linear !important;
    -ms-transition: background-color 200ms linear !important;
    transition: background-color 200ms linear !important;
}
.btn-primary{
	background-color:#00b5e5 !important;
	border-color:#19c8f6 !important;
}
.btn-primary:hover{
	background-color:#16c7f6 !important;;
	border-color:#33cff9 !important;
	-webkit-transition: background-color 200ms linear !important;
    -moz-transition: background-color 200ms linear !important;
    -o-transition: background-color 200ms linear !important;
    -ms-transition: background-color 200ms linear !important;
    transition: background-color 200ms linear !important;
}
.btn-success{
	background-color:#7fbb42 !important;
	border-color:#91cd54 !important; 
}
.btn-success:hover{
	background-color:#94cf58 !important;
	border-color:#aae172 !important;
	-webkit-transition: background-color 200ms linear !important;
    -moz-transition: background-color 200ms linear !important;
    -o-transition: background-color 200ms linear !important;
    -ms-transition: background-color 200ms linear !important;
    transition: background-color 200ms linear !important;
}
.btn-danger{
	background-color:#f91a1a !important;
	border-color:#FD3B3B !important;
}
.btn-danger:hover{
	background-color:#FD3B3B !important;
	border-color:#ff5c5c !important;
	-webkit-transition: background-color 200ms linear !important;
    -moz-transition: background-color 200ms linear !important;
    -o-transition: background-color 200ms linear !important;
    -ms-transition: background-color 200ms linear !important;
    transition: background-color 200ms linear !important;
}
.btn-warning{
	background-color:#eac518 !important;
	border-color:#f6d434 !important;
}
.btn-warning:hover{
	background-color:#f6d434 !important;
	border-color:#f7da50 !important;
	-webkit-transition: background-color 200ms linear !important;
    -moz-transition: background-color 200ms linear !important;
    -o-transition: background-color 200ms linear !important;
    -ms-transition: background-color 200ms linear !important;
    transition: background-color 200ms linear !important;
}
.navbar-default{
	background-color:#fff !important;
	border:none !important;
	padding:20px 0 20px 0;
}
.navbar{
	margin-bottom:0 !important;
}
.container.full-width.portalPage{
	background-color:#f0f0f0 !important;
}
.panel-default>.panel-heading{
	background-color:#f8f8f8 !important;
}
.panel-heading{
	padding:12px 20px;
}
.panel-title{
	font-size:16px;
	font-weight:bold;
	text-transform:uppercase;
}
h4.panel-title{
	font-size:18px !important;
	margin-top:3px;
}
.panel-heading .btn{
	padding:2px 4px !important;
	margin-right:2px !important;
	font-size:11px !important;
	font-weight:normal;
}
.modal-header{
	background-color: #f5f5f5;
	border-radius: 10px 10px 0 0;
}
.modal-header h4{
	font-size:16px;
	text-transform:uppercase;
	font-weight:bold;
	color:#333;
}

/* ORIGINAL STYLES */
/* GLOBAL */
body{
	color:#333;
}
a:link, a:visited{
	color:#00b5e5;
}
a:hover{
	color:#006f9a;
	text-decoration:none !important;
	cursor: pointer;
	-webkit-transition: color 200ms linear;
    -moz-transition: color 200ms linear;
    -o-transition: color 200ms linear;
    -ms-transition: color 200ms linear;
    transition: color 200ms linear;
}



/* PORTAL PAGE SPECIFIC */
.appIcon{
	color:#808285;
	float:left;
	width:65px;
	height:110px;
	margin:4px 11px 6px 11px;
	text-align:center;
	display:block;
	line-height:100%;
	position:relative;
	font-size:12px;
}
.appIcon:hover{
	color:#00B5E5;
	text-decoration:none !important;
	cursor: pointer;
	-webkit-transition: background-color 200ms linear;
    -moz-transition: background-color 200ms linear;
    -o-transition: background-color 200ms linear;
    -ms-transition: background-color 200ms linear;
    transition: background-color 200ms linear;
}
.appIcon div{
	height:65px;
	width:65px;
	text-align:center;
	margin-bottom:3px;
	background-color:#00b5e5;
	border:1px solid #19c8f6;
	border-radius:10px;
		/* backup functionality for old browsers */
		-moz-border-radius: 10px;
	    -webkit-border-radius: 10px;
	    -khtml-border-radius: 10px;
}
.appIcon div:hover{
	background-color:#16c7f6;
	border-color:#33cff9;
	cursor:pointer;
	-webkit-transition: background-color 200ms linear;
    -moz-transition: background-color 200ms linear;
    -o-transition: background-color 200ms linear;
    -ms-transition: background-color 200ms linear;
    transition: background-color 200ms linear;
}
.appIcon:hover > div{
	background-color:#16c7f6;
	border-color:#33cff9;
	cursor:pointer;
	-webkit-transition: background-color 200ms linear;
    -moz-transition: background-color 200ms linear;
    -o-transition: background-color 200ms linear;
    -ms-transition: background-color 200ms linear;
    transition: background-color 200ms linear;
}
.hoverHand:hover{
	opacity:0.5;
	cursor:pointer;
	-webkit-transition: opacity 100ms linear;
    -moz-transition: opacity 100ms linear;
    -o-transition: opacity 100ms linear;
    -ms-transition: opacity 100ms linear;
    transition: opacity 100ms linear;
}
.appIcon > div > img{
	margin-top:7px;
}
.headerImg > img{
	border:none !important;
}
.headerImgMobile{
	margin-bottom:15px;
}
.projectPort{
	margin-bottom:55px;
}
.portalFirstRow{
	margin:15px 0 15px 0;
	vertical-align:middle;
}
.portalPageWrapper{
	background-color:#f5f5f5;
	min-height:100%;
}
.iconWithText{
	width:65px;
	display:inline-block;
	text-align:center;
	position:relative;
}
.iconWithText:hover{
	color:#00b5e5;
	cursor:pointer;
	-webkit-transition: background-color 200ms linear;
    -moz-transition: background-color 200ms linear;
    -o-transition: background-color 200ms linear;
    -ms-transition: background-color 200ms linear;
    transition: background-color 200ms linear;
}
.iconWithText:hover > img{
	opacity:0.5;
	-webkit-transition: opacity 100ms linear;
    -moz-transition: opacity 100ms linear;
    -o-transition: opacity 100ms linear;
    -ms-transition: opacity 100ms linear;
    transition: opacity 100ms linear;
}
li.iconWithText:hover{
	opacity:0.5;
	-webkit-transition: opacity 100ms linear;
    -moz-transition: opacity 100ms linear;
    -o-transition: opacity 100ms linear;
    -ms-transition: opacity 100ms linear;
    transition: opacity 100ms linear;
}
.iconWithText:hover > .notificationNumber{
	opacity:0.5;
	-webkit-transition: opacity 100ms linear;
    -moz-transition: opacity 100ms linear;
    -o-transition: opacity 100ms linear;
    -ms-transition: opacity 100ms linear;
    transition: opacity 100ms linear;
}
.portalFirstRow .last{
	margin-top:15px;
}
.notificationNumber{
	width:22px;
	height:22px;
	border-radius:15px;
		/* backup functionality for old browsers */
		-moz-border-radius: 15px;
	    -webkit-border-radius: 15px;
	    -khtml-border-radius: 15px;
    z-index:999;
    position:absolute;
    background-color:#e41515;
    border:2px solid #333;
    color:#fff;
    font-size:11px;
    text-align:center;
    padding-top:2px;
    font-weight:bold;
	left: 26px;
	bottom: 22px;
}
.hideApp{
	width:22px;
	height:22px;
	border-radius:15px;
		/* backup functionality for old browsers */
		-moz-border-radius: 15px;
	    -webkit-border-radius: 15px;
	    -khtml-border-radius: 15px;
    z-index:999;
    position:absolute;
    text-align:center;
    font-weight:bold;
    right:-8px;
    top:-6px;
    font-size:20px;
    color:#444;
    cursor:pointer !important;
}
.logoWrap{
	float:right;
	text-align:right;
}
.welcomeMsg{
	font-size:16px;
	margin-top:8px;
}
.inboxWrap{
	float:right;
	margin-top:2px;
}
.inboxWrap img{
	float:right;
}
.inboxWrap .notificationNumber{
	bottom:-5px;
	right:-10px;
}
.reportButton{
	width:100%;
	margin:5px 0 10px 0 !important;
	font-size:12px !important;
} 
.newsPanel, .appPanel{
	height:442px;
}
.appPanel .panel-body{
	height: 353px;
	margin-top: 10px;
	overflow-y:scroll;
	margin-right: 10px;
}
.newsPanel .panel-body{
	height: 353px;
	margin-top: 10px;
	overflow-y:scroll;
	margin-right: 10px;
}
.reportPanel{
	min-height:150px;
}
#feedList{
	list-style-type:none;
	padding-left:0;
}
#feedList li{
	padding:5px 0 7px 0;
	margin:0 0 5px 0;
	border-bottom: none;
}
#feedList .row{
	margin:0 0 15px 0;
}
#feedList .col-sm-2{
	padding-right:0 !important;
}
#feedList .profileImage img{
	width:100%;
	height:auto;
	border-radius:10px;
	margin-bottom:10px;
}
.notificationsModal{
	list-style-type:none;
	padding-left:0;
	border-bottom:1px solid #ebebeb;
	padding-bottom:8px;
	margin-bottom:15px;
}
.notificationsModal:last-of-type{
	border-bottom:none;
}
.notificationsModal .col-sm-2{
	padding-right:0 !important;
	padding-top:3px;
}
.notificationsModal li{
	padding:3px 0 4px 0;
}
.chatterHeader{
	font-size:11px;
	font-variant:italic;
	color:#9d9fa2;
}
.prefaceText{
	font-size:11px;
	font-variant:italic;
	color:#9d9fa2;
	text-align:right;
	vertical-align:middle;
}
#feedList .prefaceText{
	text-align:left;
	margin-top:2px;
}
.notificationsModal h4{
	margin:0;
	font-weight:bold;
}
.taskCheckbox{
	vertical-align:middle;
}
.notificationsModal .row{
	margin:4px 0 5px 0;
}
.projectPanel .col-sm-3{
	margin:3px 0 3px 0;
}
.reports .pbHeader{
	padding-left:15px;
}
.detailList .vfLabelColTextWrap{
	padding-bottom:14px;
	padding-right:15px;
}
.detailList .vfLabelColTextWrap.first{
	padding-bottom:0;
}
.apexp .detailList tr{
	height:50px;
}
.row.reports .apexp{
	margin-top:35px;
}
.pbSubsection .detailList tr:last-child{
	height:0;
}
.pbBottomButtons .pbButtonb{
	padding-top:45px;
}
.col-sm-4 .detailList{
	width:100%;
}



/* APPLICATION MANAGER STYLES */
#sortable{ 
	list-style-type: none; 
	margin: 0; 
	padding: 0; 
}
#sortable a:hover{
animation: jiggle 0.2s infinite;
-webkit-animation: jiggle 0.2s infinite;
-moz-animation-duration: 0.2s;
-moz-animation-name: jiggle;
-moz-animation-iteration-count: infinite;
-webkit-transform: rotate(-1deg);
-moz-transform: rotate(-1deg);
}
.ui-state-default{
	background:none !important;
	border:none !important;
}
.smallText{
	font-size: 1em;
}
.appManager .panel, .reportFinder .panel{
	margin-top:25px;
}
.appManager .appIcon:hover, .appManager .appIcon div:hover{
	cursor:move !important;
}
.appManager .panel-body, .reportFinder .panel-body{
	padding:10px 0 35px 20px;
	overflow:visible !important;
	height:auto !important;
}
.appManager .panel, .reportFinder .panel{
	height:auto !important;
}
.appManager .panel-heading h1, .reportFinder .panel-heading h1{
	font-size:16px;
	text-transform:uppercase;
	font-weight:bold;
	margin-top:0;
	margin-bottom:0;
}
.reportFinder .panel-body input[type="button"], .reportFinder .panel-body input[type="submit"]{
	margin:5px 8px 5px 0;
}
.reports .dataCell{
	text-align:center;
	vertical-align:middle;
}
.reports .detailList{
	width:100%;
}

@keyframes jiggle{
    0% {
        transform: rotate(-1deg);
	}
	50% {
    	transform: rotate(1deg);
	}
}
@-webkit-keyframes jiggle{
    0% {
        -webkit-transform: rotate(-1deg);
	}
	50% {
    	-webkit-transform: rotate(1deg);
	}
}
@-moz-keyframes jiggle{
    0% {
        -moz-transform: rotate(-1deg);
	}
	50% {
		-moz-transform: rotate(1deg);
	}
}



/*------------------------------------------------------------------
[ Subnavbar / .subnavbar ]
*/
.subnavbar {
  margin-bottom: 15px;
  border-top: 1px solid #D9D9D9;
}
.subnavbar .subnav-toggle {
  display: none;
  padding: .5em 0;
  margin: 0 auto;
  font-size: 18px;
  text-align: center;
  color: #ff9900;
}
.subnavbar .subnav-toggle:hover {
  text-decoration: none;
}
.subnavbar .subnavbar-inner {
  min-height: 65px;
  background-color:#E2E2E2;
  border-bottom: 1px solid #DADADA;
}
.subnavbar .btn-subnavbar {
  display: none;
  padding: 10px 0 8px;
  color: #F90;
  font-size: 16px;
  text-align: center;
  cursor: pointer;
}
.subnavbar .btn-subnavbar:hover {
  text-decoration: none;
}
.subnavbar .dropdown .caret {
  margin-top: -16px;
  border-top-color: #888;
  border-bottom-color: #888;
  opacity: 35;
  filter: alpha(opacity=3500);
}
.subnavbar .dropdown.open .caret {
  display: none;
}
.subnavbar .mainnav {
  display: inline-block;
  min-height: 65px;
  padding: 0;
  margin: 0;
  border-left: 1px solid #D0D0D0;
  border-right: 1px solid #F3F3F3;
}
.subnavbar .mainnav > li {
  float: left;
  min-width: 120px;
  height: 65px !important;
  margin: 0;
  text-align: center;
  list-style: none;
  border-left: 1px solid #F3F3F3;
  border-right: 1px solid #D0D0D0;
  cursor:pointer;
}
.subnavbar .mainnav > li {
  display: block;
  height: 100%;
  padding: 6px 5px 0 5px;
  font-size: 12px;
  font-weight: bold;
  color: #636363;
}
.subnavbar .mainnav > li > a:hover {
  color: #888;
  text-decoration: none;
}
.subnavbar .mainnav > li > i {
  position: relative;
  top: 2px;
  display: inline-block;
  width: 24px;
  height: 24px;
  margin-top: 12px;
  margin-bottom: 9px;
  font-size: 28px;
}
.subnavbar .mainnav > li > a > span {
  display: block;
  padding-bottom: 2px;
}
.subnavbar .mainnav > li.open > a {
  text-decoration: none;
}
.subnavbar .mainnav > li.active > a {
  background: #333;
  color: #F90;
}
.subnavbar .mainnav > li.active > a .caret {
  border-top-color: #ff9900;
  border-bottom-color: #ff9900;
}
.subnavbar .dropdown > .dropdown-menu {
  top: 97%;
  text-align: left;
  -webkit-border-top-left-radius: 0;
  -webkit-border-top-right-radius: 0;
  -moz-border-radius-topleft: 0;
  -moz-border-radius-topright: 0;
  border-top-left-radius: 0;
  border-top-right-radius: 0;
}
.subnavbar .dropdown > .dropdown-menu a {
  font-size: 12px;
}
.subnavbar .dropdown > .dropdown-menu::before,
.subnavbar .dropdown > .dropdown-menu::after {
  content: '';
  display: inline-block;
  border-left: 7px solid transparent;
  border-right: 7px solid transparent;
  border-bottom: 7px solid #CCC;
  border-bottom-color: rgba(0, 0, 0, 0.2);
  position: absolute;
  top: -7px;
  left: 9px;
}
.subnavbar .dropdown > .dropdown-menu::after {
  border-left-width: 6px;
  border-right-width: 6px;
  border-bottom-width: 6px;
  border-bottom-color: #fff;
  top: -6px;
  left: 10px;
}
.subnavbar .dropdown-submenu .dropdown-menu:after,
.subnavbar .dropdown-submenu .dropdown-menu:before {
  display: none;
}
.subnavbar .subnav-collapse.collapse {
  height: auto\9;
  overflow: visible\9;
}
.carousel{
	border-top:1px solid #ebebeb !important;
}
.slick-slider{
	margin:0 0 8px 0 !important;
	padding-top:3px;
	overflow:hidden;
}


/* CHATTER FEED FIXES */

/* ALL CHATTER FIXES */
@media (min-width: 768px) {
  body .container {
    width: 750px;
  }
}
@media (min-width: 992px) {
  body .container {
    width: 970px;
  }
}
@media (min-width: 1200px) {
  body .container {
    width: 1170px;
  }
}
.container{
	background:initial !important;
}
.feedDropDown {
display: none;
}
.feeditemActionMenu {
display: none;
}
.cxallfeedactions a span{
	display:none;
}
.btn-default {
	color: #fff !important;
	background-color: #ebebeb !important;
	border-color: #ccc !important;
	font-weight:normal;
}
.iconWithText span{
	font-weight:normal;
}
#publisherBottomBar{
	height:45px;
}
.publisherBottomBarPlaceholder{
	height:0;
}
.report-search-results .pbSubsection{
	max-height:786px !important;
	overflow-y:auto;
	width:525px;
}


.zen-select{
	display:none !important;
}
h1, h2, h3, h4, h5, h6{
	font-family: 'Open Sans', 'Helvetica Neue', Helvetica, Arial, sans-serif !important;
	display:block;
	font-size: initial !important;
}
body{
	font-family: 'Open Sans', 'Helvetica Neue', Helvetica, Arial, sans-serif !important;
	font-size:115% !important;
	color:#515151 !important;
}
ul li, ol li{
	list-style-type:none;
	margin:0;
	padding:0;
}
a:hover{
	text-decoration:none !important;
}
.btn, .button, .formulaButton, .btnWhatsNew, #publishersharebutton, .zen-btn{
	font-family: 'Open Sans', 'Helvetica Neue', Helvetica, Arial, sans-serif !important;
	background-image: none !important;
	border:none !important;
	font-size:initial !important;
	cursor: pointer !important;
	background-color: transparent;
	padding: 6px 12px !important;
	font-size: 12px !important;
	line-height: 1.42857 !important;
	vertical-align: middle !important;
	border-radius:5px;
}
.btn-primary, .btn-primary:focus, .btn-hover-primary:hover, .btn-hover-primary:active, .btn-hover-primary.active, .btn.btn-active-primary:active, .btn.btn-active-primary.active, .dropdown.open > .btn.btn-active-primary, .btn-group.open .dropdown-toggle.btn.btn-active-primary, #publishersharebutton, .zen-btn{
	background-color: #00b0e2 !important;
	border-color: #00b0e2 !important;;
	color: #ffffff !important;;
}
.btn-primary:hover, #publishersharebutton:hover, .zen-btn:hover{
	background-color:#00729d !important;
}
.publishertextarea{
	font-size: 12px;
	height: 100%;
	box-shadow: none;
	border: 1px solid #e9e9e9;
	transition-duration: .5s;
	display: block;
	width: 100%;
	height: 34px;
	padding: 6px 12px;
	font-size: 14px;
	line-height: 1.42857143;
	color: #555;
	background-color: #fff;
	background-image: none;
	border: 1px solid #ccc;
	border-radius: 4px;
	-webkit-box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
	box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
	-webkit-transition: border-color ease-in-out .15s,-webkit-box-shadow ease-in-out .15s;
	-o-transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
	transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
}
.publisherTextAreaInner{
	background-image: none !important;
	background-position: 0 0 !important;
	width: 0;
	height: 0;
	width: auto;
	height: auto;
	background-color: #fff;
	background-repeat: repeat-x;
	position: relative;
	border: 1px solid #e9e9e9 !important;
	padding: 0 !important;
	border-radius:0 !important;
}
.defaultState .publishertextarea{
	height: 30px !important;
}
.publishercontainer .bottomBar{
	border-color: #e9e9e9 !important;
	height:45px;
	border-radius:none !important;
}
.publishercontainer input[type="text"]{
	font-size: 12px;
	height: 100%;
	border-radius: 0 !important;
	box-shadow: none;
	border: 1px solid #e9e9e9;
	transition-duration: .5s;
	display: block;
	width: 102.8%;
	height: 34px;
	padding: 6px 12px;
	font-size: 14px;
	line-height: 1.42857143;
	color: #555;
	background-color: #fff;
	background-image: none;
	border: 1px solid #ccc;
	border-radius: 4px;
	-webkit-box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
	box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
	-webkit-transition: border-color ease-in-out .15s,-webkit-box-shadow ease-in-out .15s;
	-o-transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
	transition: border-color ease-in-out .15s,box-shadow ease-in-out .15s;
	border-color: #e9e9e9 !important;
	margin-bottom:5px;
}
.pArrow{
	background-image:('{!URLFOR($Resource.ECO_NiftyAssets, "ECO_NiftyAssets/img/carat-up.png")}') !important;
	margin-bottom:-1px !important;
	opacity:0.6;
}
.zen-inner{
	background-color: #fff;
	box-shadow: 0 0 10px;
}
.feedcontainer .feeditemcommentplaceholder input, .feedcontainer .feeditemcommentnew .foobar{
	border-radius: 0 !important;
}
.docViewerContainer{
	height:100%;
}
#docViewerOverlay{
	background-color:#fff;
}





/* RESPONSIVE SPECIFIC STYLES */
@media only screen and (max-width: 767px){
	.prefaceText{
		text-align:left;
	}
	.row.reports .apexp{
		margin-top:0;
	}
	.subnavbar .mainnav > li{
		border-bottom:1px solid #D6D6D6;
	}
}

@media (min-width:915px){
	.modal-open .modal-dialog{
		width:900px !important;
	}
}
