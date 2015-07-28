/* AECOM Ecosystem SmartSearch Styles */

/* - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - */
/* - - - - - - - - - - SEARCH LANDING PAGE STYLES - - - - - - - - - - */
/* - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - */
.CoveoErrorReport .coveo-options {
    display:none;
}

/* - - ECOSYSTEM FRAME HEADER SEARCH BOX/ICON STYLES - - */

.ecoFrameSearch .coveo-searchBox-column input[type="search"] {
    font-size: 12px;
    border-right: none;
    width: 80%;
    padding: 2px 5px;
}
.ecoFrameSearch .CoveoSearchButton {
    font-size: 14px;
    padding: 5px 10px;
    border: none;
    width: 20%;
    display: inline-block;
}
.ecoFrameSearch .CoveoSearchButton, .ecoFrameSearch .coveo-searchBox-column input[type="search"]  {
    margin-top: 11px;
    height: 30px;
}
.ecoFrameSearch .col-lg-3 {
    padding: 0 !important;
    max-width: 200px;
    margin-left: 10px;
}
.navbar-top-links > li[data-original-title="SmartSearch"] {
    display: none;
}
.navbar-top-links .coveo-SearchBox-column {
    float: right;
}
#newProjectModal .modal-dialog {
    width: 50% !important;
}
#newProjectModal .modal-dialog .modal-content {
    padding: 40px;
}
.pull-right .coveo-query-box-clear {
    display: none !important;
}

/* - - SEARCH BOX ROW STYLES - - */

.container.Search, .container.SearchResults {
    width: 100%;
    font-family: "Open Sans", Arial, sans-serif !important;
}
.container.SearchResults {
    padding-top: 0;
    padding-left: 230px;
}
.container.Search {
    padding-left: 230px;
    padding-top: 50px;
}
@media (max-width:767px){
    .container.Search {
        padding-left: 0;
        padding-top: 50px;
    }
}
.CoveoSearchInterface{
    font-family: "Open Sans", Arial, sans-serif;
}
.blueBlock {
    background-color: #02BCE5;
    padding: 20px 30px !important;
    min-height: 153px;
    max-height: 164px;
}
.blueBlock span.search{
    color: white;
}
.blueBlock h1 {
    color: #CCECF7;
    font-size: 24px !important;
    margin-top: 5px;
}
.blueBlock p {
    font-size: 14px;
    color: white;
    line-height: 1.7;
}

.searchRow {
    margin-bottom: 22px;
    background-color: white;
}
.coveo-searchBox-column input[type="search"] {
    border: 2px solid #e3e3e3;
    border-radius: 0;
    float: left;
    height: 50px;
    width: 100%;
    padding-left: 15px;
    font-size: 18px;
    color: #909090;
}

.searchBlock {
    padding: 0 !important;
    max-height: 164px;
}
.searchBar {
    margin: 50px 20px 0;
}
.searchBlock .searchBar.row div {
    padding: 0 !important;
}
.searchBar select {
    border: 2px solid #e3e3e3;
    color: #909090;
    font-size: 18px;
    height: 50px;
    background-color: transparent;
   -webkit-appearance: none;
   -moz-appearance: none;
   appearance: none;
    /*background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/ss_selectArrow.png");
    background-position: 93% 50%;
    background-repeat: no-repeat;
    MOVED THIS TO THE #scopeselector ID TO TARGET IT IN AN IFRAME */
    border-radius: 0;
    overflow: hidden;
    text-overflow: ellipsis;
    padding-right: 30px !important;
}
#scopeselector {
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/ss_selectArrow.png");
    background-position: 93% 50%;
    background-repeat: no-repeat;
}
/* IE10+ STYLE */
@media screen and (-ms-high-contrast: active), (-ms-high-contrast: none) {  
   #scopeselector {
    background-image: none;
    }
    .searchBar select {
        padding-right: 0 !important;
    }
}
/* IE9, IE10 STYLE */
@media screen and (min-width:0\0) { 
    #scopeselector {
    background-image: none;
    }
    .searchBar select {
        padding-right: 0 !important;
    }
}
.ie8or9 .searchBar select {
    background-image:none;
    padding-right: 0 !important;
}

