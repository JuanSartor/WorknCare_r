
$("#modulo").val("reintegro");
$("#submodulo").val("grillas_form");

$("#btnGuardar").click(function () {
 if ($("#grilla_input").val() == "" && $("#codigo_input").val() == "") {
        x_alert("Complete el número y código de grilla");
        return false;
    }
    if ($("#sector1").val() == 1 && $("#valor_sector1_input").val() == "") {
        x_alert("Complete tarifa de Sector 1");
        return false;
    }
    if ($("#sector2").val() == 1 && $("#valor_sector2_input").val() == "") {
        x_alert("Complete tarifa de Sector 2");
        return false;
    }
    if ($("#optam").val() == 1 && $("#valor_optam_input").val() == "") {
        x_alert("Complete tarifa de Optam");
        return false;
    }
    x_sendForm(
            $('#f_record'),
            true,
            callback_update
            );

});

var callback_update = function (data) {
    x_alert(data.msg);
    
};

$("#back").click(function () {
    x_goTo('reintegro', 'grillas_list', '', 'Main', this);
});

//listado de excepciones
function reload() {
    $("#list").jqGrid().trigger("reloadGrid");
}

$("#list").jqGrid({
    url: "xadmin.php?action=1&modulo=reintegro&submodulo=grillas_excepcion_list&do_reset=1&idgrilla="+$("#idgrilla").val(),
    datatype: "json",
    colNames: ['', 'Especialidad','Código' , 'Sector 1', 'Sector 2', 'Optam'],
    colModel: [
        {name: 'act', index: 'act', align: "center", width: 20, hidden: false, sortable: false},
        {name: 'especialidad', index: 'especialidad', width: 100, sortable: false},
        {name: 'codigo', index: 'codigo', width: 100, sortable: true},
        {name: 'sector1', index: 'sector1', width: 100, sortable: false},
        {name: 'sector2', index: 'sector2', width: 100, sortable: false},
        {name: 'optam', index: 'optam', width: 100, sortable: false}

    ],
    rowNum: 50,
    pager: '#pager',
    sortname: 'idgrilla_excepcion',
    viewrecords: true,
    sortorder: "asc",
    caption: "Excepciones de tarifa",
    page: $("#list_actual_page").val(),
    autowidth: true,
    height: '100%',
    multiselect: true,
    gridComplete: function () {

        var ids = $("#list").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {

            var id = ids[i];

            be = "<a href=\"javascript:;\" title=\"Editar\"  onclick=\"x_loadWindow(this, 'reintegro', 'grillas_excepcion_form_win', 'id=" + id + "', 800, 400)\"><img src=\"xframework/app/themes/admin/imgs/action_ico_edit.png\" /></a>";



            $("#list").jqGrid('setRowData', ids[i], {act: be});
        }
    }
});


//multiselect

$('<a href="javascript:;" title="Eliminar" >Eliminar</a>').appendTo("#pager_left").click(function () {

    x_deleteMultiple({ids: $("#list").jqGrid('getGridParam', 'selarrrow'),
        callback: reload,
        pregunta: '¿Desea eliminar las excepciones seleccionadas?',
        submodulo: 'deletemultiple_grillas_excepcion'
    });

});

$("#sector1").change(function () {
    if ($("#sector1 option:selected").val() == 1) {
        $("#div_condicion_sector1").show();
        $("#div_tarifa_sector1").show();
    } else {
        $("#div_condicion_sector1").hide();
        $("#div_tarifa_sector1").hide();
        $("#valor_sector1_input").val("");
    }
})


$("#sector2").change(function () {
    if ($("#sector2 option:selected").val() == 1) {
        $("#div_condicion_sector2").show();
        $("#div_tarifa_sector2").show();
    } else {
        $("#div_condicion_sector2").hide();
        $("#div_tarifa_sector2").hide();
        $("#valor_sector2_input").val("");
    }
})


$("#optam").change(function () {
    if ($("#optam option:selected").val() == 1) {
        $("#div_condicion_optam").show();
        $("#div_tarifa_optam").show();
    } else {
        $("#div_condicion_optam").hide();
        $("#div_tarifa_optam").hide();
          $("#valor_optam_input").val("");
    }
})

$("#btnAddExcepcion").click(function(){
    x_loadWindow(this, 'reintegro', 'grillas_excepcion_form_win', '', 800, 400);
    
})