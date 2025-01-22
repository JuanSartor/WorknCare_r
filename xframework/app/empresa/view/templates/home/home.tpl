<link rel="stylesheet" type="text/css" href="{$url}xframework/app/paciente_p/view/css/fix-home.css?v={$smarty.now|date_format:"%j"}" />
<link href="{$url}xframework/app/themes/dp02/css/pass_esante_registro.css?v={$smarty.now|date_format:"%j"}" rel="stylesheet">

{include file="home/modal_informacion_beneficiario.tpl"}     
<div id="div_home_cards_container">
    {include file="home/home_cards.tpl"}     
</div>

{include file="home/plan_contratado_card.tpl"}