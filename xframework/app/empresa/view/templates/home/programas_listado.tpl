<section class="okm-container">
    <div class="col-xs-12 programas-incluidos panel-group" id="accordion">
        <h2 class="title">
            <button class="btn btn-transparen go-back-button btn-volver"><i class="fa fa-chevron-left"></i></button>
                {"Programas incluidos para sus beneficiarios"|x_translate}
        </h2>
        <p>{"Seleccione los programas que desea bonificar el acceso sin cargo a sus beneficiarios:"|x_translate}</p>
        {foreach from=$listado_programas item=programa}
            <div class="programa-item">    
                {if $idplanempresa != '18' && $idplanempresa!= '19' }
                    <div class="divch">
                        <label class="checkbox check-grupo">
                            <input type="checkbox" checked name="programa" data-id="{$programa.idprograma_salud_grupo_empresa}" id="chkg{$programa.idprograma_salud_grupo_empresa}"  data-toggle="checkbox" class="custom-checkbox chkgrupo">
                        </label>
                    </div>
                {/if}
                <a style="height: 140px; display: flex;" class="btn btn-white programa-header btnc"  data-toggle="collapse" data-parent="#accordion" href="#programa-{$programa.idprograma_salud_grupo_empresa}"  data-id="{$programa.idprograma_salud_grupo_empresa}" id="{$programa.idprograma_salud_grupo_empresa}" >         
                    <div  class="img-grupo" style="background:url('{$programa.imagenesgrupoempresa.imagen.original}')">
                    </div>
                    <div>
                        <div class="texto-grupo">
                            {$programa.nombre}
                            <br>
                            <div style="font-weight: 500;"> {$programa.cantprogramas}    {"Programas"|x_translate} </div>
                        </div>
                        <i class="fa fa-chevron-down pull-right icono-grupo-desplegable"></i>
                    </div>
                </a>
            </div>
            <div class="collapse panel-collapse"  id="programa-{$programa.idprograma_salud_grupo_empresa}">
                {foreach from=$programa.listado_programas item=categoria}

                    <div class="programa-item"  {if ($idplanempresa== '18' || $idplanempresa== '19') 
                  &&  $categoria.idprograma_salud !='49' && $categoria.propio =='0'} style="pointer-events: none;opacity: 0.4;"{/if}>

                        <label class="checkbox">
                            <input type="checkbox" checked name="programa" value="{$categoria.idprograma_salud}"   data-toggle="checkbox" class="custom-checkbox {$programa.idprograma_salud_grupo_empresa}">
                        </label>
                        <a  class="btn btn-white programa-header"  data-toggle="collapse"  href="#cat-{$categoria.idprograma_salud}"  >

                            {$categoria.programa_salud}

                            <i class="fa fa-chevron-down pull-right"></i>
                        </a>
                    </div> 
                    <div class="collapse" id="cat-{$categoria.idprograma_salud}">
                        <ul class="programas-categorias">
                            {foreach from=$categoria.listado_categorias item=categoriaR}
                                <li>
                                    {$categoriaR.programa_categoria}
                                </li>
                            {/foreach}
                        </ul> 
                    </div>

                {/foreach}

            </div>


        {/foreach}
    </div>
    <div class="okm-row text-center">
        <div class="col-xs-12">
            <a href="javascript:;" class="btn btn-xs btn-secondary btn-volver" style="background:#455a64">{"volver"|x_translate}</a>
            <a href="javascript:;" class="btn btn-xs btn-default  btn-guardar" >{"guardar"|x_translate}</a>
        </div>
    </div>

    <div class="clearfix">&nbsp;</div>
</section>
<script>
    var ids_excepciones_programa = "{$excepciones_programa.programa_salud_excepcion}";
</script>
{literal}
    <script>
        $(function () {
            //volver a la home

            $(".btn-volver").click(function () {
                $("#Main").spin("large");
                x_loadModule('home', 'home', '', 'Main');
            });
            //desmarcamos los programas que no son ofrecidos por la empresa
            if (ids_excepciones_programa !== "") {
                ids_excepciones_programa.split(',').forEach(function (id) {
                    $(".programas-incluidos input:checkbox[value=" + id + "]").radiocheck('uncheck');
                });
            }

            //guardar excepciones
            $(".btn-guardar").click(function () {
                console.log("ids" + ids);
                var ids = "";
                $(".programas-incluidos input:checkbox:not(:checked)").each(function () {
                    ids += ',' + $(this).val();
                });
                if (ids.length > 0) {
                    ids = ids.substring(1);
                }

                $("body").spin("large");
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'empresa.php?action=1&modulo=home&submodulo=programa_salud_excepcion',
                        'ids=' + ids,
                        function (data) {
                            $("body").spin(false);
                            x_alert(data.msg);
                            if (data.result) {

                            } else {

                            }
                        }
                );
            });
            $(".btnc").click(function () {

                id = $(this).data("id");
                resultado = $("#" + id).hasClass("color-deplegado");
                if (!resultado) {
                    $("#" + id).addClass("color-deplegado");
                } else {
                    $("#" + id).removeClass("color-deplegado");
                }
                //color - deplegado


            });

            $('.chkgrupo').on('click', function () {
                idg = $(this).data("id");

                if ($('#chkg' + idg).prop('checked')) {
                    $('.' + idg).prop('checked', true);
                } else {
                    $('.' + idg).prop('checked', false);
                }

            });

        });
    </script>
{/literal}