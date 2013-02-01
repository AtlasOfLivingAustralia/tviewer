<!DOCTYPE html>
<html>
<head>
    <title>Species view | FishMap | Atlas of Living Australia</title>
    <meta name="layout" content="ala2"/>
    <r:require module="application"/>
</head>
<body class="species-list">
<header id="page-header">
    <div class="inner no-top">
        <hgroup>
            <h1 title="Visual explorer - species list"></h1>
        </hgroup>
        <nav id="breadcrumb"><ol>
            <li><a href="${searchPage}">Search</a></li>
            <li class="last"><i>Results by species</i></li></ol>
        </nav>
        <h2>Results for ${queryDescription ?: 'Australia'}</h2>
    </div>
</header>
<div class="inner no-top">
    <span style="color: grey">Click images to view full size.</span>
    <div id="controls">
        <label for="sortBy">Sort by:</label>
        <g:select from="[[text:'Scientific name',id:'name'],[text:'Common name',id:'common'],[text:'Family/genus/spp',id:'taxa'],[text:'CAAB code',id:'caabCode']]"
                  name="sortBy" optionKey="id" optionValue="text" value="taxa"/>
        <label for="sortOrder">Sort order:</label>
        <g:select from="['normal','reverse']" name="sortOrder"/>
        <label for="perPage">Results per page:</label>
        <g:select from="[5,10,20,50,100]" name="perPage" value="10"/>
    </div>
    <table class="taxonList">
        <colgroup>
            <col id="tlCheckbox"> <!-- checkbox -->
            <col id="tlName"> <!-- taxon name -->
            <col id="tlImage"> <!-- image -->
            <col id="tlGenera"> <!-- distribution map -->
        </colgroup>
        <thead>
        <tr><th></th><th>Scientific name<br/><span style="font-weight: normal;">Common name<br/>Family<br/>CAAB code
            <a href="http://www.marine.csiro.au/caab/" class="external">more info</a></span></th>
            <th style="text-align:center;vertical-align:middle;">Representative image</th>
            <th style="padding-left:60px;">Distribution</th></tr>
        </thead>
        <tbody>
        <g:each in="${list}" var="i">
            <tr>
                <!-- checkbox -->
                <td><input type="checkbox" id="${i.spcode}"  alt="${i.guid}"/></td>
                <!-- name -->
                <td><em><a href="${grailsApplication.config.bie.baseURL}/species/${i.name}" title="Show ${rank} page">${i.name}</a></em>
                <!-- common -->
                <g:if test="${i.common && i.common.toString() != 'null'}">
                    <div class="common">${i.common}</div>
                </g:if>
                <!-- family -->
                <div>Family: ${i.family}</div>
                <!-- CAAB code -->
                <g:if test="${i.caabCode}">
                    <div>CAAB: <a href="http://www.marine.csiro.au/caabsearch/caab_search.caab_report?spcode=${tv.removeSpaces(str:i.caabCode)}"
                            class="external" title="Lookup CAAB code">${i.caabCode}</a></div>
                </g:if></td>
                <!-- image -->
                <td class="mainImage">
                    <g:if test="${i.image?.largeImageUrl}">
                        <a rel="list" class="imageContainer lightbox" href="#${i.name.replace(' ','_')}-popup">
                            <img class="list" src="${i.image.largeImageUrl}" alt title="Click to view full size"/>
                        </a>
                        <div style="display: none">
                            <div class="popupContent" id="${i.name.replace(' ','_')}-popup">
                                <img src="${i.image.largeImageUrl}" alt />
                                <div class="details" data-mdurl="${i.image.imageMetadataUrl}">
                                    <div class="summary" id="${i.name.replace(' ','_')}-summary"><strong><em>${i.name}</em></strong></div>
                                    <div><span class="dt">Image by:</span><span class="creator">${i.image?.creator}</span></div>
                                    <div><span class="dt">License:</span><span class="license">${i.image?.license}</span></div>
                                    <div style="padding-bottom: 12px;"><span class="dt">Rights:</span><span class="rights">${i.image?.rights}</span></div>
                                </div>
                            </div>
                        </div>
                    </g:if>
                    <g:else>
                        <a class="imageContainer no-image" href="#${i.name}-popup">
                            <r:img class="list" uri="/images/no-image.png"/>
                        </a>
                    </g:else>
                </td>
                <!-- distribution -->
                <td><g:if test="${i.gidx}">
                    <a rel="dist" class="distributionImageContainer lightbox" href="#${i.name.replace(' ','_')}-dist">
                        <img class="dist" src="${grailsApplication.config.distribution.image.cache}/dist${i.gidx}.png"
                             alt title="Click for larger view"/>
                    </a>
                    <div style="display: none">
                        <div class="popupContent" id="${i.name.replace(' ','_')}-dist">
                            <img src="${grailsApplication.config.distribution.image.cache}/dist${i.gidx}.png" alt width="400" height="400"/>
                            <div class="details" style="padding-bottom: 10px;">
                                <div class="summary" id="${i.name.replace(' ','_')}-distsummary"><strong><em>${i.name}</em></strong></div>
                            </div>
                        </div>
                    </div>
                </g:if></td>
            </tr>
        </g:each>
        </tbody>
    </table>
    <section id="pagination">
        <tv:paginate start="${start}" pageSize="${pageSize}" total="${total}"
                     params="${[taxa:taxa,key:key,sortBy:sortBy,sortOrder:sortOrder,genus:genus]}"/>
        <p id="viewLinks">
            Total <tv:pluraliseRank rank="species"/>: ${total}
            <span class="link" id="speciesData">Show data table for checked <tv:pluraliseRank rank="${rank}"/></span>
            <g:link style="padding-left:20px;" action="view" params="[key: key]">Show all results by family</g:link>
            <g:link style="padding-left:20px;" action="data" params="[key: key]">Show data table for all species</g:link><br/>
        </p>
        <div id="checkboxButtons">
            <button id="selectAll" type="button">Select all</button>
            <button id="clearAll" type="button">Clear all</button>
        </div>
    </section>
</div>
<r:script type="text/javascript">
    $(document).ready(function () {
        // wire link to species data
        $('#speciesData').click(function () {
            // collect the selected ranks
            var checked = "";
            $('input[type="checkbox"]:checked').each(function () {
                checked += (checked === "" ? '' : ',') + $(this).attr('id');
            });
            if (checked === "") {
                alert("No species selected");
            }
            else {
                document.location.href = "${grailsApplication.config.grails.serverURL}" +
                        "/taxon/data?taxa=" + checked + "&key=${key}";
            }
        });
        tviewer.init("${grailsApplication.config.grails.serverURL}");
    });
</r:script>
</body>
</html>