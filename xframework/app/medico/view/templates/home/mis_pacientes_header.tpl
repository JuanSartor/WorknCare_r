<section class="filter-table-header patients">
    <input type="hidden" id="from_mis_pacientes" value="{$from_mis_pacientes}"/>
    <div class="container-fluid">
        <div class="row">
            <div class="col-xs-6 col-sm-4 col-md-4">
                <h1 class="section-header">{"Mis Pacientes"|x_translate}</h1>
            </div>
            <div class="col-md-3 col-md-offset-1 col-sm-4">
                <button data-toggle="modal" href="{$url}medico.php?fromajax=1&modulo=pacientes&submodulo=agregar_paciente" data-target="#winModal" role="button" class="text-center new-user">{"Agregar Paciente"|x_translate}</button>
            </div>
            <div class="col-xs-6 col-sm-4 col-md-4 pull-right">
                <div class="search">
                    <div class="input-group">
                        <input type="text" class="form-control flat"  id="buscar_paciente_input" placeholder='{"Buscar"|x_translate}' value="{$query_str}">
                        <span class="input-group-btn">
                            <button type="submit" class="btn flat" id="btnSearchPaciente"><span class="fui-search"></span></button>
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

{literal}
<script>


    var buscarPacientes = function() {
        if ($("#from_mis_pacientes").val() != "") {
            x_loadModule('pacientes', 'mis_pacientes', 'query_str=' + $("#buscar_paciente_input").val(), 'busqueda_pacientes');
        } else {
            window.location.href = BASE_PATH + "panel-medico/mis-pacientes/" + $("#buscar_paciente_input").val() + "/";
        }
    };

    $("#buscar_paciente_input").keypress(function(e) {
        if (e.which == 13) {
            buscarPacientes();
        }
    });

    $("#btnSearchPaciente").on("click", function() {
        buscarPacientes();
    });



</script>
{/literal}