.searchBlock .CoveoSearchBox {
    border: 2px solid #e3e3e3;
    height: 50px;
    width: 100%;
    padding-left: 10px;
    font-size: 16px;
    border-radius: 0 !important;
}
.searchBar .searchBtn, .CoveoSearchButton {
    background-color: #59ba47;
    color: white;
    display: table-cell;
    font-size: 21px;
    font-weight: bold;
   /* height: 50px;*/
    padding:0 18px ;
    text-align: center;
    text-transform: uppercase;
    border: 2px solid #e3e3e3;
    border-left: none;
    border-radius: 0;
    cursor: pointer;
}
.searchBar .searchBtn #CoveoSearchButton {
    height: 50px;
}
.CoveoSearchButton:hover {
    background: #59ba47;
}
.CoveoSearchInterface .coveo-tab-section.col-lg-3 {
    width: 25%;
    background-color: white;
    border-top: 2px solid #e3e3e3;
    border-bottom: 2px solid #e3e3e3;
    border-left: 2px solid #e3e3e3;
    height: 50px;
}
.CoveoSearchInterface .coveo-search-section.col-lg-9 {
    width: 75%;
}
.CoveoTabGroupMenu {
    width: 100%;
}
.CoveoTabGroupMenu a {
    color: #7f7f7f !important;
    display: block;
    font-size: 16px;
    font-weight: normal !important;
    line-height: 30px;
}
.CoveoSearchBox .CoveoQueryBox {
    border: none;
    border-radius: 0 !important;
    color: #7f7f7f !important;
}
.CoveoTabGroupMenu .coveo-menu-item-active {
    text-align: left;
    padding: 8px 10px;
}
.CoveoTabGroupMenu .coveo-menu-item-active > .coveo-icon {
    left: 80px;
}
.CoveoTabGroupMenu .coveo-menu-open .coveo-menu-item-active {
    background: white;
}
.CoveoTabGroupMenu .coveo-menu-item-container a:hover {
    background: #01729E;
    color: white;
}
.CoveoTabGroupMenu .coveo-menu-item-container {
    border: 2px solid #e3e3e3;
}
.coveo-query-box-clear {
    margin-top: -31px;
}

/* - - TYPE AHEAD STYLES - - */

input.CoveoQueryBox::-ms-clear {
    display: none;
/* gets rid of double x in search box when typing ahead */
}
/* IE10+ STYLE */
@media screen and (-ms-high-contrast: active), (-ms-high-contrast: none) {  
    input.CoveoQueryBox::-ms-clear {
    display: none;
    /* gets rid of double x in search box when typing ahead */
    }
}
/* IE9, IE10 STYLE */
@media screen and (min-width:0\0) { 
    input.CoveoQueryBox::-ms-clear {
    display: none;
    /* gets rid of double x in search box when typing ahead */
    }
}

.coveo-omnibox {
    border: 2px solid #e3e3e3;
    border-top: none;
    border-radius: 0;
    margin-top: 50px;
}
.coveo-omnibox .coveo-text, .coveo-omnibox .coveo-omnibox-selectable {
    font-family: "Open Sans","Helvetica Neue",Helvetica,Arial,sans-serif !important;
    font-size: 13px;
}
.coveo-omnibox .coveo-text {
    color: #59BA47;
}
.coveo-omnibox .coveo-omnibox-selectable {
    color: #00729D;
}
.coveo-omnibox .coveo-omnibox-section {
    margin-left: 10px;
}
.coveo-omnibox .coveo-caption {
    font-size: 15px;
    color: #808080;
    line-height: 15px;
    display: block;
    padding: 5px;
}
.coveo-omnibox .coveo-omnibox-selected {
    background-color: #E7EBEE;
}
.coveo-top-suggestion-header, .coveo-top-field-suggestion-header, .coveo-top-analytics-suggestion-header, 
.coveo-omnibox-result-list-header {
    background-color: #e3e3e3;
    margin-left: -10px;
}
.coveo-top-field-suggestion-header span.coveo-icon-top-field {
    display: none;
}

/* - - MODULE SECTION STYLES - - */

