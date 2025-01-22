<input type="hidden" id="idperfilSaludControlVisual" value="{$perfilSaludControlVisual.idperfilSaludControlVisual}"/>

{if $smarty.request.print==1}
{include file="perfil_salud/header_perfil_salud_imprimir.tpl"}
{else}
{include file="perfil_salud/menu_perfil_salud.tpl"}
<section class="module-header container-fluid">
    <div class="row ">
        <div class="col-md-12">
            <div class="container">
                <ol class="breadcrumb">
                    <li><a href="{$url}panel-medico/">{"Inicio"|x_translate}</a></li>
                </ol>
            </div>
        </div>
    </div>
</section>
{/if}

{*<section class="ok-container pps-prox">
    <div class="pps-prox-header">
        <figure><i class="icon-doctorplus-visual"></i></figure>
        <h1>{"Control visual"|x_translate}</h1>
    </div>

</section>*}

<section class="container pul-control-visual">


    <div class="row">
        <div class="col-sm-12 col-md-11 col-center">
            <div class="control-visual-card">
                <form  id="control-visual-oftalmologico" method="post" action="{$url}save_control_visual_oftalmologico_m.do" onsubmit="return false;">

                    <div class="card-select-top">
                        <span>1. {"¿Se le realizó algún control oftalmológico?"|x_translate}</span>
                        <figure>
                            <input id="btnControlOftalmologico" class="switch" type="checkbox"  data-toggle="switch" name="control_oftalmologico" data-on-text='{"SI"|x_translate}' data-off-text='{"NO"|x_translate}' {if $perfilSaludControlVisual.control_oftalmologico==1}checked{/if} />
                        </figure>
                    </div>
                    <div class="control-visual-toggle" {if $perfilSaludControlVisual.control_oftalmologico==1}style="display:block;"{else}style="display:none;"{/if}>

                         <div class="control-visual-check-col">
                            <div class="control-visual-check-row">
                                <label class="check-name">{"Recién nacido"|x_translate}</label>
                                <label class="checkbox" for="recien_nacido">
                                    <input type="checkbox" value="1" name="recien_nacido" id="recien_nacido" {if $perfilSaludControlVisual.recien_nacido==1}checked{/if} data-toggle="checkbox">
                                </label>
                            </div>
                            <div class="control-visual-check-row">
                                <label class="check-name">{"12 meses"|x_translate}</label>
                                <label class="checkbox" for="12_meses">
                                    <input type="checkbox" value="1" name="12_meses" id="12_meses" {if $perfilSaludControlVisual.12_meses==1}checked{/if}  data-toggle="checkbox">
                                </label>
                            </div>
                            <div class="control-visual-check-row">
                                <label class="check-name">{"3 años"|x_translate}</label>
                                <label class="checkbox" for="3_anios">
                                    <input type="checkbox" value="1" name="3_anios" id="3_anios" {if $perfilSaludControlVisual.3_anios==1}checked{/if} data-toggle="checkbox">
                                </label>
                            </div>
                            <div class="control-visual-check-row">
                                <label class="check-name">{"5 años"|x_translate}</label>
                                <label class="checkbox" for="5_anios">
                                    <input type="checkbox" value="1" name="5_anios" id="5_anios" {if $perfilSaludControlVisual.5_anios==1}checked{/if} data-toggle="checkbox">
                                </label>
                            </div>
                            <div class="control-visual-check-row">
                                <label class="check-name">{"Más de 6 años"|x_translate}</label>
                                <label class="checkbox" for="6_anios">
                                    <input type="checkbox" value="1" name="6_anios" id="6_anios" {if $perfilSaludControlVisual.6_anios==1}checked{/if} data-toggle="checkbox">
                                </label>
                            </div>
                            <div class="control-visual-check-row">
                                <label class="check-name">{"Más de 12 años"|x_translate}</label>
                                <label class="checkbox" for="12_anios">
                                    <input type="checkbox" value="1" name="12_anios" id="12_anios" {if $perfilSaludControlVisual.12_anios==1}checked{/if} data-toggle="checkbox">
                                </label>
                            </div>
                        </div>
                        <div class="control-visual-action-row">
                            <button id="btnGuardarControlOftalmologico" class="btn-alert ">{"guardar datos"|x_translate}</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-sm-12 col-md-11 col-center">
            <div class="control-visual-card">
                <form  id="control-visual-anteojos" method="post" action="{$url}save_control_visual_anteojos_m.do" onsubmit="return false;">
                    <div class="card-select-top">
                        <span>2. {"¿Usa anteojos?"|x_translate}</span>
                        <figure>
                            <input id="btnControlAnteojos" class="switch" type="checkbox"  data-toggle="switch" name="usa_anteojos"  {if $perfilSaludControlVisual.usa_anteojos==1}checked{/if}  data-on-text='{"SI"|x_translate}' data-off-text='{"NO"|x_translate}' />
                        </figure>
                    </div>

                    <div class="control-visual-toggle" {if $perfilSaludControlVisual.usa_anteojos==1}style="display:block;"{else}style="display:none;"{/if}>
                         <div class="anteojos-col">

                            <div class="anteojos-input-row">
                                <div class="anteojos-check-col">
                                    <label class="checkbox" for="anteojos_lejos">
                                        <input type="checkbox" value="1" name="lejos" id="anteojos_lejos"  {if $perfilSaludControlVisual.lejos==1}checked{/if} data-toggle="checkbox">
                                               {"Lejos"|x_translate}
                                    </label>
                                </div>

                                <div class="anteojos-input-col">
                                    <label>{"Ojo Derecho"|x_translate}</label>
                                    <input id="lejos_OD" type="text" name="lejos_OD" value="{$perfilSaludControlVisual.lejos_OD}">
                                    <div class="anteojos-input-col-divider"></div>
                                    <label>{"Ojo Izquierdo"|x_translate}</label>
                                    <input id="lejos_OI" type="text" name="lejos_OI" value="{$perfilSaludControlVisual.lejos_OI}">
                                </div>
                            </div>

                            <div class="anteojos-input-row">
                                <div class="anteojos-check-col">
                                    <label class="checkbox" for="anteojos_cerca">
                                        <input type="checkbox" value="1" name="cerca" id="anteojos_cerca"  {if $perfilSaludControlVisual.cerca==1}checked{/if} data-toggle="checkbox">
                                               {"Cerca"|x_translate}
                                    </label>
                                </div>

                                <div class="anteojos-input-col">
                                    <label>{"Ojo Derecho"|x_translate}</label>
                                    <input id="cerca_OD" type="text" name="cerca_OD" value="{$perfilSaludControlVisual.cerca_OD}">
                                    <div class="anteojos-input-col-divider"></div>
                                    <label>{"Ojo Izquierdo"|x_translate}</label>
                                    <input id="cerca_OI" type="text" name="cerca_OI" value="{$perfilSaludControlVisual.cerca_OI}">
                                </div>
                            </div>

                            <div class="anteojos-input-row">
                                <div class="anteojos-radio-col">

                                    <label class="radio" for="bifocal">
                                        <input type="radio" name="bifocal" value="1" id="bifocal" {if $perfilSaludControlVisual.bifocal==1}checked{/if} data-toggle="radio">
                                               {"Bifocal"|x_translate}
                                    </label>

                                    <label class="radio" for="multifocal">
                                        <input type="radio" name="bifocal" value="0" id="multifocal" {if $perfilSaludControlVisual.bifocal==0}checked{/if} data-toggle="radio">
                                               {"Multifocal"|x_translate}
                                    </label>

                                </div>
                            </div>

                            <div class="control-visual-action-row">
                                <button id="btnGuardarControlAnteojos" class="btn-alert">{"guardar datos"|x_translate}</button>
                            </div>

                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>


    <div class="row">
        <div class="col-sm-12 col-md-11 col-center">
            <div class="control-visual-card">
                <form name="control-visual-antecedentes" id="control-visual-antecedentes" method="post">
                    <div class="card-select-top">
                        <h3>{"Antecedentes"|x_translate}</h3>
                    </div>
                    <div class="antecedentes-holder">

                        <div class="row user-select">
                            <div class="col-md-6">
                                <h1 class="box-header">{"Cirugía Ocular"|x_translate}</h1>
                                <ul class="select-box">
                                    {foreach from=$cirugia_ocular_list item=cirugia_ocular}
                                    <li data-idcirugia_ocular="{$cirugia_ocular.idcirugia_ocular}">{$cirugia_ocular.cirugia_ocular}</li>
                                    {/foreach}

                                </ul>

                            </div>
                            <div class="col-md-6">
                                <button class="add-items btn-inverse btn" id="add-patologia">{"agregar"|x_translate}</button>
                                <div class="tagsinput-primary">
                                    <input name="tagsinput" class="tagsinput" id="patologia-tag"  value="" />
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-12">
                                <div class="antecedentes-otras-patologias">
                                    <div class="antecedentes-otras-patologias-label">
                                        <label class="checkbox" for="otra-patologia">
                                            <input type="checkbox" value="" name="otra-patologia" id="otra-patologia" data-toggle="checkbox">
                                            {"Otra"|x_translate}
                                        </label>
                                    </div>

                                    <div class="input-add-pato-group">
                                        <input type="text" disabled="true" name="otro_antecedente" id="otro_antecedente" placeholder='{"Indique cuál"|x_translate}'/>
                                        <button disabled id="agregar-otra-patologia"><i class="icon-doctorplus-plus"></i></button>
                                    </div>
                                </div>
                            </div>
                        </div>


                    </div>


                </form>
            </div>
        </div>
    </div>


    <div class="row">
        <div class="col-sm-12 col-md-11 col-center">
            <div class="control-visual-card">
                <form name="control-visual-patologias-actuales" id="control-visual-patologias-actuales" method="post">
                    <div class="card-select-top-tittle">
                        <h3>{"Patologías actuales"|x_translate}</h3>
                    </div>
                    <div class="card-select-top">
                        <span>1. {"¿Posee alguna patología actual?"|x_translate}</span>
                        <figure>
                            <input id="btnPatologiasActuales" class="switch" type="checkbox" unchecked  data-toggle="switch" name="patologia-actual" data-on-text='{"SI"|x_translate}' data-off-text='{"NO"|x_translate}' {if $list_patologias_actuales|@count>0}checked{/if}/>
                        </figure>
                    </div>

                    <div class="control-visual-toggle" {if $list_patologias_actuales|@count>0}style="display:block;"{else}style="display:none;"{/if}>

                        <div class="antecedentes-holder">

                            <div class="row user-select">
                                <div class="col-md-6">

                                    <div class="patologia-actual-input-row">
                                        <input type="text" name="patologia-actual-name" id="patologia-actual-name" placeholder='{"Indique cuál"|x_translate}'>
                                    </div>
                                    <div class="patologia-actual-tags-holder">
                                        <div class="tagsinput-primary">
                                            <input name="tagsinput" class="tagsinput" id="patologia-actual-tag"  value="" />
                                        </div>
                                    </div>

                                </div>

                                <div class="col-md-6">
                                    <button class="add-items  add-patologia-actual btn-inverse btn" id="patologia-actual-add">{"agregar"|x_translate}</button>
                                </div>
                            </div>

                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>


