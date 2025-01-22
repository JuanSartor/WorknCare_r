// JavaScript Document

function reload() {
    $("#list").jqGrid().trigger("reloadGrid");
}
var lastsel = false;
$("#list").jqGrid({
    url: $("#f_busqueda").attr("action") + "&do_reset=1&" + $("#f_busqueda").serialize(),
    datatype: "json",
    colNames: [' ', x_translate("Original"), x_translate("Traducción"), x_translate("Tipo"), x_translate("Descripción")],
    colModel: [
        {name: 'act', index: 'act', width: 10, sortable: false},
        {name: 'original', index: 'original', width: 100},
        {name: 'traduccion_fr', index: 'traduccion_fr', editable: true, editoptions: {maxlength: 255}, width: 100},
        {name: 'tipo', index: 'tipo', width: 25},
        {name: 'descripcion', index: 'descripcion', width: 50}
    ],
    rowNum: 100,
    /*rowList:[10,20,30],*/
    pager: '#pager',
    sortname: 'original',
    viewrecords: true,
    sortorder: "asc",
    caption: x_translate("Traducciones"),
    page: $("#list_actual_page").val(),
    /*width: 900,*/
    autowidth: true,
    height: '100%',
    multiselect: true,
    gridComplete: function () {

        var ids = $("#list").jqGrid('getDataIDs');
        for (var i = 0; i < ids.length; i++) {
            var id = ids[i];
            be = "<a href=\"javascript:;\" title=\"Editar\" onclick=\"x_loadWindow(this, 'traduccion', 'traduccion_form_win', 'id=" + id + "', 800, 600);\"><img src=\"xframework/app/themes/admin/imgs/action_ico_edit.png\" /></a>";

            $("#list").jqGrid('setRowData', ids[i], {act: be});
        }
    }

}).jqGrid("setGridParam", {
    /* beforeSelectRow: function(rowId, e) {
     return false;//return $(e.target).is("td");
     },*/
    ondblClickRow: function (id, iRow, iCol, e) {

        var grid = $(this);

        var p = grid[0].p;
        if ((p.multiselect && $.inArray(id, p.selarrrow) < 0) || id !== p.selrow) {
            // if the row are still non-selected
            grid.jqGrid("setSelection", id, true);
        }


        grid.jqGrid("destroyFrozenColumns")

        if (id && id !== lastsel) {

            grid.jqGrid('restoreRow', lastsel);

            if (lastsel == 0) {
                grid.jqGrid('delRowData', lastsel);
            }

        }


        configEditRow(id, grid, iCol);


        lastsel = id;
    }
}).jqGrid('setGridParam', {url: $("#f_busqueda").attr("action") + "&do_reset=0&" + $("#f_busqueda").serialize(), page: 1});

var configEditRow = function (id, grid, iCol) {

    var editparameters = {
        "keys": true,
        "oneditfunc": null,
        "successfunc": null,
        "url": 'xadmin.php?action=1&modulo=traduccion&submodulo=traduccion_form_win&idtraduccion=' + id,
        "extraparam": {},
        "aftersavefunc": function (rowid, objResponse) {

            var data = $.parseJSON(objResponse.responseText);

            x_alert(data.msg);

            if (data.result) {
                //reload();
                grid.jqGrid('setRowData', rowid, data.newType);
                //console.log(data);
            }

            lastsel = false;

            grid.jqGrid("setFrozenColumns");


            grid.closest(".ui-jqgrid-bdiv").scrollTop(grid.closest(".ui-jqgrid-bdiv").scrollTop() - 1)

        },
        "errorfunc": null,
        "afterrestorefunc": function (rowid) {
            if (rowid == 0) {
                $(this).jqGrid('delRowData', rowid);
            }

            lastsel = false;

            grid.jqGrid("setFrozenColumns");

            grid.closest(".ui-jqgrid-bdiv").scrollTop(grid.closest(".ui-jqgrid-bdiv").scrollTop() - 1)

        },
        "restoreAfterError": true,
        "mtype": "POST",
        "focusField": iCol
    }
    grid.jqGrid('editRow', id, editparameters);


    /*grid.jqGrid('editRow', id, true, 
     function(){
     console.log($("input, select",e.target).focus());
     }
     
     , null, 'ct.php?action=1&modulo=core_table&submodulo=type_form&idtype='+id,
     {},
     function(rowid, objResponse) {
     
     var data = $.parseJSON(objResponse.responseText);
     
     x_alert(data.msg);
     
     if (data.result) {
     reload();
     } 
     
     grid.jqGrid("setFrozenColumns");					
     
     },
     {},
     function(rowid){
     if (rowid == 0 ){
     $(this).jqGrid('delRowData',rowid);	
     }
     
     grid.jqGrid("setFrozenColumns");
     
     }
     );*/


}

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



//multiselect

$('<a href="javascript:;" title="Eliminar">Eliminar</a>').appendTo("#pager_left").click(function () {
    x_deleteMultiple({ids: $("#list").jqGrid('getGridParam', 'selarrrow'),
        callback: reload,
        pregunta: 'Desea dar de baja la/las traducciones/s?',
        submodulo: 'deletemultiple_traduccion'
    });

})

//crear nueva traduccion
$("#btnNew").click(function () {

    x_loadWindow(this, 'traduccion', 'traduccion_form_win', '', 800, 600);

});
//compilar traducciones a archivo js
$("#btnCompilarTraducciones").click(function () {
    var url = "xadmin.php?";
    var queryStr = "action=1&modulo=traduccion&submodulo=compilar_traduccion";

    x_doAjaxCall("POST",
            url,
            queryStr,
            function (data) {
                x_alert(data.msg);
            },
            "",
            "",
            true,
            true);
});

//busca traducciones den los archivos del sistema y los carga en la BD
$("#btnBucarTraduccionesSistema").click(function () {
    $("#div_progreso").show();
    $("#span_progreso").html("Bucando archivos del sistema...");
    var url = controller + ".php?";
    var queryStr = "action=1&modulo=traduccion&submodulo=get_traducciones_sistema";
    x_doAjaxCall("POST",
            url,
            queryStr,
            function (data) {
                $("#span_progreso").html("0%");
                parse_traduccion();
            },
            "",
            "",
            true,
            true);

});

var parse_traduccion = function () {
    var url = controller + ".php?";
    var queryStr = "action=1&modulo=traduccion&submodulo=parse_traducciones_sistema";
    x_doAjaxCall("POST",
            url,
            queryStr,
            function (data) {
                
                //si no termino, vuelvo a ejecutar
                if (data.porcentaje!= undefined && data.porcentaje>0 && data.porcentaje < 100) {
                    $("#span_progreso").html(data.porcentaje + "%");
                   parse_traduccion();
                } else {
                    $("#span_progreso").html(data.porcentaje + "% - Finalizado");
                    reload();
                    x_alert(data.msg);
                }

            },
            "",
            "",
            true,
            true);
}

$("#modulo").val("traduccion");
$("#submodulo").val("traducciones_list");
x_runJS();