.searchModules {
    margin-left: -27px;
    margin-right: -27px;
}
.searchModules .col-lg-1, .searchModules .col-md-1 {
    width: 2.2%;
    /* lowers width of seperator column */
}
.row.sectBody {
    margin: 0 0 20px 0 !important;
}
.row.sectHead {
    background-color: #4d5256;
    color: white;
    text-transform: uppercase;
    margin: 0 !important;
}
.sectHead h2 {
    font-size: 20px !important;
    margin: 15px 0 15px 14px;
}

.sectBody {
    padding: 20px;
    background-color: white;
}
.subModules .sectBody, .mainModule .sectBody {
    margin-bottom: 20px;
}
.sectFilter {
    margin-top: 20px;
}
.CoveoErrorReport[data-pop-up="false"] {
    display: none;
    /* hides gray box that appears when no results found */
}
.resultsModules .CoveoResult .resultDetail {
    padding: 0;
}
.resultsModules.recentViewLinks .CoveoResult {
    border-bottom: none;
    padding: 5px 15px;
}
.resultsModules.recentViewLinks .CoveoResult:first-child {
    padding: 0px 20px 5px 15px;
}
.resultsModules.recentViewLinks .CoveoResult .coveo-title {
    font-size: 14px !important;
    line-height: 19px !important;
}
.Search .CoveoResult:first-child {
    padding-top: 0;
}
.coveo-show-if-no-results {
    color: #515151;
    font-family: "Open Sans", Arial, sans-serif;
    font-size: 12px;
    padding: 0 20px 20px;
}

/* - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - */
/* - - - - - - - - - - SEARCH RESULTS STYLES - - - - - - - - - - */
/* - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - */

@media only screen 
  and (min-device-width: 320px) 
  and (max-device-width: 568px)
  and (-webkit-min-device-pixel-ratio: 2) {
    .resultsModules, .resultTotal {
        width: 100%;
        /* fixes result width issue on iOS 7 & 8.3 */
    }
}
/* - - - - FILTER STYLES - - - - */

/* - CLEAR-ALL-FILTER STYLES - */
.CoveoBreadcrumb {
    margin: 0 0 20px;
    word-wrap: break-word;
}
.CoveoBreadcrumb .coveo-clear-all {
    background-color: #fff;
}
.CoveoBreadcrumb .coveo-separator {
    color: #515151;
}
.CoveoBreadcrumb .coveo-caption {
    color: #00729d;
}
.coveo-facet-breadcrumb .coveo-values .coveo-value .coveo-clear {
    margin: 4px 2px 0 5px;
}
.coveo-facet-breadcrumb .coveo-values .coveo-value:hover .coveo-clear {
    color: #02BCE5;
}
.CoveoBreadcrumb .item {
    overflow: visible;
    white-space: normal;
    text-overflow: initial;
    word-break: break-word;
}
.coveo-facet-breadcrumb .coveo-values .coveo-value .coveo-multi-icon.coveo-selected {
    background-position: -439px -83px;
    height: 15px;
}

.CoveoSearchInterface {
    background-color: transparent;
}

/* - SEARCH RESULT AMOUNT STYLES - */
.resultTotal {
    font-size: 20px;
    margin-bottom: 10px;
    margin-left: 0 !important;
}
.resultTotal span {
    font-size: 20px;
    font-weight: normal;
}

/* - FACET STYLES - */
.coveo-settings, .coveo-icon.syssource, .coveo-icon.sfaccountname, .coveo-icon.objecttype, 
.coveo-icon.sysfiletype, .coveo-icon.sfownername, .coveo-icon.sfopportunitystagename,
.coveo-icon.sysyear, .coveo-icon.sysmonth, .coveo-icon.sysconcepts, .coveo-icon.sfaccounttype {
    display: none !important;
    /* hide icons in the header of the facets */
}
.coveo-results-header .CoveoQuerySummary, .CoveoPager, .resultsColumnFooter .CoveoQuerySummary {
    float: right;
}
.coveo-results-column {
    background: white;
    /*padding: 25px;*/
}

.coveo-footer {
    border-top: 1px solid #cccccc;
    padding-top: 5px;
    text-align: center;
    text-transform: uppercase;
    margin-top: 15px;
}
.resultsColumnFooter {
    margin-top: 15px;
}
.CoveoResult .coveo-icon {
    display: block;
}
.resultImg img {
    border: 2px solid #e3e3e3;
    margin-top: 5%;
    max-height: 100px;
    max-width: 150px;
    min-height: 64px;
    min-width: 64px;
}


