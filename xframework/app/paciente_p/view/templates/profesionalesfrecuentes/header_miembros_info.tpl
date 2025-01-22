<nav class="section-header consulta-express-top profile">
    <div class="container">
        <div class="user-select pull-left user-select-sonsulta-express-rsp">
            <div class="active-user {if $header_info.all_members|@count == 1}active-user-no-arrow{/if}">
                <div class="user-img">
                    {if $paciente.image.perfil != ""}
                        <img class="img-responsive img-circle" src="{$paciente.image.perfil}?{$smarty.now}" alt="{$paciente.nombre} {$paciente.apellido}">
                    {else}
                        <img class="img-responsive img-circle" src="{$IMGS}extranet/noimage-paciente.jpg " alt="{$paciente.nombre} {$paciente.apellido}">
                    {/if}
                </div>

                {if $header_info.all_members|@count > 1}
                    <div class="perfil-dropdown">
                        <ul>
                            {foreach from=$header_info.all_members item=miembro} 
                                {if $paciente.idpaciente != $miembro.idpaciente}
                                    <li class="perfil-dropdown-click" data-id="{$miembro.idpaciente}">
                                        <a href="javascript:;">
                                            {if $miembro.image.perfil != ""}
                                                <img class="img-responsive img-circle" src="{$miembro.image.perfil}?{$smarty.now}" alt="{$miembro.nombre} {$miembro.apellido}">
                                            {else}
                                                <img class="img-responsive img-circle" src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$miembro.nombre} {$miembro.apellido}">
                                            {/if}
                                            {$miembro.nombre_corto}
                                        </a>
                                    </li>
                                {/if}
                            {/foreach}
                            <li class="">
                                <a href="javascript:;" onclick="window.location.href = '{$url}panel-paciente/miembros/'">

                                    <img class="img-responsive img-circle" src="{$IMGS}ico_all_members.png" alt="">

                                    {"Todos"|x_translate}
                                </a>
                            </li>
                        </ul>
                        {if $header_info.all_members|@count > 1}
                            <span><i class="dp-arrow-down"></i></span>
                            {/if}
                    </div>	
                {/if}			
            </div>
            <h1 class="section-name"><a class="consulta-express-tittle-lnk pcu-header-lnk" href="{$url}panel-paciente/profesionales-frecuentes/">{"Profesionales Frecuentes"|x_translate}</a></h1>
        </div>

        <div class="clearfix"></div>
    </div>
</nav>
{literal}
    <script>
        x_runJS();

        $(function () {



            $(".perfil-dropdown-click").click(function () {
                var id = $(this).data("id");

                if (parseInt(id) > 0) {
                    input_change = $("#label_" + id);
                    if (input_change.length == 0) {
                        input_change = $("#label_self");
                    }


                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + 'panel-paciente/change_member.do',
                            "requerimiento=" + input_change.data("requerimiento") + "&id=" + id,
                            function (data) {
                                if (data.result) {
                                    window.location.href = "";
                                } else {
                                    x_alert(data.msg);
                                }
                            }
                    );
                }
            });


            $('.active-user').on('click', function () {
                $(".perfil-dropdown").stop().slideDown();
                return false;
            });

            $('.dp-arrow-down').parent('span').on('click', function () {
                $(".perfil-dropdown").stop().slideUp();
                return false;
            });
        });
    </script>
{/literal}
