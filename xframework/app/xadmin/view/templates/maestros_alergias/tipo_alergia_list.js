$("#modulo").val("maestros_alergias");
$("#submodulo").val("tipo_alergia_list");
x_runJS();



function reload() {
    $("#list").jqGrid().trigger("reloadGrid");
}


var idtipoAlergia = $("#tipoAlergia_idtipoAlergia").val();
$("#list").jqGrid({
    url: "xadmin.php?action=1&modulo=maestros_alergias&submodulo=tipo_alergia_list&tipoAlergia_idtipoAlergia=" + idtipoAlergia,
    datatype: "json",
    colNames: ['', 'Sub Tipo Alergia'],
    colModel: [
        {name: 'act', index: 'act', width: 50, hidden: false, sortable: false},
        {name: 'subTipoAlergia', index: 'subTipoAlergia', width: 150, sortable: false}
    ],
    rowNum: 50,
    pager: '#pager',
    sortname: 'subTipoAlergia',
    viewrecords: true,
    sortorder: "asc",
    caption: "Sub Tipo Alergia",
    page: $("#list_actual_page").val(),
    autowidth: true,
    height: '100%',
    multiselect: true,
    gridComplete: function() {

        var ids = $("#list").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {

            var id = ids[i];
            
            
            var idtipoAlergia = $("#tipoAlergia_idtipoAlergia").val();

            be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_goTo('maestros_alergias','tipo_alergia_form','id=" + id + "&tipoAlergia_idtipoAlergia=" + idtipoAlergia + "','Main',this)\"><img src=\"xframework/app/themes/admin/imgs/action_ico_edit.png\" /></a>";

            $("#list").jqGrid('setRowData', ids[i], {act: be});
        }


    }
});


//multiselect

$('<a href="javascript:;" title="Eliminar">Eliminar</a>').appendTo("#pager_left").click(function() {

    x_deleteMultiple({ids: $("#list").jqGrid('getGridParam', 'selarrrow'),
        callback: reload,
        pregunta: 'Desea dar de baja el/los Sub Tipo Alergia/s?',
        submodulo: 'deletemultiple_tipo_alergia'
    });

});


$("#btnFilter").click(function() {

    $("#list").jqGrid('setGridParam', {url: $("#f_busqueda").attr("action") + "&do_reset=1&" + $("#f_busqueda").serialize(), page: 1})
            .trigger("reloadGrid")
            .jqGrid('setGridParam', {url: $("#f_busqueda").attr("action") + "&do_reset=0&" + $("#f_busqueda").serialize(), page: 1});
});

$("#btnLimpiar").click(function() {

    $("#f_busqueda").clearForm();


    //actualizo uniform

    $.uniform.update("#f_busqueda :input");

    $("#list")
            .jqGrid('setGridParam', {url: $("#f_busqueda").attr("action") + "&do_reset=1&" + $("#f_busqueda").serialize(), page: 1})
            .trigger("reloadGrid")
            .jqGrid('setGridParam', {url: $("#f_busqueda").attr("action") + "&do_reset=0&" + $("#f_busqueda").serialize(), page: 1});
});




$("#btnNew").click(function() {
    var idtipoAlergia = $("#tipoAlergia_idtipoAlergia").val();
    x_goTo('maestros_alergias', 'tipo_alergia_form', 'tipoAlergia_idtipoAlergia=' + idtipoAlergia, 'Main', this);
});

$("#back").click(function() {
    x_goTo('maestros_alergias', 'alergia_list', '', 'Main', this);
});