/* - - NO RESULTS/DID YOU MEAN STYLES - - */

.CoveoQuerySummary .coveo-cancel-last {
   /* background-color: #59ba47;
    color: white;
    padding: 8px 10px;
    width: 124px;
    float: left;
    margin-left: 4%;*/
    display: none;
}
.CoveoQuerySummary .coveo-no-results-string {
    /*float: left;
    font-size: 20px;*/
    display: none;
}
.CoveoQuerySummary .coveo-search-tips-info {
    float: left;
    clear: left;
    font-size: 14px;
    font-weight: bold;
}
.CoveoQuerySummary ul {
    float: left;
    padding-left: 20px;
}
.CoveoQuerySummary .coveo-search-tips-info, .CoveoQuerySummary ul {
    margin-top: 15px;
}
.CoveoQuerySummary ul li {
    font-size: 13px;
    font-style: italic;
    line-height: 22px;
    list-style: disc;
}
.CoveoSearchInterface .CoveoDidYouMean {
    background-color: transparent;
    color: #666;
    padding: 0;
    font-size: 25px;
    font-style: italic;
}
.CoveoSearchInterface .CoveoDidYouMean .coveo-highlight, .coveo-hightlight .coveo-word-correction {
    color: #02BCE5;
    font-size: 18px;
}
/*.CoveoSearchInterface .CoveoDidYouMean .coveo-no-results-for {
    display: none;
}*/

/* - - SORTING/PAGINATION STYLES - - */

.CoveoQuerySummary .coveo-highlight {
    font-weight: normal;
}
.coveo-next a:hover, .coveo-next a > span:hover, .coveo-previous a:hover, .coveo-previous a > span:hover  {
    border: none !important;
    background-color: transparent !important;
}
.coveo-next a > span[title="Next"], .CoveoPager ul li.coveo-next > a > span {
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/ss_nextArrow.png") !important;
    background-size: 11px 11px;
    background-position: 0 0;
}
.coveo-previous a > span[title="Previous"], .CoveoPager ul li.coveo-previous > a > span {
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/ss_lastArrow.png") !important;
    background-size: 11px 11px;
    background-position: 0 0;
}
.coveo-sort-section {
    text-align: left;
    float: left;
}
.coveo-next, .coveo-previous {
    background: none !important;
}
.coveo-sort-section, .resultsSpacer {
    height: 32px;
    display: block;
}
.CoveoSort {
    padding-left: 0;
}
.CoveoSort.coveo-selected {
    color: #909090;
}
.coveo-footer .coveo-more.coveo-active {
    color: #00759f;
}
.CoveoPager {
    margin: 0 0 0 7px;
}
.CoveoPager li {
    height: 22px;
}
.CoveoPager li.coveo-active {
    background: #c01b83;
}
.CoveoPager ul li.coveo-active > a {
    border: none;
}
.CoveoPager ul li.coveo-active:first-child > a, .CoveoPager ul li > a {
    border: none;
}
/*.CoveoPager ul li > a {
    background: ;
}*/
.CoveoPager ul li {
    background: #D4D8DB;
    padding: 3px 0;
    margin: 0 1px;
}
.CoveoPager ul li > a {
    height: 0;
    min-width: 20px;
    padding: 0;

}

/* - - - - RESULTS STYLES - - - */

