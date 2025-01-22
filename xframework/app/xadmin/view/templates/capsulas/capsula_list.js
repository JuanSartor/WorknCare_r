// JavaScript Document

function reload() {
    $("#list").jqGrid().trigger("reloadGrid");
}

$("#list").jqGrid({
    url: $("#f_busqueda").attr("action") + "&" + $("#f_busqueda").serialize(),
    datatype: "json",
    colNames: [' ', 'Titulo', 'Contenedor'],
    colModel: [
        {name: 'act', index: 'act', width: 60, sortable: false, align: 'center'},
        {name: 'titulo', index: 'titulo', width: 300},
        {name: 'contenedor', index: 'contenedor', width: 300}


        /// ahora deberias mostrar en el form para poder cambiar el estado de la transferencia
        //  y verificar que pueda generar otro cuestionario
    ],
    rowNum: 25,
    /*rowList:[10,20,30],*/
    pager: '#pager',
    sortname: 'orden desc, contenedor',
    viewrecords: true,
    sortorder: "desc",
    caption: "Capsulas",
    page: $("#list_actual_page").val(),
    /*width: 900,*/
    autowidth: true,
    height: '100%',
    multiselect: true,
    gridComplete: function () {

        var ids = $("#list").jqGrid('getDataIDs');

        /* for (var i = 0; i < ids.length; i++) {
         
         var id = ids[i];
         
         be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_goTo('capsulas','capsula_form','id=" + id + "','Main',this)\"><button>Editar</button></a>";
         
         $("#list").jqGrid('setRowData', ids[i], {act: be});
         } */
    }

});

$("#btnFilter").click(function () {

    $("#list").jqGrid('setGridParam', {url: $("#f_busqueda").attr("action") + "&do_reset=1&" + $("#f_busqueda").serialize(), page: 1})
            .trigger("reloadGrid")
            .jqGrid('setGridParam', {url: $("#f_busqueda").attr("action") + "&do_reset=0&" + $("#f_busqueda").serialize(), page: 1});
});

$("#btnLimpiar").click(function () {

    $("#f_busqueda").clearForm();


    //actualizo uniform

    $.uniform.update("#f_busqueda :input");

    $("#list")
            .jqGrid('setGridParam', {url: $("#f_busqueda").attr("action") + "&do_reset=1&" + $("#f_busqueda").serialize(), page: 1})
            .trigger("reloadGrid")
            .jqGrid('setGridParam', {url: $("#f_busqueda").attr("action") + "&do_reset=0&" + $("#f_busqueda").serialize(), page: 1});
});




$('<a href="javascript:;" title="Eliminar">Eliminar</a>').appendTo("#pager_left").click(function () {

    x_deleteMultiple({
        ids: $("#list").jqGrid('getGridParam', 'selarrrow'),
        callback: reload,
        pregunta: 'Desea eliminar las capsulas seleccionadas?',
        submodulo: 'deletemultiple_capsulas'
    });

});



$("#btnNew").click(function () {
    x_goTo('capsulas', 'capsula_form', '', 'Main', this);
});


$("#modulo").val("capsulas");
$("#submodulo").val("capsula_list");

x_runJS();

