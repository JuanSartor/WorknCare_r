<input type="hidden" id="check" value="{$check}">
{if $account.user.tipo_usuario|in_array:['1'] } 
    <section class="okm-container" id="div_listado_usuarios">
        <div class="table-detail">
            <div class="col-xs-12" style="margin:40px 0;" >
                <div class="table-reference">
                    <h2><button class="btn btn-transparen go-back-button btn-volver"><i class="fa fa-chevron-left"></i></button>{"Usuarios autorizados"|x_translate}:</h2>
                    <div class="ce-ca-toolbar-filter-box">
                        <div class="col-md-2 md-modificado" style="width: 198px;">
                            <label class="checkbox check-tipo-usuarios" style="margin-right: 15px;">
                                <input id='chckadmins' type="checkbox" class="select-todos-beneficiarios"  value="0"  data-toggle="checkbox" class="custom-checkbox">
                            </label>
                            <span class="txt-validacion-automatica font-check">  {"Super Administrador"|x_translate}</span> 
                        </div>
                        <div class="col-md-2 md-modificado" style="width: 180px;">
                            <label class="checkbox check-tipo-usuarios" style="margin-right: 15px;">
                                <input id='chckbeneficiarios' type="checkbox" class="select-todos-beneficiarios" value="0"  data-toggle="checkbox" class="custom-checkbox">
                            </label>
                            <span class="txt-validacion-automatica font-check">  {"Solo beneficiarios"|x_translate}</span> 
                        </div>
                        <div class="col-md-2 md-modificado" style="width: 153px;">
                            <label class="checkbox check-tipo-usuarios" style="margin-right: 15px;">
                                <input id='chckfacturas' type="checkbox" class="select-todos-beneficiarios" value="0"  data-toggle="checkbox" class="custom-checkbox">
                            </label>
                            <span class="txt-validacion-automatica font-check">  {"Solo facturas"|x_translate}</span> 
                        </div>
                        <div class="col-md-2 md-modificado" style="width: 240px;">
                            <label class="checkbox check-tipo-usuarios" style="margin-right: 15px;">
                                <input id='chckbeneyfac' type="checkbox" class="select-todos-beneficiarios" value="0"  data-toggle="checkbox" class="custom-checkbox">
                            </label>
                            <span class="txt-validacion-automatica font-check">  {"Beneficiarios y Facturas"|x_translate}</span> 
                        </div>
                        <div class="col-md-2 md-modificado" style="width: 245px;">
                            <label class="checkbox check-tipo-usuarios" style="margin-right: 15px;">
                                <input id='chckmanagers' type="checkbox" class="select-todos-beneficiarios" value="0"  data-toggle="checkbox" class="custom-checkbox">
                            </label>
                            <span class="txt-validacion-automatica font-check">  {"Solo Managers"|x_translate}</span>      
                        </div>
                        <div class="col-md-2 md-modificado" style="width: 89px;">
                            <label class="checkbox check-tipo-usuarios" style="margin-right: 15px;">
                                <input id='chcktodos' type="checkbox" class="select-todos-beneficiarios" value="0"  data-toggle="checkbox" class="custom-checkbox">
                            </label>
                            <span class="txt-validacion-automatica font-check">  {"Todos"|x_translate}</span> 
                        </div>

                        <div class="buscador" style='position: relative; bottom: 40px;' >
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

                </div>
                <div class="table table-responsive">
                    <table class="table">

                        <tr>  
                            <th>&nbsp;</th>
                            <th>{"Nombre"|x_translate}</th>
                            <th>{"Email"|x_translate}</th>  
                            <th>{"Estado"|x_translate}</th>
                            <th>{"Fecha registro"|x_translate}</th>
                            <th>{"Accesos"|x_translate}</th>
                        </tr>
                        {foreach from=$listado_usuarios.rows item=usuario}
                            <tr {if $usuario.estado=="0"}class="pendiente"{/if} data-id="{$usuario.idusuario_empresa}">
                                <td align="center">
                                    {if $usuario.contratante!="1"}
                                        <button href="javascript:;" class="btnEliminar  btn btn-xs btn-alert" data-id="{$usuario.idusuario_empresa}">
                                            <i class="fa fa-trash-o hidden-xs"></i>
                                            {"Eliminar"|x_translate}
                                        </button>
                                    {/if}
                                </td>
                                <td>{$usuario.nombre} {$usuario.apellido}</td>
                                <td>{$usuario.email}</td>  
                                <td>{if $usuario.estado=="0"}{"Pendiente de confirmación"|x_translate}{else}{"Inscripto"|x_translate}{/if}</td>
                                <td>{$usuario.fecha_alta_format}</td>
                                <td>
                                    {if $usuario.contratante=="1"}
                                        {"Contratante"|x_translate}
                                    {else}
                                        <div class="okm-select">
                                            <select name="tipo_usuario" data-id="{$usuario.idusuario_empresa}" class="form-control change_tipo_usuario">
                                                <option value="1" {if $usuario.tipo_usuario=="1"}selected{/if}>{"Super Administrador"|x_translate}</option>
                                                <option value="2" {if $usuario.tipo_usuario=="2"}selected{/if}>{"Solo facturas"|x_translate}</option>
                                                <option value="3" {if $usuario.tipo_usuario=="3"}selected{/if}>{"Beneficiarios"|x_translate}</option>
                                                <option value="4" {if $usuario.tipo_usuario=="4"}selected{/if}>{"Beneficiarios y Facturas"|x_translate}</option>
                                                <option value="5" {if $usuario.tipo_usuario=="5"}selected{/if}>{"Cuestionarios"|x_translate}</option>
                                            </select>
                                        </div>
                                    {/if}
                                </td>
                            </tr>
                        {/foreach}


                    </table>
                </div>
                {if $listado_usuarios.rows && $listado_usuarios.rows|@count > 0}
                    <div class="paginas">

                        {x_paginate_loadmodule_v2  id="$idpaginate" modulo="usuarios"
            submodulo="usuarios_listado" 
            container_id="Main"}

                    </div>
                {else}
                    <div class="col-xs-12">
                        <div class="row">
                            <p class="text-center"> {"Sin usuarios autorizados"|x_translate}</p>
                        </div>
                    </div>
                {/if}
            </div>
        </div>
        <div class="okm-row text-center">
            <a href="javascript:;" class="btn btn-inverse " id="btnCancelarUsuario" style="display:none;"><i class="fa fa-timkes"></i>{"Cancelar"|x_translate}</a>
            <a href="javascript:;" class="btn btn-default " id="btnAgregarUsuario"><i class="fa fa-plus"></i>{"Agregar usuario"|x_translate}</a>
        </div>
        <div class="clearfix">&nbsp;</div>
    </section>
    <section class="form edit info-profesional-form" id="form_usuario_container" style="display:none;">
        <div class="container">
            <h2 class="text-center">{"Datos de cuenta"|x_translate} </h2>


            <form id="frm_usuario" role="form" action="{$url}empresa.php?action=1&modulo=usuarios&submodulo=usuario_secundario_form" method="post" >

                <div class="col-xs-12">


                    <div class="row" >

                        <div class="col-md-4 col-md-offset-2">
                            <label>{"Nombre"|x_translate}</label>
                            <div class="field-edit dp-edit">
                                <input type="text"  id="nombre_input"  name="nombre" value="" />
                            </div>
                        </div>

                        <div class="col-md-4">
                            <label>{"Apellido"|x_translate}</label>
                            <div class="field-edit dp-edit">
                                <input type="text"  id="apellido_input"  name="apellido" value="" />
                            </div>
                        </div>

                    </div>

                    <div class="row" >
                        <div class="col-md-4 col-md-offset-2">
                            <label>{"Email"|x_translate}</label>
                            <div class="field-edit dp-edit">
                                <input type="email"  id="email_input"  name="email"  value="" />
                            </div>

                        </div>
                        <div class="col-md-4" id="container_empresa_input" {if $usuario.tipo_cuenta=="2"}style="display:none;"{/if}>

                            <label>{"Accesos"|x_translate}</label>
                            <div class="okm-select-plus-box mdc-style mul-select-spacer dc-no-label" >
                                <div class="okm-select">
                                    <select name="tipo_usuario" id="tipo_usuario" class="form-control select select-primary select-block mbl">
                                        <option value="1" >{"Super Administrador"|x_translate}</option>
                                        <option value="2" >{"Usuario Facturas"|x_translate}</option>
                                        <option value="3" >{"Beneficiarios"|x_translate}</option>
                                        <option value="4" >{"Beneficiarios y Facturas"|x_translate}</option>
                                        <option value="5" >{"Cuestionarios"|x_translate}</option>
                                    </select>
                                </div>

                            </div>
                        </div>
                    </div>

                    <div class="clearfix">&nbsp;</div>

                </div>

            </form>  
            <div class="mul-submit-box">
                <button id="btnGuardarUsuario" type="submit" class="save-data btn-default">{"Guardar"|x_translate}</button>
            </div>


        </div>

    </section>
    <script>  var checkrecibido = "{$check}";
    </script>
    {literal}
        <script>
            $("body").spin(false);
            $(function () {

                $(document).ready(function () {
                    //  console.log(checkrecibido);
                    switch (checkrecibido) {
                        case '0':
                            $("#chckadmins").prop("checked", false);
                            $("#chckbeneficiarios").prop("checked", false);
                            $("#chckfacturas").prop("checked", false);
                            $("#chckmanagers").prop("checked", false);
                            $("#chckbeneyfac").prop("checked", false);
                            $("#chcktodos").prop("checked", true);
                            break;
                        case '1':
                            $("#chckadmins").prop("checked", true);
                            $("#chckbeneficiarios").prop("checked", false);
                            $("#chckfacturas").prop("checked", false);
                            $("#chckmanagers").prop("checked", false);
                            $("#chckbeneyfac").prop("checked", false);
                            $("#chcktodos").prop("checked", false);
                            break;
                        case '2':
                            $("#chckadmins").prop("checked", false);
                            $("#chckbeneficiarios").prop("checked", false);
                            $("#chckfacturas").prop("checked", true);
                            $("#chckmanagers").prop("checked", false);
                            $("#chckbeneyfac").prop("checked", false);
                            $("#chcktodos").prop("checked", false);
                            break;
                        case '3':
                            $("#chckadmins").prop("checked", false);
                            $("#chckbeneficiarios").prop("checked", true);
                            $("#chckfacturas").prop("checked", false);
                            $("#chckmanagers").prop("checked", false);
                            $("#chckbeneyfac").prop("checked", false);
                            $("#chcktodos").prop("checked", false);
                            break;
                        case '4':
                            $("#chckadmins").prop("checked", false);
                            $("#chckbeneficiarios").prop("checked", false);
                            $("#chckfacturas").prop("checked", false);
                            $("#chckmanagers").prop("checked", false);
                            $("#chckbeneyfac").prop("checked", true);
                            $("#chcktodos").prop("checked", false);
                            break;
                        case '5':
                            $("#chckadmins").prop("checked", false);
                            $("#chckbeneficiarios").prop("checked", false);
                            $("#chckfacturas").prop("checked", false);
                            $("#chckmanagers").prop("checked", true);
                            $("#chckbeneyfac").prop("checked", false);
                            $("#chcktodos").prop("checked", false);
                            break;

                    }
                });

                //volver a la home

                $(".btn-volver").click(function () {
                    $("#Main").spin("large");
                    x_loadModule('home', 'home', '', 'Main');
                });
                $("#btnAgregarUsuario").click(function () {
                    $("#btnAgregarUsuario").hide();
                    $("#btnCancelarUsuario").show();
                    $("#form_usuario_container").slideDown();
                });

                $("#btnCancelarUsuario").click(function () {
                    $("#btnCancelarUsuario").hide();
                    $("#btnAgregarUsuario").show();
                    $("#form_usuario_container").slideUp();
                });


                //boton filtro de consultas finalizadas por fecha
                $("#btnAplicarFiltro").click(function () {
                    $("body").spin("large");
                    x_loadModule('usuarios', 'usuarios_listado', 'do_reset=1&filtro_busqueda=' + $("#filtro_busqueda").val(), 'Main').then(function () {
                        renderUI2();
                        $("body").spin(false);
                    });
                });
                /*
                 * Metodo que agrega un usuario seccundario al acceso a la cuenta empresa
                 */

                $("#btnGuardarUsuario").click(function () {

                    //verificar nombre
                    if ($("#nombre_input").val() == "") {
                        $("#nombre_input").data("title", x_translate("Ingrese su nombre")).tooltip("show");
                        $('html, body').animate({
                            scrollTop: $("#nombre_input").offset().top - 200}, 1000);
                        return false;
                    }

                    //verificar apellido
                    if ($("#apellido_input").val() == "") {
                        $("#apellido_input").data("title", x_translate("Ingrese su apellido")).tooltip("show");
                        $('html, body').animate({
                            scrollTop: $("#apellido_input").offset().top - 200}, 1000);
                        return false;
                    }

                    if (!validarEmail($("#email_input").val())) {
                        $("#email_input").data("title", x_translate("Ingrese un email válido")).tooltip("show");
                        $('html, body').animate({
                            scrollTop: $("#email_input").offset().top - 200}, 1000);
                        return false;
                    }

                    $("body").spin("large");

                    x_sendForm(
                            $('#frm_usuario'),
                            true,
                            function (data) {
                                $("body").spin(false);
                                if (data.result) {
                                    x_alert(data.msg, recargar);
                                } else {
                                    x_alert(data.msg);
                                }

                            }
                    );

                });

                //eliminamos el usuario
                $(".btnEliminar").on("click", function () {
                    var id = $(this).data("id");
                    if (id) {


                        jConfirm({
                            title: x_translate("Eliminar usuario"),
                            text: x_translate('Está por elimiaar el acceso del usuario. ¿Desea continuar?'),
                            confirm: function () {
                                $("body").spin("large");
                                x_doAjaxCall(
                                        'POST',
                                        BASE_PATH + 'empresa.php?action=1&modulo=usuarios&submodulo=eliminar_usuario',
                                        'id=' + id,
                                        function (data) {
                                            $("body").spin(false);
                                            if (data.result) {
                                                x_alert(data.msg, recargar);
                                            } else {
                                                x_alert(data.msg);
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

                //cambiar permisos al usuario
                $(".change_tipo_usuario").on("change", function () {
                    var id = $(this).data("id");
                    var tipo_usuario = $(".change_tipo_usuario[data-id=" + id + "]").val();
                    if (id) {
                        $("body").spin("large");
                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + 'empresa.php?action=1&modulo=usuarios&submodulo=cambiar_permisos_usuario',
                                'id=' + id + '&tipo_usuario=' + tipo_usuario,
                                function (data) {
                                    $("body").spin(false);
                                    x_alert(data.msg);
                                }
                        );
                    }
                });

                /*
                 * check 1 admin
                 *       2 facturacion
                 *       3 beneficiarios
                 *       4 beneficiarios y facturacion
                 *       5 cuestionarios  
                 */

                $('#chcktodos').on('change', function () {
                    if ($('#chcktodos').is(':checked')) {
                        $("#chckbeneficiarios").prop("checked", false);
                        $("#chckfacturas").prop("checked", false);
                        $("#chckmanagers").prop("checked", false);
                        $("#chckbeneyfac").prop("checked", false);
                        $("#chckadmins").prop("checked", false);
                        $("body").spin("large");
                        x_loadModule('usuarios', 'usuarios_listado', 'do_reset=1&filtro_busqueda=' + $("#filtro_busqueda").val() + '&check=0', 'Main').then(function () {
                            $("body").spin(false);
                            renderUI2();
                        });
                    }
                });
                $('#chckadmins').on('change', function () {
                    if ($('#chckadmins').is(':checked')) {
                        $("#chckbeneficiarios").prop("checked", false);
                        $("#chckfacturas").prop("checked", false);
                        $("#chckmanagers").prop("checked", false);
                        $("#chckbeneyfac").prop("checked", false);
                        $("#chcktodos").prop("checked", false);
                        $("body").spin("large");
                        x_loadModule('usuarios', 'usuarios_listado', 'do_reset=1&filtro_busqueda=' + $("#filtro_busqueda").val() + '&check=1', 'Main').then(function () {
                            $("body").spin(false);
                            renderUI2();
                        });
                    }
                });

                $('#chckbeneficiarios').on('change', function () {
                    if ($('#chckbeneficiarios').is(':checked')) {
                        $("#chcktodos").prop("checked", false);
                        $("#chckfacturas").prop("checked", false);
                        $("#chckmanagers").prop("checked", false);
                        $("#chckbeneyfac").prop("checked", false);
                        $("#chckadmins").prop("checked", false);
                        $("body").spin("large");
                        x_loadModule('usuarios', 'usuarios_listado', 'do_reset=1&filtro_busqueda=' + $("#filtro_busqueda").val() + '&check=3', 'Main').then(function () {
                            $("body").spin(false);
                            renderUI2();
                        });
                        //   window.location.href = BASE_PATH + "entreprises/questionnairelist/" + id_familia_cuestionarios + ".html";

                    }
                });

                $('#chckfacturas').on('change', function () {
                    if ($('#chckfacturas').is(':checked')) {
                        $("#chckbeneficiarios").prop("checked", false);
                        $("#chcktodos").prop("checked", false);
                        $("#chckmanagers").prop("checked", false);
                        $("#chckbeneyfac").prop("checked", false);
                        $("#chckadmins").prop("checked", false);
                        $("body").spin("large");
                        x_loadModule('usuarios', 'usuarios_listado', 'do_reset=1&filtro_busqueda=' + $("#filtro_busqueda").val() + '&check=2', 'Main').then(function () {
                            $("body").spin(false);
                            renderUI2();
                        });
                    }
                });

                $('#chckmanagers').on('change', function () {
                    if ($('#chckmanagers').is(':checked')) {
                        $("#chckbeneficiarios").prop("checked", false);
                        $("#chckfacturas").prop("checked", false);
                        $("#chcktodos").prop("checked", false);
                        $("#chckbeneyfac").prop("checked", false);
                        $("#chckadmins").prop("checked", false);
                        $("body").spin("large");
                        x_loadModule('usuarios', 'usuarios_listado', 'do_reset=1&filtro_busqueda=' + $("#filtro_busqueda").val() + '&check=5', 'Main').then(function () {
                            $("body").spin(false);
                            renderUI2();
                        });
                    }
                });

                $('#chckbeneyfac').on('change', function () {
                    if ($('#chckbeneyfac').is(':checked')) {
                        $("#chckbeneficiarios").prop("checked", false);
                        $("#chckfacturas").prop("checked", false);
                        $("#chcktodos").prop("checked", false);
                        $("#chckmanagers").prop("checked", false);
                        $("#chckadmins").prop("checked", false);
                        $("body").spin("large");
                        x_loadModule('usuarios', 'usuarios_listado', 'do_reset=1&filtro_busqueda=' + $("#filtro_busqueda").val() + '&check=4', 'Main').then(function () {
                            $("body").spin(false);
                            renderUI2();
                        });
                    }
                });






            });
        </script>
    {/literal}
{/if}