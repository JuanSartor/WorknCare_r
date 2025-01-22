$("#modulo").val("planes");
$("#submodulo").val("planes_list");
x_runJS();


function reload() {
    $("#list").jqGrid().trigger("reloadGrid");
}

$("#list").jqGrid({
    url: "xadmin.php?action=1&modulo=planes&submodulo=planes_list",
    datatype: "json",
    colNames: ['', "Nombre", "Precio", "Tipo"],
    colModel: [
        {name: 'act', index: 'act', width: 50, align: 'center', hidden: false, sortable: false},
        {name: 'nombre', index: 'nombre', width: 100, align: 'center', sortable: true},
        {name: 'precio', index: 'precio', align: 'center', width: 100, sortable: true},
        {name: 'part', index: 'part', align: 'center', width: 100, sortable: true}


    ],
    rowNum: 50,
    pager: '#pager',
    sortname: 'idprograma_salud_plan',
    viewrecords: true,
    sortorder: "asc",
    caption: "Planes",
    page: $("#list_actual").val(),
    autowidth: true,
    height: '100%',
    multiselect: true,
    gridComplete: function () {

        $this = $(this);
        var ids = $("#list").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {


            var id = ids[i];
            var rowData = $this.jqGrid('getRowData', id);

            be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_goTo('planes','planes_form','id=" + id + "','Main',this)\"><button>Editar</button></a>";

            $("#list").jqGrid('setRowData', ids[i], {act: be});
        }


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