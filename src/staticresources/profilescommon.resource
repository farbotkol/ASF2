body {
    font-size: 12px;
}

label {
    color: #333435;
    font-weight: normal;
    font-size: 1em;
}

.panel-default>.panel-heading {
    background-color: white;
    font-family: Arial,Helvetica,sans-serif;
    font-size: 12px;
} 

.panel-title {
    font-size: 13px;
    font-weight: bold;
}

.panel-heading {
    padding: 0px 0px; 
    padding-bottom: 2px;
}

.panel {
    border-color: white;
    -webkit-box-shadow: 0 0 0 rgba(0,0,0,);
    box-shadow: 0 0px 0px rgba(0,0,0,.0); 
}

.ui-state-focus {
    outline: none;
    color: black;
}
  

th {
    white-space : normal;
}

body button, body .btn {
    display: inline-block;
    /*padding: 6px 12px;*/
    margin-bottom: 0;
    line-height: 1.42857143;
    text-align: center;
    white-space: nowrap;
    vertical-align: middle;
    cursor: pointer;
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
    background-image: none;
    /*border: 1px solid transparent;*/
    border-radius: 4px;
    background: white;
}

li {
    margin-left : 0px !important;
}

#nav {
    width: 749px;
    float: left;
    margin: 0 0 1em 0;
    padding: 0px;
    list-style: none;
    background-color: white;
    border-top: 0px solid white;
    margin-bottom: 20px;
}

#nav li {
    float: left;
    padding-top: 28px;
}

#nav li a {
    display: block;
    text-decoration: none;
    font-size: 12px;
    font-weight: bold;
    padding-left: 0px;
}

#nav li a:hover {
    text-decoration: underline; /* changed from text:decoration:none */
}

.componentHeader {
    border-bottom: 1px solid lightgray;
    padding: 2px 2px 2px 2px;
    width: 100%;
    overflow:hidden;
}
    
:focus {
    outline: none;
}

.ui-tabs .ui-state-disabled {
    display: none; /* disabled tabs don't show up */
}

.ui-state-active {
    font-weight: bold;
    outline: none;
    color: black !important;
}

.ui-state-default {
    color: #015BA7;
}

.center{
    text-align: center;
}

ul[role="alert"]{
    list-style: none;
}

.toggleClassUp {
    display: none;
}

.toggleClassDown {
    display: none;
}

.rsRequiredBlock {
    background-color: #c00;
    width: 3px;
    position: absolute;
    left: -5px;
    top: 1px;
    bottom: 1px;
    display: block;
}

.rsRequired {
    position: relative;
    height: 100%;
    display: block;
}

.rsError {
    display: none;
    color: #c00;
}

.invalid {
    border: 2px solid #c00;
}

.valid {
    border: 2px solid green;
}

label {
    margin-bottom: 0px;
}

.spinner {
    display: inline-block;
    opacity: 0;
    max-width: 0;
}

.has-spinner.active {
    cursor:progress;
}

.has-spinner.active .spinner {
    opacity: 1;
    max-width: 50px; /* More than it will ever come, notice that this affects on animation duration */
}

 /* We need to have standard style sheets enabled for lookups to appear, so we override the salesforce button styling */
.sfbtnOverrideGreen {
    color:#fff !important;
    background-color:#5cb85c !important;
    background:#5cb85c !important;
    border-color:#4cae4c !important;
    padding:5px 10px !important;
    font-weight:400 !important;
}
.sfbtnOverrideRed {
    color:#fff !important;
    background-color:#d9534f !important;
    background:#d9534f !important;
    border-color:#d43f3a !important;
    padding:5px 10px !important;
    font-weight:400 !important;
}
.sfbtnOverrideBlue {
    color:#fff !important;
    background-color:#428bca !important;
    background:#428bca !important;
    border-color:#357ebd !important;
    padding:5px 10px !important;
    font-weight:400 !important;
}

.table-condensed th,
.table-condensed td {
    padding: 4px 5px;
}

.table {
    margin-bottom: 0px;
}

.list-group-item-text td {
    padding: 1px;
}


label {
  color: #333435;
  font-weight: normal;
  font-size: 1em;
}

.panel-default>.panel-heading {
    background-color: white;
    font-family: Arial,Helvetica,sans-serif;
    font-size: 12px;
} 

.panel-title {
    font-size: 13px;
    font-weight: bold;
}

.panel-heading {
  padding: 0px 0px; 
  padding-bottom: 2px;
}

.panel {
   border-color: white;
    -webkit-box-shadow: 0 0 0 rgba(0,0,0,);
    box-shadow: 0 0px 0px rgba(0,0,0,.0); 
}

.ui-state-focus {
    outline: none;
}


#nav li a:focus {
  color:#393939;
  outline: none;
}  

th {
    white-space : normal;

}

body button, body .btn {

    display: inline-block;
    /*padding: 6px 12px;*/
    margin-bottom: 0;
    line-height: 1.42857143;
    text-align: center;
    white-space: nowrap;
    vertical-align: middle;
    cursor: pointer;
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
    background-image: none;
    /*border: 1px solid transparent;*/
    border-radius: 4px;
    background: white;
}

