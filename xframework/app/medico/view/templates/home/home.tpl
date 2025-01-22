{if $consultorios_completo==1}
    {include file="home/home_iconos.tpl"}
{else}
    <section class="user-welcome text-center">
        <h1>{if $medico.sexo=="0"}{"Bienvenida"|x_translate}{else}{"Bienvenido"|x_translate}{/if} {$medico.tituloprofesional} {$medico.nombre} {$medico.apellido}</h1>
        <h2>{"DoctorPlus, la red de e-Salud más importante del país!"|x_translate}</h2>
        <h3>{"Informatice su consultorio en pocos minutos"|x_translate}</h3>
    </section>
    <div id="div_menu_usuario"></div>
    <script>
        x_loadModule('usuario', 'menu_usuario', 'sm={$submodulo}', 'div_menu_usuario');
    </script>
{/if}

{include file="home/banner_home_medico.tpl"}

{include file="home/info_cuenta.tpl"}

{include file="home/banner_funcionalidades.tpl"}
