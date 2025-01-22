 <input type="hidden" id="list_actual_page" value="{$paginate.current_page}" />

<div class="title">
    {"Beneficiarios inscriptos"|x_translate}:&nbsp; <span id="cant_beneficiarios">{$info_beneficiarios.beneficiarios_inscriptos}</span> - 
    {"Beneficiarios verificados"|x_translate}:&nbsp; <span id="cant_beneficiarios">{$info_beneficiarios.beneficiarios_verificados}</span>
</div>

<div class="clear">
    &nbsp;
</div>
<div  class="xTable" id="xTable">

    <div class="container">		

        <table id="listado_beneficiarios">
        </table> 

        <div id="pager_beneficiarios"></div>

    </div>     
</div> 

{literal}
    <script>
        $("#listado_beneficiarios").jqGrid({
            url: "xadmin.php?action=1&modulo=usuarios_empresa&submodulo=beneficiarios_list&&do_reset=1&idempresa=" + $("#idempresa").val(),
            datatype: "json",
            colNames: ['', "Nombre", "Apellido", "Email", "Fecha alta", "Estado", ""],
            colModel: [//"nombre","apellido","email","fecha_alta_format","estado_format"
                {name: 'act', index: 'act', width: 70, sortable: false, align: "center", hidden: false},
                {name: 'nombre', index: 'nombre', width: 100, sortable: true},
                {name: 'apellido', index: 'apellido', width: 100, sortable: true},
                {name: 'email', index: 'email', width: 100, sortable: true},
                {name: 'fecha_alta_format', index: 'fecha_alta', align: "center", width: 100, sortable: true},
                {name: 'estado_format', index: 'estado', align: "center", width: 100, sortable: true},
                {name: 'paciente_idpaciente', index: 'paciente_idpaciente', align: "center", width: 100, hidden: true}
            ],
            rowNum: 100,
            pager: '#pager_beneficiarios',
            sortname: 'fecha_alta',
            viewrecords: true,
            sortorder: "desc",
            caption: "Listado de beneficiarios",
            page: $("#list_actual_page").val(),
            autowidth: true,
            height: '100%',
            multiselect: false,
            loadComplete: function (data) {
                console.log("data", data);
                //$("#cant_beneficiarios").text(data.records);

            },
            gridComplete: function (data) {
                var ids = $("#listado_beneficiarios").jqGrid('getDataIDs');
                for (var i = 0; i < ids.length; i++) {

                    var id = ids[i];
                    var rowData = jQuery('#listado_beneficiarios').jqGrid('getRowData', id);
                    bp = "<button  title=\"Ver paciente\" class='ver_paciente' data-id=" + rowData.paciente_idpaciente + ">Ver paciente</button>";
                    $("#listado_beneficiarios").jqGrid('setRowData', ids[i], {act: bp});
                }
            }
        }).jqGrid('setGridParam', {url: "xadmin.php?action=1&modulo=usuarios_empresa&submodulo=beneficiarios_list&&do_reset=0&idempresa=" + $("#idempresa").val()});

        $("#listado_beneficiarios").on("click", ".ver_paciente", function (e) {
            e.preventDefault();
            var id = $(this).data("id");
            console.log(id);
            x_goTo('pacientes', 'pacientes_generica_form', 'id=' + id, 'Main', this);
        });
    </script>
{/literal}
