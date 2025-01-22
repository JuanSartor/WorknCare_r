
<!-- end NAV -->
<nav class="paciente-nav">
    <div class="paciente-nav-container">
        <div class="paciente-nav-usr">
            <a href="{$url}entreprises/compte.html" class="paciente-nav-trigger">
                <label>{$account.user.nombre} {$account.user.apellido} {if $account.user.empresa!=""}- {$account.user.empresa}{/if}</label>
            </a>
        </div>

        <div class="paciente-nav-logo">
            <a href="{$url}entreprises/" title="WorknCare">
                <img src="{$IMGS}logo_workcnare_blanco.png" alt="WorknCare"/>
            </a>
        </div>
        <div class="paciente-nav-menu">
            <a class="paciente-nav-menu-burger" id="paciente-nav-menu-burger">
                {if $videoconsulta_notificaciones.notificacion_general>0 || $info_menu.cantidad_notificaciones > 0 || $cantidad_notificaciones.notificacion_general>0}
                    {assign "show_got_msg" true}
                {/if}
                <figure class="gotmsg bounce" id="menu-gotmsg" {if $show_got_msg}style="display:block"{else}style="display:none"{/if}>
                </figure>
                <i class="icon-doctorplus-burger"></i>
            </a>

            <ul class="paciente-nav-menu-rsp" id="burger-menu" display="block">
                <!-- upload icono empresaria -->
                <li>
                    {include file="home/icono_empresa.tpl"}
                </li>
                <!-- fin del upload -->
                <li>
                    <a href="{$url}entreprises/">
                        <i class="icon-doctorplus-home"></i>
                        <label>{"Home"|x_translate}</label>
                    </a>
                </li>
                <li>
                    <a href="{$url}entreprises/compte.html">
                        <i class="icon-doctorplus-ficha-tecnica"></i>
                        <label>{"Datos de cuenta"|x_translate}</label>
                    </a>
                </li>
                {if $account.user.tipo_usuario|in_array:['1'] } 
                    <li>
                        <a href="{$url}entreprises/utilisateurs.html">
                            <i class="fa fa-user-plus"></i>
                            <label>{"Usuarios autorizados"|x_translate}</label>
                        </a>
                    </li>
                {/if}
                {if $account.user.tipo_usuario|in_array:['1'] } 
                    <li>
                        <a href="{$url}entreprises/programmes.html">
                            <i class="fa fa-list-ul"></i>
                            <label>{"Programas incluidos"|x_translate}</label>
                        </a>
                    </li>
                {/if}
                {if $account.user.tipo_usuario|in_array:['1','3','4'] } 
                    <li>
                        <a href="{$url}entreprises/beneficiaires.html">
                            <i class="icon-doctorplus-pacientes"></i>
                            <label>{"Gestión de beneficiarios"|x_translate}</label>
                        </a>
                    </li>
                {/if} 
                {if $account.user.tipo_usuario|in_array:['1','2','4'] } 
                    <li>
                        <a href="{$url}entreprises/factures.html">
                            <i class="icon-doctorplus-dollar-sheet"></i>
                            <label>{"Facturas"|x_translate}</label>
                        </a>
                    </li>
                {/if}


                {if $account.user.tipo_usuario|in_array:['1'] } 
                    <li>
                        <a href="{$url}entreprises/rapports.html" target="_blank">
                            <i class="fa fa-line-chart"></i>
                            <label>{"Reporte"|x_translate}</label>
                        </a>
                    </li>
                {/if}

                <li>
                    <a href="javascript:;" data-idioma="{$TRADUCCION_DEFAULT}"  title='{"Cerrar sesión"|x_translate}' class="btnSalir">
                        <i class="icon-doctorplus-onoff"></i>
                        <label>{"Cerrar sesión"|x_translate}</label>
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>	
<!-- end NAV -->     
{literal}   
    <script language="javascript" type="text/javascript">
        $(function () {



            /* $('.paciente-nav-trigger').on('click', function (e) {
             e.preventDefault();
             $pacienteMenu = $('#paciente-menu');
             $pacienteMenu.toggleClass('menu-show');
             
             });*/

            //abrir menu desplegable
            $('.paciente-nav-menu-burger').on('click', function (e) {
                e.preventDefault();
                var vpw = $(window).width() + getScrollBarWidth();
                $burgerMenu = $('#burger-menu');
                $burgerMenu.toggleClass('menu-show');
            });

            //litener cerrar menu - click fuera
            $(document).on('click', function (event) {
                if ((!$(event.target).closest('.paciente-nav-menu-burger').length) && $('.paciente-nav-menu-burger').is(':visible') && !$(event.target).hasClass("open-submenu")) {
                    $('#burger-menu').removeClass('menu-show');
                    $("#burger-menu li a.submenu").removeClass('open');
                }
            });
            //abrir submenu
            $("#burger-menu li .submenu").click(function (e) {
                e.preventDefault();
                $("#burger-menu li a.submenu").toggleClass("open");
            });



            $('.btnSalir').on("click", function () {
                if ($(this).data("idioma") == 'fr') {
                    x_LogOut();
                } else {
                    x_LogOutEN();
                }
            });


        });
    </script>        
{/literal}