$("#modulo").val("programa_salud");
$("#submodulo").val("cupon_list");
x_runJS();


function reload() {
    $("#list").jqGrid().trigger("reloadGrid");
}

$("#list").jqGrid({
    url: "xadmin.php?action=1&modulo=programa_salud&submodulo=cupon_list",
    datatype: "json",
    colNames: ['', "Nombre", "Código cupón", "Estado"],
    colModel: [
        {name: 'act', index: 'act', width: 50, align: 'center', hidden: false, sortable: false},
        {name: 'nombre', index: 'nombre', width: 100, align: 'center', sortable: true},
        {name: 'codigo_cupon', index: 'codigo_cupon', align: 'center', width: 100, sortable: true},
        {name: 'activo', index: 'activo', width: 100, align: 'center', sortable: true}


    ],
    rowNum: 50,
    pager: '#pager',
    sortname: 'idprograma_salud_cupon',
    viewrecords: true,
    sortorder: "asc",
    caption: "Cupones",
    page: $("#list_actual_page").val(),
    autowidth: true,
    height: '100%',
    multiselect: true,
    gridComplete: function () {

        $this = $(this);
        var ids = $("#list").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {


            var id = ids[i];
            var rowData = $this.jqGrid('getRowData', id);

            be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_goTo('programa_salud','cupon_form','id=" + id + "','Main',this)\"><button>Editar</button></a>";

            $("#list").jqGrid('setRowData', ids[i], {act: be});
        }


    }
});

//multiselect
$("#pager_left").find("a").remove();
$('<a href="javascript:;" title="Eliminar">Eliminar</a>').appendTo("#pager_left").click(function () {

    x_deleteMultiple({ids: $("#list").jqGrid('getGridParam', 'selarrrow'),
        callback: reload,
        pregunta: 'Desea dar de baja el cupon?',
        modulo: 'programa_salud',
        submodulo: 'deletemultiple_cupon'
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
    x_goTo('programa_salud', 'cupon_form', '', 'Main', this);
});
