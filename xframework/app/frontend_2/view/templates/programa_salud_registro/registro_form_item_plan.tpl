<div class="item-plan"  data-id="{$plan.idprograma_salud_plan}">
    {if $pack==1}
        {*pack recomendado 6*}
        {if $plan.idprograma_salud_plan==5}
            <div class="plan-recomendado">
                <span>{"Pack Recomendado"|x_translate}</span>  
            </div>
        {/if}          
    {else}
        {*plan recomendado 2*}
        {if $plan.idprograma_salud_plan==1}
            <div class="plan-recomendado">
                <span>{"Programa Recomendado"|x_translate}</span>  
            </div>
        {/if} 
    {/if}
    {* Planes access gratis *}
    {if $plan.idprograma_salud_plan ==21 || $plan.idprograma_salud_plan ==22 || $plan.idprograma_salud_plan ==23}
        <div class="plan-recomendado" style="background: #ED799E;">
            <span>{"Programa gratuito"|x_translate}</span>  
        </div>
    {/if}  

    <div class="{if $plan.particular == 0}plan-title{else}plan-title plan-title-particular{/if}" {if $plan.idprograma_salud_plan==20} style="color:#3EBAC7;"{/if}>
        {$plan.nombre}
    </div>
    <div class="{if $plan.particular == 0}plan-precio{else}plan-precio plan-precio-particular{/if}" {if $plan.idprograma_salud_plan==20} style="color:#3EBAC7;"{/if}>
        &euro; {$plan.precio}
        <div class="label">
            {if $plan.idprograma_salud_plan !=21 && $plan.idprograma_salud_plan !=22 && $plan.idprograma_salud_plan !=23}
                {if $particular!="1"}
                    {if $pack==1 || $pack==500}
                        {"paquete válido por 1 año"|x_translate}
                    {else}
                        {"precio por beneficiario / por mes"|x_translate}
                    {/if}
                {else}
                    {if $pack==1}
                        {"paquete particular por 1 año"|x_translate}
                    {else}
                        {"precio particular / por mes"|x_translate}
                    {/if}
                {/if}
            {else}
                <div class="access" style="margin-bottom: 31px;"></div>
            {/if}

        </div>

    </div>
    <button class="{if $plan.particular == 0}btn-suscribir{else}btn-suscribir btn-suscribir-particular{/if}" data-costo_plan="{$plan.precio}" {if $pack==1 || $pack==500}title='{"Comprar pack"|x_translate}'  data-tipo='pack' {else} title='{"Suscribirme"|x_translate}' data-tipo='plan'{/if}  data-id="{$plan.idprograma_salud_plan}" id='btn-{$plan.idprograma_salud_plan}'
            {if $plan.idprograma_salud_plan==20} style="background-color:#3EBAC7;"{/if}>
        {if $pack==1 || $pack==500}
            {if $plan.idprograma_salud_plan !=21 && $plan.idprograma_salud_plan !=22 && $plan.idprograma_salud_plan !=23}
                {"Comprar pack"|x_translate} 
            {else}
                {"Free Pack"|x_translate} 
            {/if}
        {else}
            {if $plan.idprograma_salud_plan !=21 && $plan.idprograma_salud_plan !=22 && $plan.idprograma_salud_plan !=23}
                {"Suscribirme"|x_translate}
            {else}
                {"Free"|x_translate} 
            {/if}
        {/if}
    </button>
    {if $plan.idprograma_salud_plan!=4}
        <div class="consultas-incluidas">
            {if $plan.idprograma_salud_plan ==21 || $plan.idprograma_salud_plan ==22 || $plan.idprograma_salud_plan ==23}
                <h3>{"impulsar la participación"|x_translate}</h3>
            {else}
                <h3> {math equation="x+y" x=$plan.cant_videoconsulta y=$plan.cant_consultaexpress}  {"consultas incluidas"|x_translate}</h3>
            {/if}
            {if $plan.idprograma_salud_plan ==21 || $plan.idprograma_salud_plan ==22 || $plan.idprograma_salud_plan ==23}
                <p>
                    <i class="fa fa-check"></i>{"Cuestionarios ilimitados"|x_translate}
                </p>
                <p>
                    <i class="fa fa-check"></i>{"Gestion de recompensas"|x_translate}
                </p>      
                <p>
                    <i class="fa fa-plus"></i> {"Fonctionnalités illiimitées"|x_translate}
                </p>
            {else}
                <p>
                    <i class="fa fa-check"></i> {$plan.cant_consultaexpress} {"consultas por chat"|x_translate}
                </p>
                <p>
                    <i class="fa fa-check"></i> {$plan.cant_videoconsulta} {"consultas por video"|x_translate}
                </p>      
                <p>
                    <i class="fa fa-plus"></i> {"Fonctionnalités illiimitées"|x_translate}
                </p>
            {/if}
            </ul>
        </div>
    {else}
        <div class="consultas-incluidas">
            <h3>   {"Consultas Ilimitadas"|x_translate}</h3>
            <p>
                <i class="fa fa-check"></i>  {"Ilimitadas por chat"|x_translate}
            </p>
            <p>
                <i class="fa fa-check"></i>  {"Ilimitadas por video"|x_translate}
            </p>
            <p>
                <i class="fa fa-plus"></i> {"Encuestas RPS QVT"|x_translate}
            </p>
            </ul>
        </div>
    {/if}
    <hr>
    <div  class="descripcion-content">
        {if $plan.idprograma_salud_plan==1}
            {if $plan.primer_texto_card!=''}
                <p>{if $TRADUCCION_IDIOMA=="fr"}  {$plan.primer_texto_card} {else}  {$plan.primer_texto_card_en} {/if}</p>
            {else}
                <p>{"1. Para comenzar"|x_translate}</p>
            {/if}
            {if $plan.segundo_texto_card!=''}
                <p>{if $TRADUCCION_IDIOMA=="fr"}  {$plan.segundo_texto_card} {else} {$plan.segundo_texto_card_en} {/if}</p>
            {else}
                <p>{"1. Libre de impuestos para el empleado"|x_translate}</p>
            {/if}
            {if $plan.tercer_texto_card!=''}
                <p>{if $TRADUCCION_IDIOMA=="fr"}  {$plan.tercer_texto_card} {else} {$plan.tercer_texto_card_en} {/if}</p>
            {else}
                <p>{"1. Deducible para la empresa"|x_translate}</p>
            {/if}
        {else if $plan.idprograma_salud_plan==2}
            {if $plan.primer_texto_card!=''}
                <p>{if $TRADUCCION_IDIOMA=="fr"}  {$plan.primer_texto_card} {else}  {$plan.primer_texto_card_en} {/if}</p>
            {else}
                <p>{"2. Con seguimiento"|x_translate}</p>
            {/if}
            {if $plan.segundo_texto_card!=''}
                <p>{if $TRADUCCION_IDIOMA=="fr"}  {$plan.segundo_texto_card} {else} {$plan.segundo_texto_card_en} {/if}</p>
            {else}
                <p>{"2. Libre de impuestos para el empleado"|x_translate}</p>
            {/if}
            {if $plan.tercer_texto_card!=''}
                <p>{if $TRADUCCION_IDIOMA=="fr"}  {$plan.tercer_texto_card} {else} {$plan.tercer_texto_card_en} {/if}</p>
            {else}
                <p>{"2. Deducible para la empresa"|x_translate}</p>
            {/if}
        {else if $plan.idprograma_salud_plan==3}
            {if $plan.primer_texto_card!=''}
                <p>{if $TRADUCCION_IDIOMA=="fr"}  {$plan.primer_texto_card} {else}  {$plan.primer_texto_card_en} {/if}</p>
            {else}
                <p>{"3. Mini programa!"|x_translate}</p>
            {/if}
            {if $plan.segundo_texto_card!=''}
                <p>{if $TRADUCCION_IDIOMA=="fr"}  {$plan.segundo_texto_card} {else} {$plan.segundo_texto_card_en} {/if}</p>
            {else}
                <p>{"3. Sin exención de impuestos (i)"|x_translate}</p>
            {/if}
            {if $plan.tercer_texto_card!=''}
                <p>{if $TRADUCCION_IDIOMA=="fr"}  {$plan.tercer_texto_card} {else} {$plan.tercer_texto_card_en} {/if}</p>
            {else}
                <p>{"3. Deducible para la empresa"|x_translate}</p>
            {/if}
        {else if $plan.idprograma_salud_plan==4}
            {if $plan.primer_texto_card!=''}
                <p>{if $TRADUCCION_IDIOMA=="fr"}  {$plan.primer_texto_card} {else}  {$plan.primer_texto_card_en} {/if}</p>
            {else}
                <p>{"4. Programa ilimitado!"|x_translate}</p>
            {/if}
            {if $plan.segundo_texto_card!=''}
                <p>{if $TRADUCCION_IDIOMA=="fr"}  {$plan.segundo_texto_card} {else} {$plan.segundo_texto_card_en} {/if}</p>
            {else}
                <p>{"4. Sin exención de impuestos (i)"|x_translate}</p>
            {/if}
            {if $plan.tercer_texto_card!=''}
                <p>{if $TRADUCCION_IDIOMA=="fr"}  {$plan.tercer_texto_card} {else} {$plan.tercer_texto_card_en} {/if}</p>
            {else}
                <p>{"4. Deducible para la empresa"|x_translate}</p>
            {/if}
        {else if $plan.idprograma_salud_plan==5}
            {if $plan.primer_texto_card!=''}
                <p>{if $TRADUCCION_IDIOMA=="fr"}  {$plan.primer_texto_card} {else}  {$plan.primer_texto_card_en} {/if}</p>
            {else}
                <p>{"5. Descubrimiento"|x_translate}</p>
            {/if}
            {if $plan.segundo_texto_card!=''}
                <p>{if $TRADUCCION_IDIOMA=="fr"}  {$plan.segundo_texto_card} {else} {$plan.segundo_texto_card_en} {/if}</p>
            {else}
                <p>{"5. Libre de impuestos para el empleado"|x_translate}</p>
            {/if}
            {if $plan.tercer_texto_card!=''}
                <p>{if $TRADUCCION_IDIOMA=="fr"}  {$plan.tercer_texto_card} {else} {$plan.tercer_texto_card_en} {/if}</p>
            {else}
                <p>{"5. Personalizable por el CSE"|x_translate}</p>
            {/if}
        {else if $plan.idprograma_salud_plan==6}
            {if $plan.primer_texto_card!=''}
                <p>{if $TRADUCCION_IDIOMA=="fr"}  {$plan.primer_texto_card} {else}  {$plan.primer_texto_card_en} {/if}</p>
            {else}
                <p>{"6. Con seguimiento"|x_translate}</p>
            {/if}
            {if $plan.segundo_texto_card!=''}
                <p>{if $TRADUCCION_IDIOMA=="fr"}  {$plan.segundo_texto_card} {else} {$plan.segundo_texto_card_en} {/if}</p>
            {else}
                <p>{"6. Libre de impuestos para el empleado"|x_translate}</p>
            {/if}
            {if $plan.tercer_texto_card!=''}
                <p>{if $TRADUCCION_IDIOMA=="fr"}  {$plan.tercer_texto_card} {else} {$plan.tercer_texto_card_en} {/if}</p>
            {else}
                <p>{"6. Personalizable por el CSE"|x_translate}</p>
            {/if}
        {else if $plan.idprograma_salud_plan==7}
            {if $plan.primer_texto_card!=''}
                <p>{if $TRADUCCION_IDIOMA=="fr"}  {$plan.primer_texto_card} {else}  {$plan.primer_texto_card_en} {/if}</p>
            {else}
                <p>{"7. Mini programa"|x_translate}</p>
            {/if}
            {if $plan.segundo_texto_card!=''}
                <p>{if $TRADUCCION_IDIOMA=="fr"}  {$plan.segundo_texto_card} {else} {$plan.segundo_texto_card_en} {/if}</p>
            {else}
                <p>{"7. Libre de impuestos para el empleado"|x_translate}</p>
            {/if}
            {if $plan.tercer_texto_card!=''}
                <p>{if $TRADUCCION_IDIOMA=="fr"}  {$plan.tercer_texto_card} {else} {$plan.tercer_texto_card_en} {/if}</p>
            {else}
                <p>{"7. Personalizable por el CSE"|x_translate}</p>
            {/if}
        {else}
            {if $plan.primer_texto_card!=''}
                <p>{if $TRADUCCION_IDIOMA=="fr"}  {$plan.primer_texto_card} {else}  {$plan.primer_texto_card_en} {/if}</p>
            {else}
                <p>{"1. Para comenzar"|x_translate}</p> 
            {/if}
            {if $plan.segundo_texto_card!=''}
                <p>{if $TRADUCCION_IDIOMA=="fr"}  {$plan.segundo_texto_card} {else} {$plan.segundo_texto_card_en} {/if}</p>
            {else}
                <p>{"1. Libre de impuestos para el empleado"|x_translate}</p>
            {/if}
            {if $plan.tercer_texto_card!=''}
                <p>{if $TRADUCCION_IDIOMA=="fr"}  {$plan.tercer_texto_card} {else} {$plan.tercer_texto_card_en} {/if}</p>
            {else}
                <p>{"1. Deducible para la empresa"|x_translate}</p>
            {/if}

        {/if}
    </div>
    {if  $plan.idprograma_salud_plan !=21 && $plan.idprograma_salud_plan !=22 && $plan.idprograma_salud_plan !=23}
        <div class="{if $plan.particular == 0}destacado-planes{else}destacado-planes destacado-planes-particular{/if}"  {if $plan.idprograma_salud_plan==20}style="border-top: 10px solid #3EBAC7;border-bottom: 10px solid #3EBAC7;"{/if}>
            {if $plan.idprograma_salud_plan!=18 && $plan.idprograma_salud_plan!=19 && $plan.idprograma_salud_plan!=20}
                <span class="span-dest-planes">{"Hasta 65 euros de reembolso"|x_translate}</span>
            {else if $plan.idprograma_salud_plan ==18 || $plan.idprograma_salud_plan ==19 || $plan.idprograma_salud_plan ==20}
                <span class="span-dest-planes">{"Hasta 30 euros de reembolso"|x_translate}</span>
            {/if}
        </div>
    {/if}
    {if $plan.idprograma_salud_plan==20}
        <br>
        <span class="span-dest-planes">{"Note : le budget engagé englobe l’ensemble des salariés et ne fait pas l’objet de remboursement."|x_translate}</span>   
    {/if}
</div>