.CoveoResult {
    display: table;
    width: 100%;
    margin: 0;
    padding: 20px;
    font-family: "Open Sans","Helvetica Neue",Helvetica,Arial,sans-serif !important;
    border-bottom: 1px solid rgba(0, 0, 0, 0.1);
}
.CoveoResult:last-child {
    border: none;
}
.CoveoResult .coveo-title {
    font-weight: bold;
    max-width: 820px;
}
.CoveoResult a:hover {
    color: #02BCE5;
}
.CoveoResult a:visited {
    color: #00729D;
}
.CoveoResultList {
    /*padding: 20px;*/
    margin-top: 0;
}
.CoveoResultLink:link {
    color: #00709D;
}
.CoveoResult .coveo-title .CoveoResultLink {
    word-break: break-word;
}
/*.CoveoResult .coveo-title .CoveoResultLink {
    display: block;
    overflow: hidden;
   text-overflow: ellipsis;
    white-space: nowrap;
}*/
.resultDetail {
    font-size: 12px;
}
.resultDescription, .VPNerror {
    /*height: 50px;*/
    text-overflow: ellipsis;
    overflow: hidden;
    font-size: 12px !important;
    color: #515151;
    line-height: 19px;
}
.VPNerror {
    font-style: italic;
}
.resultDetail span {
    line-height: 20px;
}
.resultDetail span.userTitle {
    font-weight: normal;
    font-size: 12px;
}
.resultDetail span.phoneType {
    color: #a1a1a1;
}
.resultDetail span.country, .resultDetail span.modifiedDate, 
.resultDetail .repositoryType, .resultDetail span.businessLine,
.resultDetail span.region, .resultDetail span.TPNuser, .resultDetail span.user,
.resultDetail span.group {
    font-size: 11px;
    line-height: 19px;
    color: #aaa;
}
.resultDetail .repositoryType, .infoBlock {
    margin-top: 10px;
    line-height: 19px;
}
.resultDetail span.email a {
    color: #00B0E2;
}
.resultDetail span.email a:hover {
    color: #00709D;
}
.resultDetail div {
    /*max-width: 70%;*/
    word-wrap: break-word;

    /* ADD IF LINK TO RESULT IS APPROVED (MAKE OWN STYLE)
    /*height: 21px;
    overflow: hidden;
    table-layout: fixed;
    text-overflow: ellipsis;
    width: 100%;
    word-wrap: break-word;*/
}
.resultDetail .PMdetails {
    font-size: 12px;
    margin-top: 10px;
}
.CoveoFieldTable.table {
    margin-bottom: 0;
    margin-top: 10px;
}
.CoveoFieldTable td, .CoveoFieldTable th {
    font-size: 13px !important;
    border: none !important;
    vertical-align: middle !important;
}
.resultDetail table th.CoveoCaption {
    border-bottom: 1px solid #e3e3e3;
}
.chatterDesc {
    word-wrap: break-word;
    width: 100%;
    display: table;
    table-layout: fixed;
}

/* - - - OPPORTUNITY STYLES - - - */

.CoveoFieldTable th.CoveoCaption {
    color: #4d5256 !important;
    font-size: 11px !important;
    font-weight: bold;
}
.CoveoFieldTable td.CoveoFieldValue {
    font-size: 11px !important;
    color: #515151 !important;
}
.oppInfo {
    background-color: #e9e9e9 !important;
}
.leadInfo{
    background-color: #d6d6d6 !important;
}
.groupInfo {
    background-color: #bebebe !important;
}

/* - - - TaaS RATING STARS STYLES - - - */
.ratingInt {
    display: inline;
    float: left;
    margin-left: 10px;
    margin-top: -2px;
    vertical-align: middle;
}
.rating {
    display: block;
    width: 85px;
    height: 16px;
    background-repeat: no-repeat;
    float: left;
}
.rating[title="0"] {
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/TaaSstars/TaaSstars_none.png");
}
.rating[title="1"] {
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/TaaSstars/TaaSstars_one.png");
}
.rating[title="2"] {
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/TaaSstars/TaaSstars_two.png");
}
.rating[title="3"] {
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/TaaSstars/TaaSstars_three.png");
}
.rating[title="4"] {
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/TaaSstars/TaaSstars_four.png");
}
.rating[title="5"] {
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/TaaSstars/TaaSstars_five.png");
}

/* - - - DOCUMENT TYPE ICON STYLES - - - */

