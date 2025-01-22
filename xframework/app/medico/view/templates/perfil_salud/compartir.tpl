<div id="estudios_yes">
    <div class="tab-content view-doctor">
        <div role="tabpanel" class="w tab-pane active fade in" id="compartir-buscar">
            <div class="modal-header">
                <div class="modal-title"><h5>{"Compartir con"|x_translate}</h5></div>
                <span class="close-btn" data-dismiss="modal" aria-label="Close"><i class="fui-cross"></i></span>
            </div>
            <form action="{$url}busqueda_compartir.do" method="post" id="busqueda_compartir_form">
                <div class="form-content">
                    <p class="buscar-field">
                        <input type="text" name="nombre_medico"> <a href="#compartir-resultados" role="tab" id="busqueda_compartir_input" data-toggle="tab"><span class="fui-search"></span></a>
                        <!-- <a href="#compartir-resultados" role="tab" data-toggle="tab" class="dp-search"></a> -->
                    </p>
                    <p>
                        <select name="especialidad_idespecialidad" id="especialidad_idespecialidad" class="form-control select select-inverse select-block">
                            <option value="">{"Seleccione una Especialidad"|x_translate}</option>
                            {html_options options=$combo_especialidades}
                        </select>
                    </p>	
                  

                </div>
                <div class="modal-btns">
                    <a href="#compartir-resultados" role="tab" id="busqueda_compartir" data-toggle="tab" class="dp-search"></a>
                </div>
            </form>
        </div>
        <div role="tabpanel" class="w tab-pane fade" id="compartir-resultados">
            <div class="modal-header">
                <div class="modal-title"><h5>{"Resultados de búsqueda"|x_translate}</h5></div>
                <span class="close-btn" data-dismiss="modal" aria-label="Close"><i class="fui-cross"></i></span>
            </div>
            <div class="modal-body">
                <div id="div_modal">


                </div>
            </div>
            <div class="modal-btns">
                <a href="#compartir-buscar" role="tab" data-toggle="tab" class="fui-arrow-left"></a>
            </div>						
        </div>
        <div role="tabpanel" class="w tab-pane fade relative" id="compartir-enviar">
            <div class="modal-header">
                <div class="modal-title"><h5>{"Compartir con"|x_translate}</h5></div>
                <span class="close-btn" data-dismiss="modal" aria-label="Close"><i class="fui-cross"></i></span>
            </div>						
            <form action="{$url}send_consulta.do" method="post" id="send_consulta" onsubmit="return false;">
                <input type="hidden" name="medico_idmedico_recibe" id="medico_idmedico_recibe" />
                <input type="hidden" name="ids" id="ids_win" />

                <div class="form-content">
                    <p>
                        <span class="fui-link"></span>
                    <div id="div_nombre" class="pull-left"></div>
                     <div id="div_nombre_paciente" class="pull-right"></div>
                </p>
                    <p><textarea name="consulta" id="consulta_win"  placeholder='{"Escriba aqui su consulta"|x_translate}'></textarea></p>

                </div>
                <div class="compartir-adjuntar">
                    <div id="div_imagenes_adjuntar"></div>

                    <label for="compartir-adjunto" class="fui-clip"></label>
                    <input type="file" id="compartir-adjunto">
                </div>
                <div class="modal-btns">
                    <button id="btnFinalizarCompartir"></button>
                </div>
            </form>
        </div>
    </div>
</div>
<div id="estudios_no" style="display: none">
    <div class="tab-content view-doctor">
        <div class="modal-header">
            <div class="modal-title"><h5>{"Compartir consulta"|x_translate}</h5></div>
            <span class="close-btn" data-dismiss="modal" aria-label="Close"><i class="fui-cross"></i></span>
        </div>
        <div>
            <p class="sin-registros-cs">{"No ha seleccionado ningún estudio para compartir"|x_translate}</p>
        </div>
    </div>
</div>
{literal}
<script>
    $(document).ready(function() {
        renderUI2("compartir");
        x_runJS();


        var classe = "input_check_list";
        if ($("#view_thumbs").hasClass("active")) {
            //Si está en la vista thumb
            classe = "input_check_thumb";
        }


        var ids = "";
        $.each($("." + classe + ":checked"),
                function(index, value) {
                    ids += "," + $(this).val();
                    $("#ids_win").val(ids);
                });

        if ($("#ids_win").val() != "") {
            x_loadModule('perfil_salud', 'compartir_imagenes', 'ids=' + $("#ids_win").val(), 'div_imagenes_adjuntar', BASE_PATH + "medico");
        } else {
            $("#estudios_yes").hide();
            $("#estudios_no").show();
            //$("#modal_compartir_estudio").modal("toggle");
        }


        $("#btnFinalizarCompartir").click(function() {

            $("#compartir-enviar").spin("large");

            x_sendForm($('#send_consulta'), true,
                    function(data) {
                        $("#compartir-enviar").spin(false);
                        x_alert(data.msg);
                        $("#modal_compartir_estudio").modal("toggle");
                        if (data.result) {
                            
//                            $("#compartir").modal("toggle");
                        }
                    });
        });
    });





    //Update combobox de la especialidad
    $("#especialidad_idespecialidad").change(function() {
     
    });

    $("#busqueda_compartir, #busqueda_compartir_input").click(function() {
        $("#div_modal").spin("large");
        x_sendForm($('#busqueda_compartir_form'), true, function(data) {

            $("#div_modal").html("");

            if (data.result) {
                $("<ul>").appendTo($("#div_modal"));

                $.each(data.data,
                        function(index, value) {

                            var str = "<li><a href=\"#compartir-enviar\" class=\"class_compartir_enviar\" data-id=\"" + value.idmedico + "\" data-nombre=\"" + value.nombre + "\" data-titulo=\"" + value.titulo_profesional + "\" data-apellido=\"" + value.apellido + "\" role=\"tab\" data-toggle=\"tab\">";
                            if (value.images != false) {
                                str += "<img src=\"" + value.images.list + "\" alt=\"\">";
                            } else {
                                str += "<img src=\"" + BASE_PATH + "xframework/app/themes/dp02/imgs/extranet/noimage_nuevomiembro.jpg\" alt=\"\">";
                            }
                            str += value.nombre + " " + value.apellido +
                                    "<span class=\"resultado-ocupacion\">" + value.especialidad + "</span>" +
                                    "<span class=\"icon-compartir\"></span>" +
                                    "</a></li>";

                            $(str)
                                    .appendTo($("#div_modal"))
                                    .delegate($(".class_compartir_enviar"), "click", function() {
                                        $a = $(this).find("a");
                                        var nombre_medico = "";

                                        if ($a.data("titulo") != null) {
                                            nombre_medico += $a.data("titulo") + " ";
                                        }
                                        nombre_medico += $a.data("nombre") + " " + $a.data("apellido");

                                        $("#medico_idmedico_recibe").val($a.data("id"));
                                        $("#div_nombre").html(nombre_medico);
                                         $("#div_nombre_paciente").html($(".nombre_paciente").text());
                                        
                                    });
                        });
                $("</ul>").appendTo($("#div_modal"));
                 $("#div_modal").spin(false);
            } else {
                $("#div_modal").spin(false);
                $("<p>&nbsp;</p><p>&nbsp;</p><p class=\"text-center\" ><strong> Excusez moi! <br> Aucun résultat trouvé pour la recherche</strong></p>").appendTo($("#div_modal"));
            }
        });
    });

</script>
{/literal}