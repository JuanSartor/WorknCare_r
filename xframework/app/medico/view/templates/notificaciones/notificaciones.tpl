<style>
    .item-cat i.no-leido{
        position: absolute;
        z-index: 10;
        top: 4px;
        right: 6px;
        font-size: 22px;
        padding: 0px;
        line-height: 1;
        color: #cd3845;
    }
    .filters {
        overflow: hidden;
        padding: 0; 
    }
    .archivo-adjunto{
        position: relative;
    }
    .archivo-adjunto i {
        font-size: 16px!important;
        top: 0;
        margin: 0 10px;
    }
</style>
<section class="filter-table-header">
    <div class="container">
        <h1 class="section-header"><i class="fa fa-bell-o"></i> {"Notificaciones"|x_translate}</h1>
    </div>
</section>       


<div class="container" >

    <div id="filters" class="button-group filters">
        <ul>
            <li class="active"><a href="javascript:;" id="btnNoLeidas"  class="nt-all"  data-target="notificaciones_no_leidas" tabindex="-1">{"Todas"|x_translate}</a> </li>
                {*<li><a href="javascript:;" id="btnRenovarReceta" class="nt-renovacion-receta"  data-target="notificaciones_renovacion_receta" tabindex="-1"><span class="dpp-renovar-receta"></span></a></li>*}
            <li><a href="javascript:;" id="btnMensaje" class="nt-mensaje" data-target="notificaciones_mensaje" tabindex="-1"><span class="dp-email"></span></a></li>
            <li><a href="javascript:;" id="btnTurnos"  class="nt-turno" data-target="notificaciones_turnos" tabindex="-1"><span class="dpp-turnos"></span></a></li>
            <li><a href="javascript:;" id="btnInfo" class="nt-info" data-target="notificaciones_info_sistema" tabindex="-1"><span class="dpp-info"></span></a></li>		
        </ul>
    </div>	

    <div id="div_notificaciones_list">

    </div>

</div>

{x_load_js}