table.documentTable td div {
    height: 50px;
    width: 40px;
    background-size: 40px;
    margin-right: 8px;
    background-repeat: no-repeat;
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/filetype/generic.png");
}
table.documentTable div.doc {
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/filetype/filetype_doc.png");
}
table.documentTable div.html {
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/filetype/filetype_web.png");
}
table.documentTable div.xls, table.documentTable div.xlsx {
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/filetype/filetype_excel.png");
}
table.documentTable td div.ppt {
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/filetype/filetype_ppt.png");
}
table.documentTable td div.rtf, table.documentTable td div.txt {
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/filetype/filetype_txt.png");
}
table.documentTable td div.msg {
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/filetype/filetype_eml.png");
}
table.documentTable td div.pdf {
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/filetype/filetype_pdf.png");
}
table.documentTable td div.zip {
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/filetype/filetype_zip.png");
}
table.documentTable td div.wav {
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/filetype/filetype_wav.png");
}
table.documentTable td div.exe {
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/filetype/filetype_exe.png");
}
table.documentTable td div.swf, table.documentTable td div.mp4 {
/* video files */
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/filetype/filetype_vid.png");
}
table.documentTable td div.vsd, table.documentTable td div.jpg, table.documentTable td div.png, table.documentTable td div.Image {
/* image files */
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/filetype/filetype_img.png");
}
/* TO HIDE ICON ON DEFAULT TEMPLATE FOR SHAREPOINT SEARCH RESULTS - DONT NEED THIS AFTER TEMPLATE FOR RESULT IS BUILT 
.documentTable.repositoryType div[class=""], .documentTable.repositoryType div[class="sppublishingpageslibrarylist"],
.documentTable.repositoryType div[class="spsite"], .documentTable.repositoryType div[class="spdocumentlibrarylist"], 
.documentTable.repositoryType div[class="sppublishingimageslibrarylist"], .documentTable.repositoryType div[class="spuserprofile"]
 {
    display: none;
}*/

/* - - - OPPORTUNITY STAGE ICON STYLES - - - */

.oppStage {
    height: 30px;
    width: 30px;
    padding: 15px !important;
}

.oppStage[title="1 Lead"]{
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/oppStage/oppStage_one.png");

}
.oppStage[title="1A Lead - Scout"] {
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/oppStage/oppStage_one.png");
}
.oppStage[title="1B Lead - Engage"] {
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/oppStage/oppStage_one.png");
}
.oppStage[title="1C Lead - Position"] {
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/oppStage/oppStage_one.png");
}

.oppStage[title="2 Capture"] {
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/oppStage/oppStage_two.png");
}
.oppStage[title="2A Capture - LOI"] {
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/oppStage/oppStage_two.png");
}
.oppStage[title="2B Capture - EOI"] {
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/oppStage/oppStage_two.png");
}
.oppStage[title="2C Capture - SOQ"] {
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/oppStage/oppStage_two.png");
}
.oppStage[title="2D Capture - RFI"] {
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/oppStage/oppStage_two.png");
}
.oppStage[title="2E Capture - RFP"] {
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/oppStage/oppStage_two.png");
}

.oppStage[title="3 Submitted"] {
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/oppStage/oppStage_three.png");
}
.oppStage[title="3A Capture - Proposal Submitted"] {
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/oppStage/oppStage_three.png");
}
.oppStage[title="3B Capture - Short List"] {
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/oppStage/oppStage_three.png");
}
.oppStage[title="3C Capture - Interview"] {
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/oppStage/oppStage_three.png");
}

.oppStage[title="4 Project on hold"] {
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/oppStage/oppStage_four.png");
}

.oppStage[title="5A Program in Negotiation"] {
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/oppStage/oppStage_five.png");
}
.oppStage[title="5B Program Signed and Active"] {
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/oppStage/oppStage_five.png");
}
.oppStage[title="5 SNB/Win/Award"] {
   background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/oppStage/oppStage_five.png");
}



.oppStage[title="6A Program Closed/Completed"] {
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/oppStage/oppStage_six.png");
}
.oppStage[title="6 Contracted/Booked/Won"] {
     background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/oppStage/oppStage_six.png");
}

.oppStage[title="7 Canceled by Client"] {
     background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/oppStage/oppStage_seven.png");
}

.oppStage[title="8 No-Go"] {
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/oppStage/oppStage_eight.png");
}

.oppStage[title="9 Lost"] {
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/oppStage/oppStage_lost.png");
}


/* - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - */
/* - - - - - - - - - - SEARCH FACET STYLES - - - - - - - - - - - */
/* - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - */

