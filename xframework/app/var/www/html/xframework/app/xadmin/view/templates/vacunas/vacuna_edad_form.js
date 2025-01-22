x_runJS();

$("#btnGuardar").click(function() {

    x_sendForm($('#f_record'), true, callback_Send);

});

var callback_Send = function(data) {
    x_alert(data.msg);
    if (data.result) {
        x_goTo('vacunas', 'vacuna_edad_form', 'id=' + data.id, 'Main', this);
    }
};

$("#back").click(function() {
    x_goTo('vacunas', 'vacuna_edad_list', '', 'Main', this);
});



function reload() {
    $("#list").jqGrid().trigger("reloadGrid");
}

$("#list").jqGrid({
    url: "xadmin.php?action=1&modulo=vacunas&submodulo=vacuna_edad_relacion_list&vacunaEdad_idvacunaEdad=" + $("#idvacunaEdad").val(),
    datatype: "json",
    colNames: ['', 'Vacuna', 'Descripción vacuna', 'Descripción vacuna edad / grupo','Tipo aplicación'],
    colModel: [
        {name: 'act', index: 'act', width: 25, align: "center", hidden: false, sortable: false},
        {name: 'vacuna', index: 'vacuna', width: 100, sortable: false},
        {name: 'descripcion_vacuna', index: 'descripcion_vacuna', width: 200, sortable: false},
        {name: 'descripcion', index: 'descripcion', width: 200, sortable: false},
         {name: 'tipo_aplicacion', index: 'tipo_aplicacion', width: 200, sortable: false}
    ],
    rowNum: 50,
    pager: '#pager',
    sortname: 'descripcion',
    viewrecords: true,
    sortorder: "asc",
    caption: "Relación Vacunas",
    page: 0,
    autowidth: true,
    height: '100%',
    multiselect: false,
    gridComplete: function() {

        var ids = $("#list").jqGrid('getDataIDs');

        for (var i = 0; i < ids.length; i++) {

            var id = ids[i];

            bd = "<a href=\"javascript:;\"  onclick=\"drop({id:" + id + ", modulo:'vacunas', submodulo:'drop_vacuna_edad_relacion', callback:reload});\" title=\"Eliminar\"><img  src=\"xframework/app/themes/admin/imgs/action_ico_delete.png\"/></a>";

            $("#list").jqGrid('setRowData', ids[i], {act: bd});
        }
    }
});

$("#btnGuardarRelacion").click(function() {
    if($("#vacuna_idvacuna").val()!==""){
         x_sendForm($('#f_add_relacion'), true, callback_return);
    }

   

});
var callback_return = function(data) {
    x_alert(data.msg);
    $("#f_add_relacion").clearForm();
    if (data.result) {
        $("#f_add_relacion").clearForm();
        $.uniform.update("#f_add_relacion :input");
        reload();
    }
};