li {
    margin-left : 0px !important;
}

#nav {
width: 749px;
float: left;
margin: 0 0 1em 0;
padding: 0px;
list-style: none;
background-color: white;
border-top: 0px solid white;
margin-bottom: 20px;
}
#nav li {
float: left;
padding-top:28px;

}
/*
#nav li a {
display: block;
color: #015BA7;
text-decoration: none;
font-size: 13px;
font-weight: bold;
padding-left: 0px;
}*/

#nav li a:hover {
text-decoration: underline; /* changed from text:decoration:none */
}

.componentHeader {
    border-bottom: 1px solid lightgray;
    padding: 2px 2px 2px 2px;
    width: 100%;
    overflow:hidden;
}
    
:focus {
    outline: none;
}
.ui-tabs .ui-state-disabled {
    display: none; /* disabled tabs don't show up */
}
.ui-state-active {
    font-weight: bold;
    outline: none;
}
.center{
text-align: center;
}
ul[role="alert"]{
list-style: none;
}
.toggleClassUp {
display: none;
}
.toggleClassDown {
display: none;
}

.rsRequiredBlock {
    background-color: #c00;
    width: 3px;
    position: absolute;
    left: -5px;
    top: 1px;
    bottom: 1px;
    display: block;
}

.rsRequired {
    position: relative;
    height: 100%;
    display: block;
}

.rsError {
  display: none;
  color: #c00;
}

.invalid {
  border: 2px solid #c00;
}
.valid {
  border: 2px solid green;
}
label {
  margin-bottom: 0px;
}

.spinner {
  display: inline-block;
  opacity: 0;
  max-width: 0;
}
.has-spinner.active {
  cursor:progress;
}
.has-spinner.active .spinner {
  opacity: 1;
  max-width: 50px; /* More than it will ever come, notice that this affects on animation duration */
}

 /* We need to have standard style sheets enabled for lookups to appear, so we override the salesforce button styling */
.sfbtnOverrideGreen {
  color:#fff !important;
  background-color:#5cb85c !important;
  background:#5cb85c !important;
  border-color:#4cae4c !important;
  padding:5px 10px !important;
  font-weight:400 !important;
}
.sfbtnOverrideRed {
  color:#fff !important;
  background-color:#d9534f !important;
  background:#d9534f !important;
  border-color:#d43f3a !important;
  padding:5px 10px !important;
  font-weight:400 !important;
}
.sfbtnOverrideBlue {
  color:#fff !important;
  background-color:#428bca !important;
  background:#428bca !important;
  border-color:#357ebd !important;
  padding:5px 10px !important;
  font-weight:400 !important;
}

.sfbtnOverrideDefault {
    color: #222;
    border-width: 1px !important;
    border-top-width: 1px !important;
    border-right-width-value: 1px !important;
    border-bottom-width: 1px !important;
    border-left-width-value: 1px !important;
    border-left-width-ltr-source: physical !important;
    border-left-width-rtl-source: physical !important;
    border-right-width-ltr-source: physical !important;
    border-right-width-rtl-source: physical !important;
    border-style: solid !important;
    border-top-style: solid !important;
    border-right-style-value: solid !important;
    border-bottom-style: solid !important;
    border-left-style-value: solid !important;
    border-left-style-ltr-source: physical !important;
    border-left-style-rtl-source: physical !important;
    border-right-style-ltr-source: physical !important;
    border-right-style-rtl-source: physical !important;
    -moz-border-top-colors: none !important;
    -moz-border-right-colors: none !important;
    -moz-border-bottom-colors: none !important;
    -moz-border-left-colors: none !important;
    border-image: none !important;
    border-image-source: none !important;
    border-image-slice: 100% 100% 100% 100% !important;
    border-image-width: 1 1 1 1 !important;
    border-image-outset: 0 0 0 0 !important;
    border-image-repeat: stretch stretch !important;
    border-color: #C3C3C3 #AAA #909090 !important;
    border-top-color: #C3C3C3 !important;
    border-right-color-value: rgb(170, 170, 170) !important;
    border-bottom-color: #909090 !important;
    border-left-color-value: rgb(170, 170, 170) !important;
    border-left-color-ltr-source: physical !important;
    border-left-color-rtl-source: physical !important;
    border-right-color-ltr-source: physical !important;
    border-right-color-rtl-source: physical !important;
    padding:5px 10px !important;
}

.table-condensed th,
.table-condensed td {
  padding: 4px 5px;
}

.ui-state-default {
    color: #015BA7;
}

.ui-tabs-anchor {
    color: inherit;

}

.ui-tabs-active {
    color: #333435;
}

.ui-state-active {
    color: #333435 !important;
}

a {
    color: #015BA7;
}
.calculatedLabel {
    font-style: italic;
    opacity: 0.75
}

.wrench {
    padding: 2px 3px 3px 2px;
}


