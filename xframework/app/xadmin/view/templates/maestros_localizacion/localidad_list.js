// JavaScript Document

function reload() {
    $("#list").jqGrid().trigger("reloadGrid");
}

$("#list").jqGrid({
    url: $("#f_busqueda").attr("action") + "&" + $("#f_busqueda").serialize(),
    datatype: "json",
    colNames: [' ', 'Localidad', 'CPA','País'],
    colModel: [
        {name: 'act', index: 'act', width: 25, sortable: false},
        {name: 'localidad', index: 'loc.localidad', width: 150},
        {name: 'cpa', index: 'loc.cpa', width: 75},
          {name: 'pais', index: 'pais', width: 150}
   
    ],
    rowNum: 25,
    /*rowList:[10,20,30],*/
    pager: '#pager',
    sortname: 'localidad',
    viewrecords: true,
    sortorder: "asc",
    caption: "Localidades",
    page: $("#list_actual_page").val(),
    /*width: 900,*/
    autowidth: true,
    height: '100%',
    multiselect: true,
    gridComplete: function() {

        var ids = $("#list").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {

            var id = ids[i];

            be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_goTo('maestros_localizacion','localidad_form','id=" + id + "','Main',this)\"><img src=\"xframework/app/themes/admin/imgs/action_ico_edit.png\" /></a>";

            $("#list").jqGrid('setRowData', ids[i], {act: be});
        }
    }

});

$("#btnFilter").click(function() {

    $("#list").jqGrid('setGridParam', {url: $("#f_busqueda").attr("action") + "&do_reset=1&" + $("#f_busqueda").serialize(), page: 1})
            .trigger("reloadGrid")
            .jqGrid('setGridParam', {url: $("#f_busqueda").attr("action") + "&do_reset=0&" + $("#f_busqueda").serialize(), page: 1});
});

$("#btnLimpiar").click(function() {

    $("#f_busqueda").clearForm();


    //actualizo uniform

    $("#pais_idpais").prop("selectedIndex", 0).change();
    $("#provincia_idprovincia").prop("selectedIndex", 0).change();

    $.uniform.update("#f_busqueda :input");

    $("#list")
            .jqGrid('setGridParam', {url: $("#f_busqueda").attr("action") + "&do_reset=1&" + $("#f_busqueda").serialize(), page: 1})
            .trigger("reloadGrid")
            .jqGrid('setGridParam', {url: $("#f_busqueda").attr("action") + "&do_reset=0&" + $("#f_busqueda").serialize(), page: 1});
});



//multiselect

$('<a href="javascript:;" title="Eliminar">Eliminar</a>').appendTo("#pager_left").click(function() {

    x_deleteMultiple({ids: $("#list").jqGrid('getGridParam', 'selarrrow'),
        callback: reload,
        pregunta: 'Desea dar de baja la/los localidad/es?',
        submodulo: 'deletemultiple_localidad'
    });

})


$("#btnNew").click(function(){
								
    
      x_goTo('maestros_localizacion','localidad_form','pais_idpais='+$("#pais_idpais").val(),'Main',this);
    

});



$("#modulo").val("maestros_localizacion");
$("#submodulo").val("localidad_list");
x_runJS();

