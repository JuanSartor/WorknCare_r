<style>
    @media (max-width: 480px){
        label.checkbox{
            font-size: 12px;
            margin: 0px;
        }
        .notificaciones-opciones a {
            display: inline-block;
        }


    }
</style>
{if $listado_notificaciones.rows && $listado_notificaciones.rows|@count > 0}
    <div class="notificaciones-opciones ">
        <a href="javascript:;" class="btnSelectAll" >
            <label class="checkbox checkbox-inline ">
                <input type="checkbox" value="{$notificacion.idnotificacion}" id="chk-select-all" >
                {"Seleccionar todas"|x_translate}
            </label>
        </a>
        <div class="dropdown">
            <button class="btn btn-xs btn-white dropdown-toggle" type="button" id="dropdown-notificaciones" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
                {"Acciones"|x_translate}
                <span class="caret"></span>
            </button>
            <ul class="dropdown-menu dropdown-menu-right" aria-labelledby="dropdown-notificaciones">
                <li><a href="javascript:;" class="btnArchivar" >{"Archivar/Desarchivar"|x_translate}</a></li>
                <li><a href="javascript:;" class="btnMarcarLeida" data-leido="1">{"Marcar como leída"|x_translate}</a></li>
                <li><a href="javascript:;" class="btnMarcarNoLeida"  data-leido="0">{"Marcar como no leída"|x_translate}</a></li>
            </ul>
        </div>


    </div>    
{/if}
<script>
    $(function () {
        $('#div_notificaciones_list :checkbox').radiocheck();

        //select all checkbox
        $('#chk-select-all').on('change.radiocheck', function () {
            console.log("checked");
            if ($(this).is(':checked')) {
                $("#notificaciones-container .class_checkbox_seleccion").radiocheck('check');
            } else {
                $("#notificaciones-container .class_checkbox_seleccion").radiocheck('uncheck');
            }
        });


        //acciones marcar como leida / no leida
        $(".btnMarcarNoLeida,.btnMarcarLeida").click(function () {
            var ids = "";
            $.each($("#div_notificaciones_list").find(".class_checkbox_seleccion[type=checkbox]:checked"),
                    function (index, value) {
                        ids += "," + $(this).val();
                    });

            if (ids.length > 0) {
                ids = ids.substring(1);
            } else {
                x_alert(x_translate("No hay notificaciones seleccionadas"));
                return false;
            }
            var target_listado = $("#filters li.active a").data("target");

            if ($(this).data("leido") == 0) {
                var leido = 0;
            } else {
                var leido = 1;
            }


            $("body").spin("large");
            x_doAjaxCall(
                    'POST',
                    BASE_PATH + 'marcar_leido.do',
                    "ids=" + ids + "&leido=" + leido,
                    function (data) {
                        $("body").spin(false);

                        actualizar_notificaciones();
                        if (data.result) {
                            //$("#div_notificaciones_list").html("");
                            x_loadModule('notificaciones', target_listado, 'do_reset=1', 'div_notificaciones_list', BASE_PATH + "medico", "", actualizar_notificaciones);
                        } else {
                            x_alert(data.msg);
                        }
                    }
            );

        });

        //acciones archivar notificaciones
        $(".btnArchivar").click(function () {
            var ids = "";
            $.each($("#div_notificaciones_list").find(".class_checkbox_seleccion[type=checkbox]:checked"),
                    function (index, value) {
                        ids += "," + $(this).val();
                    });

            if (ids.length > 0) {
                ids = ids.substring(1);
            } else {
                x_alert(x_translate("No hay notificaciones seleccionadas"));
                return false;
            }
            var target_listado = $("#filters li.active a").data("target");


            $("body").spin("large");
            x_doAjaxCall(
                    'POST',
                    BASE_PATH + controller + '.php?action=1&modulo=notificaciones&submodulo=archivar_notificacion',
                    "ids=" + ids + "&archivar=1",
                    function (data) {
                        $("body").spin(false);

                        actualizar_notificaciones();
                        if (data.result) {
                            //$("#div_notificaciones_list").html("");
                            x_loadModule('notificaciones', target_listado, 'do_reset=1', 'div_notificaciones_list', BASE_PATH + controller, "", actualizar_notificaciones);
                        } else {
                            x_alert(data.msg);
                        }
                    }
            );

        });

    });
</script>
