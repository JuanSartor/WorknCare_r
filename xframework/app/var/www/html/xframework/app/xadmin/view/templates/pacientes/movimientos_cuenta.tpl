
<div class="title">
    {"Estado de cuenta"|x_translate}
</div>
<ul>
    <li class="wide"> <label>{"SALDO DISPONIBLE"|x_translate}:</label><span>EUR {$cuenta.saldo}</span></li>
</ul>
<div class="clear">
    &nbsp;
</div>
<div  class="xTable" id="xTable">

    <div class="container">		

        <table id="list_movimientos">
        </table> 

        <div id="pager_movimientos"></div>

    </div>     
</div> 

</div> 
{literal}
    <script>
        $("#list_movimientos").jqGrid({
            url: "xadmin.php?action=1&modulo=pacientes&submodulo=movimientos_cuenta_list&idpaciente=" + $("#idpaciente").val(),
            datatype: "json",
            colNames: ['', "Fecha", "Detalle", "Monto", "Nombre"],
            colModel: [
                {name: 'act', index: 'act', width: 70, hidden: false, sortable: false, align: "center", hidden: true},
                {name: 'fecha', index: 'fecha', width: 70, sortable: true},
                {name: 'detalleMovimientoCuenta', index: 'detalleMovimientoCuenta', width: 150, sortable: false},
                {name: 'monto', index: 'monto', width: 100, sortable: false, align: "right"},
                {name: 'nombre_medico', index: 'nombre_medico', align: "center", width: 100, sortable: false}
            ],
            rowNum: 100,
            pager: '#pager_movimientos',
            sortname: 'fecha',
            viewrecords: true,
            sortorder: "desc",
            caption: "Movimientos de cuenta",
            page: $("#list_actual_page").val(),
            autowidth: true,
            height: '100%',
            multiselect: true,
            gridComplete: function () {

                var ids = $("#list").jqGrid('getDataIDs');




            }
        });
    </script>
{/literal}
