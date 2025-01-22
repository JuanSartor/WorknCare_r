
<section class="form edit info-profesional-form form-info-facturacion" id="form_info_facturacion_container" {if $completar_info_facturacion!="1"}style="display:none;"{/if}>
    <div class="container" id="formFacturaDatos">
        <div class="vc-interrumpidas-header"  {if $completar_info_facturacion!="1"}style="display:none;"{/if}>	
            <i class="icon-doctorplus-alert-round"></i>
        </div>
        <h2 class="text-center">{"Datos de facturación"|x_translate} </h2>


        <form id="frm_info_facturacion" role="form" action="{$url}paciente_p.php?action=1&modulo=contable&submodulo=info_facturacion_form" method="post" >

            <div class="col-xs-12">

                {if $empresa.tipo_cuenta=="1"}
                    <div class="row" >

                        <div class="col-md-4 col-md-offset-2">
                            <label>{"Su empresa o establecimiento"|x_translate}</label>
                            <div class="field-edit dp-edit">
                                <input type="text"  id="empresa_input"  name="empresa" {if $empresa.tipo_cuenta=="2"}readonly{/if} value="{$empresa.empresa}" />
                            </div>
                        </div>

                        <div class="col-md-4">
                            <label>{"Número de establecimiento SIREN"|x_translate}</label>
                            <div class="field-edit dp-edit">
                                <input type="text"  id="siren_input"  name="siren" value="{$empresa.siren}" style="letter-spacing: 5px;" />
                            </div>
                        </div>

                    </div>
                {/if}

                <div class="row" >
                    <div class="col-md-4 col-md-offset-2">
                        <label>{"Dirección"|x_translate}</label>
                        <div class="field-edit dp-edit">
                            <input type="text"  id="direccion_input"  name="direccion"  value="{$empresa.direccion}" placeholder="Ex : 3 allée du bois" />
                        </div>

                    </div>
                    <div class="col-md-4">
                        <label>{"Código postal"|x_translate}</label>
                        <div class="field-edit dp-edit">
                            <input type="text"  id="codigo_postal_input"  name="codigo_postal" value="{$empresa.codigo_postal}" placeholder="Ex : 93750" />
                        </div>
                    </div>
                    <div class="col-md-4 col-md-offset-2">
                        <label>{"Ciudad"|x_translate}</label>
                        <div class="field-edit dp-edit">
                            <input type="text"  id="ciudad_input"  name="ciudad"  value="{$empresa.ciudad}" placeholder="Ex : Toulouse" />
                        </div>

                    </div>
                    <div class="col-md-4">
                        <label>{"País"|x_translate}</label>
                        <div class="okm-select-plus-box mdc-style mul-select-spacer dc-no-label" >
                            <div class="okm-select">
                                <select name="pais" id="pais" class="form-control select select-primary select-block mbl">
                                    {if $empresa.pais==""}
                                        {html_options options=$paises_sepa selected=1}
                                    {else}
                                        {html_options options=$paises_sepa selected=$empresa.pais}
                                    {/if}
                                </select>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="clearfix">&nbsp;</div>

            </div>

        </form>  
        <div class="okm-row text-center">
            <a href="javascript:;" id="btnInfoFacturacionCancelar" class="btn btn-default btn-inverse btn-xs">{"Cancelar"|x_translate}</a>
            <button id="btnGuardarInfoFacturacion" type="submit" class="btn-default btn btn-xs">{"Guardar"|x_translate}</button>
        </div>


    </div>

</section>

{literal}
    <script>
        $("body").spin(false);
        $(function () {

            $("#btnInfoFacturacionCancelar").click(function () {
                $("#form_info_facturacion_container").slideUp();
            });


            /*
             * Metodo que guarda la info de facturacion de la cuenta empresa
             */

            $("#btnGuardarInfoFacturacion").click(function () {

                //verificar nombre
                if ($("#empresa_input").val() === "" || $("#siren_input").val() === "" || $("#direccion_input").val() === "" || $("#codigo_postal_input").val() === "" || $("#pais").val() === "") {
                    x_alert(x_translate("Complete los campos obligatorios"));

                    return false;
                }


                $("body").spin("large");

                x_sendForm(
                        $('#frm_info_facturacion'),
                        true,
                        function (data) {
                            $("body").spin(false);
                            if (data.result) {
                                $("#form_info_facturacion_container").slideUp();
                                x_alert(data.msg, recargar);
                            } else {
                                x_alert(data.msg);
                            }

                        }
                );

            });


        });
    </script>
{/literal}