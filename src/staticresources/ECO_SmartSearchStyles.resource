/* AECOM Ecosystem SmartSearch Styles */

/* - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - */
/* - - - - - - - - - - SEARCH LANDING PAGE STYLES - - - - - - - - - - */
/* - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - - */

/* - - SEARCH BOX ROW STYLES - - */

.container.Search, .container.SearchResults {
    width: 100%;
}
.blueBlock {
    background-color: #02BCE5;
    padding: 20px 30px !important;
    min-height: 153px;
}
.blueBlock span.smart {
    color: #CCECF7;
    text-transform: initial;
}
.blueBlock h1 {
    color: white;
    font-size: 24px !important;
    text-transform: uppercase;
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
    font-size; 18px;
    color: #909090;
}

.searchBlock {
    padding: 0 !important;
}
.searchBar {
    margin: 5% 20px;
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
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/ss_selectArrow.png");
    background-position: 93% 50%;
    background-repeat: no-repeat;
    border-radius: 0;
    overflow: hidden;
    text-overflow: ellipsis;
}

/*target Internet Explorer 9 and Internet Explorer 10:*/
@media screen and (min-width:0\0) { 
    .searchBar select {
        background:none;
        padding-right: 0 !important;
    }
    .searchBar {
        margin: 3.5% 20px 0;
}
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
    height: 50px;
    padding:0 18px ;
    text-align: center;
    text-transform: uppercase;
    border: 2px solid #e3e3e3;
    border-left: none;
    border-radius: 0;
    cursor: pointer;
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
.coveo-top-suggestion-header, .coveo-top-field-suggestion-header, .coveo-top-analytics-suggestion-header, .coveo-omnibox-result-list-header {
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
    margin: 20px 0 20px 20px;
}
.subModules {

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

/* - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - */
/* - - - - - - - - - - SEARCH RESULTS STYLES - - - - - - - - - - */
/* - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - */
@media only screen 
  and (min-device-width: 320px) 
  and (max-device-width: 568px)
  and (-webkit-min-device-pixel-ratio: 2) {
    .resultsModules, .resultTotal {
        width: 100%;
        /* fixes width issue on iOS 7 & 8.3 */
    }
}

.CoveoSearchInterface {
    background-color: transparent;
}
.resultTotal {
    font-size: 20px;
    margin-bottom: 10px;
}
.resultTotal span {
    font-size: 20px;
    font-weight: normal;
}
.coveo-settings, .coveo-icon.syssource, .coveo-icon.sfaccountname, .coveo-icon.objecttype, 
.coveo-icon.sysfiletype, .coveo-icon.sfownername, .coveo-icon.sfopportunitystagename,
.coveo-icon.sysyear, .coveo-icon.sysmonth, .coveo-icon.sysconcepts {
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
@media (max-width:987px) {
    .resultImg img {
        margin-top: 15px;
    }
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

/* - - - - - - - - - - RESULTS STYLES - - - - - - - - - - */

.CoveoResult {
    display: table;
    width: 100%;
    margin: 0;
    padding: 20px;
    font-family: "Open Sans","Helvetica Neue",Helvetica,Arial,sans-serif !important;
}
.CoveoResult:last-child {
    border: none;
}
.CoveoResult .coveo-title {
    font-weight: bold;
}
.CoveoResult a:hover {
    color: #59BA47;
}
.CoveoResultList {
    /*padding: 20px;*/
    margin-top: 0;
}
.CoveoResultLink:link {
    color: #00709D;
}

.resultDetail {
    font-size: 15px;
}
.resultDescription {
    /*height: 50px;*/
    text-overflow: ellipsis;
    overflow: hidden;
    font-size: 13px !important;
}
.resultDetail span {
    line-height: 23px;
}
.resultDetail span.userTitle {
    font-weight: normal;
}
.resultDetail span.phoneType {
    color: #a1a1a1;
}
.resultDetail span.country, .resultDetail span.modifiedDate, 
.resultDetail .repositoryType, .resultDetail span.businessLine,
.resultDetail span.region, .resultDetail span.TPNuser, .resultDetail span.user,
.resultDetail span.group {
    font-size: 13px;
    line-height: 16px;
    color: #a1a1a1;
}
.resultDetail .repositoryType {
    margin-top: 10px;
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
}
.resultDetail span.PMdetails {
    font-size: 13px;
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

/* - - - DOCUMENT TYPE ICON STYLES - - - */

table.documentTable td div {
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/ss_docTypeIcons.png");
    height: 40px;
    width: 40px;
    background-size: 40px;
    margin-right: 8px;
}
table.documentTable div.doc {
    background-position: 0 278px;
}
table.documentTable div.html {
    background-position: 0 184px;
}
table.documentTable div.xls {
    background-position: 0 -96px;
}
table.documentTable td div.ppt {
    background-position: 0 324px;
}
table.documentTable td div.rtf, table.documentTable td div.txt {
    background-position: 0 231px;
}
table.documentTable td div.msg {
    background-position: 0 372px;
}
table.documentTable td div.pdf {
    background-position: 0 -3px;
}
table.documentTable td div.zip {
    background-position: 0 92px;
}
table.documentTable td div.swf {
    background-position: 0 45px;
}
/* TO HIDE ICON ON DEFAULT TEMPLATE FOR SHAREPOINT SEARCH RESULTS - DONT NEED THIS AFTER TEMPLATE FOR RESULT IS BUILT*/
.documentTable.repositoryType div[class=""], .documentTable.repositoryType div[class="sppublishingpageslibrarylist"],
.documentTable.repositoryType div[class="spsite"], .documentTable.repositoryType div[class="spdocumentlibrarylist"], 
.documentTable.repositoryType div[class="sppublishingimageslibrarylist"], .documentTable.repositoryType div[class="spuserprofile"]
 {
    display: none;
}

/* - - - OPPORTUNITY STAGE ICON STYLES - - - */
.oppStage {
    background-image: url("/resource/1431365101000/ECO_SmartSearchAssets/ss_oppStageIcons.png");
    height: 30px;
    width: 30px;
    background-size: 270px auto;
}

.oppStage[title="1 Lead"]{
    background-position: -3px -4px;
}
.oppStage[title="1A Lead - Scout"] {
    background-position: -3px -4px;
}
.oppStage[title="1B Lead - Engage"] {
    background-position: -3px -4px;
}
.oppStage[title="1C Lead - Position"] {
    background-position: -3px -4px;
}

.oppStage[title="2 Capture"] {
    background-position: -29px -4px;
}
.oppStage[title="2A Capture - LOI"] {
    background-position: -29px -4px;
}
.oppStage[title="2B Capture - EOI"] {
    background-position: -29px -4px;
}
.oppStage[title="2C Capture - SOQ"] {
    background-position: -29px -4px;
}
.oppStage[title="2D Capture - RFI"] {
    background-position: -29px -4px;
}
.oppStage[title="2E Capture - RFP"] {
    background-position: -29px -4px;
}

.oppStage[title="3 Submitted"] {
    background-position: -55px -4px;
}
.oppStage[title="3A Capture - Proposal Submitted"] {
    background-position: -55px -4px;
}
.oppStage[title="3B Capture - Short List"] {
    background-position: -55px -4px;
}
.oppStage[title="3C Capture - Interview"] {
    background-position: -55px -4px;
}

.oppStage[title="4 Project on hold"] {
    background-position: -82px -4px;
}

.oppStage[title="5A Program in Negotiation"] {
    background-position: -108px -4px;
}
.oppStage[title="5B Program Signed and Active"] {
    background-position: -108px -4px;
}
.oppStage[title="5 SNB/Win/Award"] {
    background-position: -108px -4px;
}


.oppStage[title="6A Program Closed/Completed"] {
    background-position: -133px -4px;
}
.oppStage[title="6 Contracted/Booked/Won"] {
    background-position: -133px -4px;
}

.oppStage[title="7 Canceled by Client"] {
    background-position: -161px -4px;
}

.oppStage[title="8 No-Go"] {
    background-position: -214px -4px;
}

.oppStage[title="9 Lost"] {
    background-position: -241px -4px;
}


/* - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - */
/* - - - - - - - - - - SEARCH FACET STYLES - - - - - - - - - - - */
/* - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - */

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
    color: white;
    font-size: 17px;
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