/* Fix for Sanchivan's screen (All Extra Large Screens?) */
.CoveoFacet .coveo-label .coveo-caption {
    text-overflow: initial  !important;
}
/*.coveo-search, .coveo-search .coveo-magnifier, .coveo-search .coveo-clear, .coveo-search .coveo-middle, .coveo-middle input {
    display: none !important;
    color: #E7EBEE !important;
    /* hide search in facets 
}*/
.CoveoFacet {
    margin-bottom: 20px;
    border: none;
}
.CoveoFacet .coveo-header, .CoveoFacetRange .coveo-header {
    background-color: #4d5256;
    padding: 10px;
    margin-bottom: 15px;
}
.CoveoFacet .coveo-title, .CoveoFacetRange .coveo-title {
    color: white !important;
    font-size: 17px;
}
.coveo-title br {
    line-height: 0;
}

/* DATE SLIDER STYLES */

.coveo-slider-button::after {
    border-left: 1px solid #C3C7CA;
    border-right: 1px solid #C3C7CA;
    height: 9px;
}
.coveo-slider-button::before {
    border-right: 1px solid #C3C7CA;
}

.CoveoFacetRange.coveo-disabled .coveo-slider-button, .coveo-slider-button {
    background-color: white;
    border: 1px solid #C3C7CA;
}
.coveo-slider-line.coveo-active {
    background-color: #02B0E2;
}
.coveo-slider-line {
    background-color: #C3C7CA;
    border-radius: 1px;
}
.coveo-slider-caption {
    left: 25%;
}
.coveo-value.coveo-selectable.coveo-selected label {
    background-color: #00b0e2;
}
.coveo-value.coveo-selectable.coveo-selected label .coveo-label .coveo-caption, .coveo-value.coveo-selectable.coveo-selected label .coveo-label .coveo-count {
    color: white;
    font-weight: normal;
}


/* - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - */
/* - - - - - - - - - - MEDIA QUERIES - - - - - - - - - - - - - - */
/* - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - */
/* searchbar in header */
@media (min-width: 1022px) and (max-width: 1232px){
    .ecoFrameSearch .coveo-searchBox-column input[type="search"] {
        width: 120px;
    }
    .ecoFrameSearch .CoveoSearchButton {
        padding: 5px 7px;
        font-size: 13px;
    }
}
@media (max-width: 1021px){
    .ecoFrameSearch .coveo-searchBox-column input[type="search"] {
        display: none;
    }
    .ecoFrameSearch .CoveoSearchButton {
        display:none;
    }
      .navbar-top-links > li[data-original-title="SmartSearch"] {
        display: block;
    }
}

@media (max-width: 970px){
    .navbar-top-links > li[data-original-title="SmartSearch"] .menuText {
        display: none;
    }
}


/* TARGET LG SIZE */
@media (min-width: 1200px) {

}

/* SMALLER THAN LG */
@media (max-width:1200px){
    
}

/* TARGET MD SIZE */
@media (min-width: 992px) and (max-width: 1200px) {
    .ecoFrameSearch .col-lg-3 {
        max-width: 155px;
    }
    .ecoFrameSearch .CoveoSearchButton {
        padding: 5px 7px;
        font-size: 13px;
    }
    .searchBar {
        margin: 50px 20px 0;
    }
}

/* SMALLER THAN MD */
@media (max-width:992px){
    .searchBar {
        margin: 20px 8%;
    }
    .searchBar select {
        width: 100%;
    }
    .searchBar .searchBtn, .CoveoSearchButton {
        display: block;
        width: 100%;
        padding: 10px 2%;
    }
    .resultImg img {
        margin-top: 15px;
    }
   
    .container {
        padding-left: 0;
        padding-right: 0;
    }
    
    .container.Search, .container.SearchResults {
        padding-left: 75px;
    }
}

/* TARGET SM SIZE */
@media (min-width: 768px) and (max-width: 992px) {
    .searchBar .searchBtn, .CoveoSearchButton {
        font-size: 21px;
    }

}

/* TARGET XS SIZE */
@media (max-width: 766px) {
    .searchBar .searchBtn, .CoveoSearchButton {
        font-size: 16px;
    }
    .blueBlock {
        max-height: 100%;
    }
    .container.Search, .container.SearchResults {
        padding-left: 5px;
    }
   
}