</section>

{literal}
<script>
    $(function () {
        $('.tagsinput').tagsinput({
            allowDuplicates: false,
            itemValue: 'id',
            itemText: 'text'
        });
        $("ul.slider-menu li a").removeClass("active");
        $("ul.slider-menu li i.dpp-ojo").parent().addClass("active");


        $('.switch').bootstrapSwitch();
        $(':checkbox').radiocheck();
        $(':radio').radiocheck();

        $('.select-box li').on('click', function () {
            $(this).parent('.select-box').find('li').removeClass('active');
            $(this).addClass('active');
        });

        //antecedentes
        $('#add-patologia').on('click', function (event) {
            event.preventDefault();

            var seleccionado = $('.select-box').find('.active');
            var id = seleccionado.data("idcirugia_ocular");

            if (parseInt(id) > 0) {
                $("#control-visual-sntecedentes").parent().parent().spin("large");
                x_doAjaxCall(
                        "POST",
                        BASE_PATH + "add_control_visual_antecedentes_m.do",
                        "idcirugia_ocular=" + id + "&idperfilSaludControlVisual=" + $("#idperfilSaludControlVisual").val(),
                        function (data) {
                            $("#control-visual-sntecedentes").parent().parent().spin(false);
                            if (data.result) {
                                $('#patologia-tag').tagsinput('add', {"id": data.id, "text": seleccionado.text()});
                            } else {
                                x_alert(data.msg);
                            }

                        }
                );
            } else {
                x_alert(x_translate("Indique un antecedente"));

            }



        });



//habuilitar input de otra patologia al marcar el checkbox
        $('#otra-patologia').on('change', function (e) {

            if ($('#otro_antecedente').is(':disabled')) {
                $('#otro_antecedente').prop("disabled", false);
                $('#agregar-otra-patologia').prop("disabled", false);
                $('.select-box li.active').removeClass("active");

            } else {

                $('#otro_antecedente').prop("disabled", true);
                $('#agregar-otra-patologia').prop("disabled", true);
            }

        });
//grabar otra patologia y generar el tagsinput
        $('#agregar-otra-patologia').on('click', function (event) {
            event.preventDefault();

            var text = $('#otro_antecedente').val();
            if (text != "") {
                $("#control-visual-sntecedentes").parent().parent().spin("large");
                x_doAjaxCall(
                        "POST",
                        BASE_PATH + "add_control_visual_antecedentes_m.do",
                        "otro_antecedente=" + text + "&idperfilSaludControlVisual=" + $("#idperfilSaludControlVisual").val(),
                        function (data) {
                            $("#control-visual-sntecedentes").parent().parent().spin(false);
                            if (data.result) {
                                $('#otro_antecedente').val("");
                                $('#patologia-tag').tagsinput('add', {"id": data.id, "text": text});
                            } else {
                                x_alert(data.msg);
                            }

                        }
                );
            } else {
                x_alert(x_translate("Indique un antecedente"));
            }

        });
        $('#patologia-tag').on('beforeItemRemove', function (event) {
            // event.item: contains the item
            // event.cancel: set to true to prevent the item getting removed

            var id = event.item.id;

            x_doAjaxCall(
                    'POST',
                    BASE_PATH + 'delete_control_visual_antecedentes_m.do',
                    'id=' + id,
                    function (data) {

                        if (data.result) {
                            $('#patologia-tag').tagsinput('remove', {id: id});
                        } else {
                            x_alert(data.msg);

                            event.cancel = true;
                        }
                    }
            );
        });

        //patologias actuales
        $('#patologia-actual-add').on('click', function (event) {
            event.preventDefault();

            var text = $('#patologia-actual-name').val();

            if (text != "") {
                $("#control-visual-patologias-actuales").parent().parent().spin("large");
                x_doAjaxCall(
                        "POST",
                        BASE_PATH + "add_control_visual_patologia_actual_m.do",
                        "patologia_actual=" + text + "&idperfilSaludControlVisual=" + $("#idperfilSaludControlVisual").val(),
                        function (data) {
                            $("#control-visual-patologias-actuales").parent().parent().spin(false);
                            if (data.result) {
                                $('#patologia-actual-name').val("");
                                $('#patologia-actual-tag').tagsinput('add', {"id": data.id, "text": text});
                            } else {
                                x_alert(data.msg);
                            }

                        }
                );
            } else {
                x_alert(x_translate("Indique la patología actual"));
            }

        });

        $('#patologia-actual-tag').on('beforeItemRemove', function (event) {
            // event.item: contains the item
            // event.cancel: set to true to prevent the item getting removed
            var id = event.item.id;

            x_doAjaxCall(
                    'POST',
                    BASE_PATH + 'delete_control_visual_patologia_actual_m.do',
                    'id=' + id,
                    function (data) {

                        if (data.result) {
                            $('#patologia-actual-tag').tagsinput('remove', {id: id});
                        } else {
                            x_alert(data.msg);

                            event.cancel = true;
                        }
                    }
            );
        });

//metodo que elimina todas las patologias actuales cuando se selecciona el switch NO posee patologias actuales
        var delete_all_patologias_actuales = function () {
           if($('#patologia-actual-tag').tagsinput('items').length>0){
                     jConfirm({
                title: "",
                text: x_translate('Se eliminarán las patologías cargadas actualmente.'),
                confirm: function () {
                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + 'delete_control_visual_all_patologias_actuales_m.do',
                            "idperfilSaludControlVisual=" + $("#idperfilSaludControlVisual").val(),
                            function (data) {

                                if (data.result) {
                                    $('#patologia-actual-tag').tagsinput('removeAll');
                                } else {
                                    x_alert(data.msg);
                                        $('#btnPatologiasActuales').bootstrapSwitch('toggleState', true, true);
                                         var targetEl =   $('#btnPatologiasActuales').closest('.control-visual-card').find('.control-visual-toggle');
                                         targetEl.slideDown();
                                
                                }
                            }
                    );

                },
                cancel: function () {
                    $('#btnPatologiasActuales').bootstrapSwitch('toggleState', true, true);
                     var targetEl =   $('#btnPatologiasActuales').closest('.control-visual-card').find('.control-visual-toggle');
                                         targetEl.slideDown();
                },
                confirmButton: "Continuar",
                cancelButton: "Cancelar"
            });
           }
      

        }


        $('.switch').on('switchChange.bootstrapSwitch', function (event, state) {

            var targetEl = $(this).closest('.control-visual-card').find('.control-visual-toggle');


            if (state) {
                targetEl.slideDown();
            } else {
                targetEl.slideUp();
            }


        });

        //guardar control oftalmologico             
        $("#btnGuardarControlOftalmologico").click(function () {

            //verificamos que si se selecciono SI,haya al menos un check activo
            if ($("#btnControlOftalmologico").bootstrapSwitch('state') && $("#control-visual-oftalmologico input[type='checkbox']:checked").not(".switch").length == 0) {
                x_alert(x_translate("Seleccione al menos una opción"));
                return false;
            }
            x_sendForm($('#control-visual-oftalmologico'), true, function (data) {


                x_alert(data.msg);

            });
        });
        //switch control oftalmologico
        $('#btnControlOftalmologico').on('switchChange.bootstrapSwitch', function () {
            //si se selecciona no, limpimaos los inputs
            if (!$("#btnControlOftalmologico").bootstrapSwitch('state')) {
                $("#control-visual-oftalmologico input[type='checkbox']").prop("checked", false);
                $("#btnGuardarControlOftalmologico").click();
            }
        });



        //guardar control de anteojos            
        $("#btnGuardarControlAnteojos").click(function () {

            //verificamos que si se selecciono SI,haya al menos un check activo
            if ($("#btnControlAnteojos").bootstrapSwitch('state') && $("#control-visual-anteojos input[type='checkbox']:checked").not(".switch").length == 0) {
                x_alert(x_translate("Seleccione si sus anteojos son para visión de lejos o cerca"));
                return false;
            }

            if ($("#btnControlAnteojos").bootstrapSwitch('state') && $("#control-visual-anteojos input[type='radio']:checked").length == 0) {
                x_alert(x_translate("Seleccione si sus anteojos son de tipo bifocal o multifocal"));
                return false;
            }



            x_sendForm($('#control-visual-anteojos'), true, function (data) {


                x_alert(data.msg);

            });
        });

        //switch control de anteojos
        $('#btnControlAnteojos').on('switchChange.bootstrapSwitch', function () {
            //si se selecciona no, limpimaos los inputs
            if (!$("#btnControlAnteojos").bootstrapSwitch('state')) {
                $("#control-visual-anteojos input[type='checkbox']").prop("checked", false);
                $("#control-visual-anteojos input[type='radio']").prop("checked", false);
                $("#control-visual-anteojos .anteojos-input-row input[type='text']").val("");
                $("#btnGuardarControlAnteojos").click();
            }
        });
        
        //switch patologias actuales
         $('#btnPatologiasActuales').on('switchChange.bootstrapSwitch', function () {
            //si se selecciona no, limpimaos los inputs
            if (!$("#btnPatologiasActuales").bootstrapSwitch('state')) {
                 delete_all_patologias_actuales();
            }
        });
       

    });
</script>
{/literal}

{*inicializar tagsinput*}
<script>
    $(function (){ldelim}
    {foreach from = $list_patologias_actuales item = patologia_actual}
    $('#patologia-actual-tag').tagsinput('add', {ldelim}"id":{$patologia_actual.id}, "text":"{$patologia_actual.patologia_actual}"{rdelim});
    {/foreach}

    {foreach from = $list_antecedentes item = antecedente}
    $('#patologia-tag').tagsinput('add', {ldelim}"id":{$antecedente.id}, "text":"{if $antecedente.cirugia_ocular!=""}{$antecedente.cirugia_ocular}{else}{$antecedente.otro_antecedente}{/if}"{rdelim});
    {/foreach}
    {rdelim})
</script>
