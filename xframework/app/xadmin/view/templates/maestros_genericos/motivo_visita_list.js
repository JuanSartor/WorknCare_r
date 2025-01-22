$("#modulo").val("maestros_genericos");
$("#submodulo").val("motivo_visita_list");
x_runJS();


function reload() {
    $("#list").jqGrid().trigger("reloadGrid");
}

$("#list").jqGrid({
    url: $("#f_busqueda").attr("action") + "&" + $("#f_busqueda").serialize(),
    datatype: "json",
    colNames: ['', 'Motivo'],
    colModel: [
        {name: 'act', index: 'act', width: 20, hidden: false, align: 'center', sortable: false},
        {name: 'motivoVisita', index: 'motivoVisita', width: 150, sortable: false}

    ],

    rowNum: 50,
    pager: '#pager',
    sortname: 'motivoVisita',
    viewrecords: true,
    sortorder: "asc",
    caption: "Motivo Visita",
    page: $("#list_actual_page").val(),
    autowidth: true,
    height: '100%',
    multiselect: true,
    gridComplete: function () {

        var ids = $("#list").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {

            var id = ids[i];

            be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_goTo('maestros_genericos','motivo_visita_form','id=" + id + "','Main',this)\"><button>Editar</button></a>";

            $("#list").jqGrid('setRowData', ids[i], {act: be});
        }


    }
});


//multiselect

$('<a href="javascript:;" title="Eliminar">Eliminar</a>').appendTo("#pager_left").click(function () {

    x_deleteMultiple({ids: $("#list").jqGrid('getGridParam', 'selarrrow'),
        callback: reload,
        pregunta: 'Desea dar de baja el Motivo de visita presencial?',
        submodulo: 'deletemultiple_motivo_visita'
    });

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




$("#btnNew").click(function () {
    x_goTo('maestros_genericos', 'motivo_visita_form', '', 'Main', this);
});
