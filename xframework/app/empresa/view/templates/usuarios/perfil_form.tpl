<style>
    .modal-body.cropper-body img {
        max-width: 100%;
    }
    .mapc-select{
        margin-top: 0px;
    }
    .datos-registro p{
        font-style: italic;
        padding-left: 15px;
        font-size: 16px;
        display: inline-block;
    }
    .form.edit .datos-registro label {
        display: block;
        font-weight: 600;
        display: inline-block;
    }
    .form.edit .datos-registro .cont-imagen{
        float:none;
    }
</style>
<section class="form edit info-profesional-form">
    <div class="container">
        <h2 class="text-center">{"Datos de cuenta"|x_translate} </h2>


        <form id="frm_usuario" role="form" action="{$url}empresa.php?action=1&modulo=usuarios&submodulo=perfil_form" method="post" >

            <div class="col-xs-12">


                <div class="row" >

                    <div class="col-md-4 col-md-offset-2">
                        <label>{"Nombre"|x_translate}</label>
                        <div class="field-edit dp-edit">
                            <input type="text"  id="nombre"  name="nombre" value="{$usuario.nombre}" />
                        </div>
                    </div>

                    <div class="col-md-4">
                        <label>{"Apellido"|x_translate}</label>
                        <div class="field-edit dp-edit">
                            <input type="text"  id="apellido"  name="apellido" value="{$usuario.apellido}" />
                        </div>
                    </div>

                </div>

                <div class="row" >
                    <div class="col-md-4 col-md-offset-2">

                        <label>{"Su empresa o establecimiento"|x_translate}</label>
                        <div class="field-edit dp-edit">
                            <input type="empresa"  id="empresa"  name="empresa"  value="{$usuario.empresa}" />
                        </div>

                    </div>
                    <div class="col-md-4" id="container_empresa_input" {if $usuario.tipo_cuenta=="2"}style="display:none;"{/if}>
                        <label>{"Dominio de correo electronico de su empresa"|x_translate}</label>
                        <div class="dp-edit-container input-group">
                            <span class="input-group-addon" >@</span>
                            <div class="field-edit dp-edit">
                                <input type="text" class="pul-np-dis" name="dominio_email" id="dominio_email" value="{$usuario.dominio_email}" />
                            </div>
                        </div>
                    </div>

                </div>
                <div class="row" >
                    <div class="col-md-4 col-md-offset-2">
                        <label>{"Tipo de cuenta:"|x_translate}</label>
                        <div class="okm-select-plus-box mdc-style mul-select-spacer dc-no-label" >
                            <div class="okm-select">
                                <select name="tipo_cuenta_empresa" id="tipo_cuenta_empresa" class="form-control select select-primary select-block mbl">
                                    {*  <option value="1" {if $usuario.tipo_cuenta=="1"}selected{/if} readonly>{"Soy empresa, establecimiento, estructura, ayuntamiento, etc."|x_translate}</option> *}
                                    <option value="0" {if $empresa.tipo_cuenta_empresa=="0"}selected{/if} readonly>{"No definido"|x_translate}</option>
                                    <option value="1" {if $empresa.tipo_cuenta_empresa=="1"}selected{/if} readonly>{"Empresa"|x_translate}</option>
                                    <option value="2" {if $empresa.tipo_cuenta_empresa=="2"}selected{/if} readonly>{"CSE/COS"|x_translate}</option>
                                    <option value="3" {if $empresa.tipo_cuenta_empresa=="3"}selected{/if} readonly>{"Comunidad"|x_translate}</option>
                                    <option value="4" {if $empresa.tipo_cuenta_empresa=="4"}selected{/if} readonly>{"Asociacion"|x_translate}</option>
                                    {* <option value="2" {if $usuario.tipo_cuenta=="2"}selected{/if}>{"Soy un particular"|x_translate}</option>*}

                                </select>
                            </div>

                        </div>

                    </div>
                </div>
                <div class="clearfix">&nbsp;</div>

            </div>

        </form>  
        <div class="mul-submit-box">
            <button id="btnGuardarInfo" type="submit" class="save-data btn-default">{"Guardar"|x_translate}</button>
        </div>


    </div>

</section>

{include file="usuarios/datos_administrador.tpl"}

{literal}
    <script>
        $(function () {
            //mostrar ocultar campo empresa
            $('#tipo_cuenta').on('change', function () {
                if ($('#tipo_cuenta').val() === "1") {
                    console.log("empresa");
                    $("#container_empresa_input").show();
                } else {
                    console.log("particular");
                    $("#container_empresa_input").hide();
                    $("#empresa").val("");
                }
            });

            $("#btnGuardarInfo").click(function () {
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

            //verificamos dominio empresa para email de beneficiarios:
            $("#dominio_email").data("title", x_translate("Proporcione el dominio de correo electronico de su empresa para asegurar que sus beneficiarios se registraran con su  correo electronico personal y no utilizaran su correo empresarial")).tooltip({trigger: 'focus '});
            //quitamos el @ 
            $("#dominio_email").on("keyup", function () {
                if ($(this).val().indexOf("@") >= 0) {
                    $(this).val($(this).val().replace("@", ""));
                    x_alert(x_translate("Debe ingresar solo el dominio de correo electronico de su empresa que se encuentra seguido del @"));
                    return false;
                }
            });

        });
    </script>
{/literal}