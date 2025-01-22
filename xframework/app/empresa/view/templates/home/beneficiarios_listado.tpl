
{if $account.user.tipo_usuario|in_array:['1','3','4'] } 
    {include file="home/popover_beneficiarios.tpl"}
    <section class="okm-container">
        <div class="okm-row table-detail">
            <div class="col-xs-12" style="margin:40px 0;" >
                <div class="table-reference">
                    <h2><button class="btn btn-transparent go-back-button btn-volver"><i class="fa fa-chevron-left"></i></button> {"Sus beneficiarios registrados"|x_translate}:</h2>
                    <div class="ce-ca-toolbar-filter-box">

                        <div class="dropdown pull-left">
                            <button class="btn btn-xs btn-white dropdown-toggle" type="button" id="dropdown-notificaciones" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
                                {"Acciones"|x_translate}
                                <span class="caret"></span>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-left" aria-labelledby="dropdown-notificaciones">
                                <li><a href="javascript:;" class="btnAceptarPaciente  btn btn-xs btn-default" data-id="{$beneficiario.idpaciente_empresa}"  {if $beneficiario.estado=="1"}style="display:none"{/if}>
                                        <i class="fa fa-check hidden-xs"></i>
                                        {"Activar"|x_translate}
                                    </a>
                                </li>

                                <li> <a href="javascript:;" class="btnSuspenderPaciente  btn btn-xs btn-yellow" data-id="{$beneficiario.idpaciente_empresa}"  {if $beneficiario.estado=="0"}style="display:none"{/if}>
                                        <i class="fa fa-pause hidden-xs"></i>
                                        {"Suspender"|x_translate}
                                    </a>
                                </li>
                                <li> <a href="javascript:;" class="btnEliminarPaciente  btn btn-xs btn-alert" data-id="{$beneficiario.idpaciente_empresa}" >
                                        <i class="fa fa-trash-o hidden-xs"></i>
                                        {"Eliminar"|x_translate}
                                    </a>  </li>
                                <li>
                                    <a class="btn btn-xs btn-default btn-inverse btnExportarBeneficiarios" href="{$url}empresa.php?action=1&modulo=home&submodulo=exportar_beneficiarios_xls"><i class="fa fa-file-excel-o"></i>{"Exportar"|x_translate}</a>
                                </li>
                            </ul>
                        </div>

                        <div class="ce-ca-toolbar-desde-box">
                            <label>{"Buscar"|x_translate}:
                                <input type="text" id="filtro_busqueda" name="filtro_busqueda" value="{$smarty.request.filtro_busqueda}"/>
                            </label>
                        </div>
                        <div class="ce-ca-toolbar-action-box">
                            <button id="btnAplicarFiltro"><i class="icon-doctorplus-search"></i></button>
                        </div>
                    </div>

                </div>
                <div class="table table-responsive listado-beneficiarios">
                    <table class="table">
                        <thead>
                            <tr>  
                                <th width="10px" class="select-all">
                                    <label class="checkbox">
                                        <input type="checkbox" class="select-todos-beneficiarios" value=""  data-toggle="checkbox" class="custom-checkbox">
                                    </label>
                                </th>
                                <th>{"Beneficiario"|x_translate}</th>
                                    {*<th>{"Email"|x_translate}</th>*}
                                <th>{"Fecha registro"|x_translate}</th>
                                <th>{"Estado"|x_translate}</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach from=$listado_beneficiarios.rows item=beneficiario}
                                <tr {if $beneficiario.estado=="0" || $beneficiario.estado=="2"}class="pendiente"{/if} data-id="{$beneficiario.idpaciente_empresa}"  >
                                    <td align="center">

                                        <label class="checkbox">
                                            <input type="checkbox" class="select-beneficiario" value="{$beneficiario.idpaciente_empresa}"  data-toggle="checkbox" class="custom-checkbox">
                                        </label>

                                    </td>
                                    <td>{$beneficiario.nombre} {$beneficiario.apellido}</td>
                                    {*<td>{$beneficiario.email}</td>*}  
                                    <td>{$beneficiario.fecha_alta_format}</td>
                                    <td>
                                        <span class="estado" data-estado="2" {if $beneficiario.estado=="0" || $beneficiario.estado=="1"}style="display:none"{/if}>{"Suspendido"|x_translate}</span>

                                        <span class="estado" data-estado="0" {if $beneficiario.estado=="1" || $beneficiario.estado=="2"}style="display:none"{/if}>{"Pendiente de confirmación"|x_translate}</span>

                                        <span class="estado" data-estado="1" {if $beneficiario.estado=="0" || $beneficiario.estado=="2"}style="display:none"{/if}>{"Activo"|x_translate}</span>

                                    </td>

                                </tr>
                            {/foreach}
                        </tbody>

                    </table>
                </div>
                {if $listado_beneficiarios.rows && $listado_beneficiarios.rows|@count > 0}
                    <div class="paginas">

                        {x_paginate_loadmodule_v2  id="$idpaginate" modulo="home"
            submodulo="beneficiarios_listado" 
            container_id="Main"}

                    </div>
                {else}
                    <div class="col-xs-12">
                        <div class="row">
                            <p class="text-center"> {"Sin beneficiarios registrados"|x_translate}</p>
                        </div>
                    </div>
                {/if}
            </div>
            <div class="okm-row text-center">
                <a href="javascript:;" class="btn btn-inverse btn-volver" style="background:#455a64">{"volver"|x_translate}</a>
            </div>
        </div>


        <div class="clearfix">&nbsp;</div>
    </section>


    {literal}
        <script>
            $("body").spin(false);

            $(".btnExportarBeneficiarios").click(function (e) {

                var ids = "";
                $(".select-beneficiario:checked").each(function () {
                    ids += ',' + $(this).val();
                });
                if (ids.length > 0) {
                    ids = ids.substring(1);
                }
                var new_url = $(this).attr("href") + "&ids=" + ids;
                $(this).attr("href", new_url);
            });
            $(function () {
                $('td[data-popover]').gpopover({
                    preventHide: true, width: 'auto', onHide: function (e) {
                        console.log("hiding");
                        $("#popover-beneficiarios").css("display", "block !important");
                    }   // Called upon hiding the popover
                }).trigger("click");

                //volver a la home

                $(".btn-volver").click(function () {
                    $("#Main").spin("large");
                    window.location.href = BASE_PATH + "entreprises/";
                });

                //boton filtro de consultas finalizadas por fecha
                $("#btnAplicarFiltro").click(function () {
                    $("body").spin("large");
                    x_loadModule('home', 'beneficiarios_listado', 'do_reset=1&filtro_busqueda=' + $("#filtro_busqueda").val(), 'Main').then(function () {
                        $("body").spin(false);
                    });
                });

                //eliminamos la consulta en borrador y recargamos
                $(".btnAceptarPaciente").on("click", function () {
                    var ids = "";
                    $(".select-beneficiario:checked").each(function () {
                        ids += ',' + $(this).val();
                    });
                    if (ids.length > 0) {
                        ids = ids.substring(1);
                    }
                    console.log(ids);
                    if (ids) {


                        jConfirm({
                            title: x_translate("Aceptar beneficiario"),
                            text: x_translate('Está por aceptar el acceso de un beneficiario. ¿Desea continuar?'),
                            confirm: function () {
                                $("body").spin("large");
                                x_doAjaxCall(
                                        'POST',
                                        BASE_PATH + 'empresa.php?action=1&modulo=home&submodulo=aceptar_beneficiario',
                                        'ids=' + ids,
                                        function (data) {

                                            x_loadModule('home', 'beneficiarios_listado', 'do_reset=1&filtro_busqueda=' + $("#filtro_busqueda").val(), 'Main').then(function () {
                                                $("body").spin(false);
                                                renderUI2();
                                            });

                                            if (data.result == true) {
                                                x_alert(data.msg);
                                            } else {
                                                x_alert(x_translate("Error, no se pudo activar el beneficiario"));
                                            }

                                        }
                                );
                            },
                            cancel: function () {

                            },
                            confirmButton: x_translate("Si"),
                            cancelButton: x_translate("No")
                        });
                    }
                });
                //suspendemos el beneficiario, no puede utilizar mas el pass
                $(".btnSuspenderPaciente").on("click", function () {
                    var ids = "";
                    $(".select-beneficiario:checked").each(function () {
                        ids += ',' + $(this).val();
                    });
                    if (ids.length > 0) {
                        ids = ids.substring(1);
                    }
                    console.log(ids);
                    if (ids) {


                        jConfirm({
                            title: x_translate("Suspender beneficiario"),
                            text: x_translate('Está por suspender el acceso de un beneficiario. ¿Desea continuar?'),
                            confirm: function () {
                                $("body").spin("large");
                                x_doAjaxCall(
                                        'POST',
                                        BASE_PATH + 'empresa.php?action=1&modulo=home&submodulo=rechazar_beneficiario',
                                        'ids=' + ids,
                                        function (data) {

                                            x_loadModule('home', 'beneficiarios_listado', 'do_reset=1&filtro_busqueda=' + $("#filtro_busqueda").val(), 'Main').then(function () {
                                                $("body").spin(false);
                                                renderUI2();
                                            });

                                            x_alert(data.msg);

                                        }
                                );
                            },
                            cancel: function () {

                            },
                            confirmButton: x_translate("Si"),
                            cancelButton: x_translate("No")
                        });
                    }
                });


                //eliminamos el paciente del listado, solo cuando no ha utilizado el pass
                $(".btnEliminarPaciente").on("click", function () {
                    var ids = "";
                    $(".select-beneficiario:checked").each(function () {
                        ids += ',' + $(this).val();
                    });
                    if (ids.length > 0) {
                        ids = ids.substring(1);
                    }
                    console.log(ids);
                    if (ids) {

                        jConfirm({
                            title: x_translate("Eliminar beneficiario"),
                            text: x_translate('Está por eliminar un beneficiario del listado. Esta acción no puede deshacerse. ¿Desea continuar?'),
                            confirm: function () {
                                $("body").spin("large");
                                x_doAjaxCall(
                                        'POST',
                                        BASE_PATH + 'empresa.php?action=1&modulo=home&submodulo=eliminar_beneficiario',
                                        'ids=' + ids,
                                        function (data) {


                                            x_loadModule('home', 'beneficiarios_listado', 'do_reset=1&filtro_busqueda=' + $("#filtro_busqueda").val(), 'Main').then(function () {
                                                $("body").spin(false);
                                                renderUI2();
                                            });

                                            x_alert(data.msg);

                                        }
                                );
                            },
                            cancel: function () {

                            },
                            confirmButton: x_translate("Si"),
                            cancelButton: x_translate("No")
                        });
                    }
                });

                //check - seleccionar todos los beneficiarios
                $(".select-todos-beneficiarios").change(function () {
                    if ($(this).is(":checked")) {
                        $(".select-beneficiario").radiocheck('check');
                    } else {
                        $(".select-beneficiario").radiocheck('uncheck');
                    }


                });

                $('.select-beneficiario').on('click', function () {
                    console.log("aa");

                });

            });
        </script>
    {/literal}
{/if}