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

<section class="section-header section-header profile filter-table-header filter-table-header-paciente">
    <div class="container">
        <input type="hidden" id="paciente_seleccionado" value="{$paciente.idpaciente}" >
        <div class="user-select pull-left">
            <h1 class="section-name"><i class="fa fa-bell-o"></i> {"Notificaciones"|x_translate}</h1>
        </div>
    </div>
</section>   

<div class="container" >

    <div id="filters" class="button-group filters">
        <ul>
            <li class="active"><a href="javascript:;" id="btnNoLeidas" data-target="notificaciones_no_leidas" class="nt-all" tabindex="-1">{"Todas"|x_translate}</a> </li>
            {*<li><a href="javascript:;" id="btnRenovarReceta" class="nt-renovacion-receta" data-target="notificaciones_renovacion_receta" tabindex="-1"><span class="dpp-renovar-receta"></span></a></li>*}
            <li><a href="javascript:;" id="btnTurnos" class="nt-turno"  data-target="notificaciones_turnos" tabindex="-1"><span class="dpp-turnos"></span></a></li>
            <li><a href="javascript:;" id="btnChequeos" class="nt-chequeos"  data-target="notificaciones_chequeo" tabindex="-1"><span class="dpp-chequeos"></span></a></li>
            <li><a href="javascript:;" id="btnInfo" data-target="notificaciones_info_sistema" tabindex="-1"><span class="dp-email"></span></a></li>		
        </ul>
    </div>

    <div id="div_notificaciones_list">

    </div>

</div>


{x_load_js}