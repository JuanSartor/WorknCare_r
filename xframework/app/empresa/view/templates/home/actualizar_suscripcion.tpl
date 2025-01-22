<style>
    .opp{
        opacity:0.1;
    }
</style>
<section id="sectPrin" class="pass-sante-registro-planes">
    <div class="okm-container creacion-cuenta">
        <div class="header-container text-center">
            <h1 class="text-center">{"Cambiar suscripción"|x_translate}</h1>
            <h2 class="text-center">{"Actualice su suscripcion a un plan superior"|x_translate}</h2>
        </div>
        <div class="planes-wrapper">            
            <div class="listado-planes">
                {foreach from=$planes item=plan} 
                    {if $plan_contratado.idprograma_salud_plan  !='23'}
                        {if $plan_contratado.precio|floatval <= $plan.precio|floatval && $plan_contratado.pack==$plan.pack && $plan.idprograma_salud_plan!='20' && $plan.idprograma_salud_plan!='23'}
                            <div class="item-plan {if $plan_contratado.idprograma_salud_plan == $plan.idprograma_salud_plan}plan-contratado{/if} {if $plan_contratado.idprograma_salud_plan > $plan.idprograma_salud_plan}plan-no-disponible{/if}"  data-id="{$plan.idprograma_salud_plan}">
                                <div class="plan-title" data-id="{$plan.idprograma_salud_plan}" >
                                    {$plan.nombre}
                                </div>
                                {if $plan.idprograma_salud_plan !=21 && $plan.idprograma_salud_plan !=22 && $plan.idprograma_salud_plan !=23}
                                    <div class="plan-precio">
                                        &euro; {$plan.precio}
                                        <div class="label">
                                            {"precio por beneficiario / por mes"|x_translate}
                                        </div>
                                    </div>
                                {else}
                                    <div class="access" style="margin-bottom: 31px;"></div>
                                {/if}
                                {if $plan_contratado.precio|floatval > $plan.precio|floatval}
                                    <br>
                                {elseif $plan_contratado.precio == $plan.precio}
                                    <span class="suscripcion-activa">
                                        {"Mi adhesión"|x_translate}
                                    </span>
                                {else}
                                    <button class="btn-suscribir" title='{"Suscribirme"|x_translate}' data-cancelacion="{$empresa.cancelar_suscripcion}" data-id-contratado="{$plan_contratado.idprograma_salud_plan}" data-precio="{$plan.precio}"  data-id="{$plan.idprograma_salud_plan}">

                                        {"Cambiar suscripcion"|x_translate}  
                                    </button>
                                {/if}

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
                                            <i class="fa fa-plus"></i> {"Fonctionnalités illiimitées"|x_translate}
                                        </p>
                                        </ul>
                                    </div>
                                {/if}
                                <hr>
                                <div  class="descripcion-content">
                                    {if $plan.idprograma_salud_plan==1}
                                        {if $plan.primer_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.primer_texto_card} {else}  {$plan.primer_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"1. Para comenzar"|x_translate}</p>
                                        {/if}
                                        {if $plan.segundo_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.segundo_texto_card} {else} {$plan.segundo_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"1. Libre de impuestos para el empleado"|x_translate}</p>
                                        {/if}
                                        {if $plan.tercer_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.tercer_texto_card} {else} {$plan.tercer_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"1. Deducible para la empresa"|x_translate}</p>
                                        {/if}
                                    {else if $plan.idprograma_salud_plan==2}
                                        {if $plan.primer_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.primer_texto_card} {else}  {$plan.primer_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"2. Con seguimiento"|x_translate}</p>
                                        {/if}
                                        {if $plan.segundo_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.segundo_texto_card} {else} {$plan.segundo_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"2. Libre de impuestos para el empleado"|x_translate}</p>
                                        {/if}
                                        {if $plan.tercer_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.tercer_texto_card} {else} {$plan.tercer_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"2. Deducible para la empresa"|x_translate}</p>
                                        {/if}
                                    {else if $plan.idprograma_salud_plan==3}
                                        {if $plan.primer_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.primer_texto_card} {else}  {$plan.primer_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"3. Mini programa!"|x_translate}</p>
                                        {/if}
                                        {if $plan.segundo_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.segundo_texto_card} {else} {$plan.segundo_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"3. Sin exención de impuestos (i)"|x_translate}</p>
                                        {/if}
                                        {if $plan.tercer_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.tercer_texto_card} {else} {$plan.tercer_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"3. Deducible para la empresa"|x_translate}</p>
                                        {/if}
                                    {else if $plan.idprograma_salud_plan==4}
                                        {if $plan.primer_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.primer_texto_card} {else}  {$plan.primer_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"4. Programa ilimitado!"|x_translate}</p>
                                        {/if}
                                        {if $plan.segundo_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.segundo_texto_card} {else} {$plan.segundo_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"4. Sin exención de impuestos (i)"|x_translate}</p>
                                        {/if}
                                        {if $plan.tercer_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.tercer_texto_card} {else} {$plan.tercer_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"4. Deducible para la empresa"|x_translate}</p>
                                        {/if}
                                    {else if $plan.idprograma_salud_plan==5}
                                        {if $plan.primer_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.primer_texto_card} {else}  {$plan.primer_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"5. Descubrimiento"|x_translate}</p>
                                        {/if}
                                        {if $plan.segundo_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.segundo_texto_card} {else} {$plan.segundo_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"5. Libre de impuestos para el empleado"|x_translate}</p>
                                        {/if}
                                        {if $plan.tercer_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.tercer_texto_card} {else} {$plan.tercer_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"5. Personalizable por el CSE"|x_translate}</p>
                                        {/if}
                                    {else if $plan.idprograma_salud_plan==6}
                                        {if $plan.primer_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.primer_texto_card} {else}  {$plan.primer_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"6. Con seguimiento"|x_translate}</p>
                                        {/if}
                                        {if $plan.segundo_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.segundo_texto_card} {else} {$plan.segundo_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"6. Libre de impuestos para el empleado"|x_translate}</p>
                                        {/if}
                                        {if $plan.tercer_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.tercer_texto_card} {else} {$plan.tercer_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"6. Personalizable por el CSE"|x_translate}</p>
                                        {/if}
                                    {else if $plan.idprograma_salud_plan==7}
                                        {if $plan.primer_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.primer_texto_card} {else}  {$plan.primer_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"7. Mini programa"|x_translate}</p>
                                        {/if}
                                        {if $plan.segundo_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.segundo_texto_card} {else} {$plan.segundo_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"7. Libre de impuestos para el empleado"|x_translate}</p>
                                        {/if}
                                        {if $plan.tercer_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.tercer_texto_card} {else} {$plan.tercer_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"7. Personalizable por el CSE"|x_translate}</p>
                                        {/if}
                                    {else}
                                        {if $plan.primer_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.primer_texto_card} {else}  {$plan.primer_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"1. Para comenzar"|x_translate}</p> 
                                        {/if}
                                        {if $plan.segundo_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.segundo_texto_card} {else} {$plan.segundo_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"1. Libre de impuestos para el empleado"|x_translate}</p>
                                        {/if}
                                        {if $plan.tercer_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.tercer_texto_card} {else} {$plan.tercer_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"1. Deducible para la empresa"|x_translate}</p>
                                        {/if}

                                    {/if}
                                </div>
                                {if  $plan.idprograma_salud_plan !=21 && $plan.idprograma_salud_plan !=22 && $plan.idprograma_salud_plan !=23}
                                    <div class="destacado-planes"  {if $plan.idprograma_salud_plan==20}style="border-top: 10px solid #3EBAC7;border-bottom: 10px solid #3EBAC7;"{/if}>
                                        {if $plan.idprograma_salud_plan!=18 && $plan.idprograma_salud_plan!=19 && $plan.idprograma_salud_plan!=20}
                                            <span class="span-dest-planes">{"Hasta 65 euros de reembolso"|x_translate}</span>
                                        {else}
                                            <span class="span-dest-planes">{"Hasta 30 euros de reembolso"|x_translate}</span>
                                        {/if}
                                    </div>
                                {/if}
                                {if $plan.idprograma_salud_plan==20}
                                    <br>
                                    <span class="span-dest-planes">{"Note : le budget engagé englobe l’ensemble des salariés et ne fait pas l’objet de remboursement."|x_translate}</span>   
                                {/if}


                            </div>
                        {/if}
                    {else}
                        {if $plan_contratado.precio|floatval <= $plan.precio|floatval && $plan_contratado.pack==$plan.pack && ($plan.idprograma_salud_plan =='20' || $plan.idprograma_salud_plan =='23' )}

                            <div class="item-plan {if $plan_contratado.idprograma_salud_plan == $plan.idprograma_salud_plan}plan-contratado{/if} {if $plan_contratado.idprograma_salud_plan > $plan.idprograma_salud_plan}plan-no-disponible{/if}"  data-id="{$plan.idprograma_salud_plan}">
                                <div class="plan-title" data-id="{$plan.idprograma_salud_plan}" >
                                    {$plan.nombre}
                                </div>
                                {if $plan.idprograma_salud_plan !=21 && $plan.idprograma_salud_plan !=22 && $plan.idprograma_salud_plan !=23}
                                    <div class="plan-precio">
                                        &euro; {$plan.precio}
                                        <div class="label">
                                            {"precio por beneficiario / por mes"|x_translate}
                                        </div>
                                    </div>
                                {else}
                                    <div class="access" style="margin-bottom: 31px;"></div>
                                {/if}
                                {if $plan_contratado.precio|floatval > $plan.precio|floatval}
                                    <br>
                                {elseif $plan_contratado.precio == $plan.precio}
                                    <span class="suscripcion-activa">
                                        {"Mi adhesión"|x_translate}
                                    </span>
                                {else}
                                    <button class="btn-suscribir" title='{"Suscribirme"|x_translate}' data-cancelacion="{$empresa.cancelar_suscripcion}" data-id-contratado="{$plan_contratado.idprograma_salud_plan}" data-precio="{$plan.precio}"  data-id="{$plan.idprograma_salud_plan}">

                                        {"Cambiar suscripcion"|x_translate}  
                                    </button>
                                {/if}

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
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.primer_texto_card} {else}  {$plan.primer_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"1. Para comenzar"|x_translate}</p>
                                        {/if}
                                        {if $plan.segundo_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.segundo_texto_card} {else} {$plan.segundo_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"1. Libre de impuestos para el empleado"|x_translate}</p>
                                        {/if}
                                        {if $plan.tercer_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.tercer_texto_card} {else} {$plan.tercer_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"1. Deducible para la empresa"|x_translate}</p>
                                        {/if}
                                    {else if $plan.idprograma_salud_plan==2}
                                        {if $plan.primer_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.primer_texto_card} {else}  {$plan.primer_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"2. Con seguimiento"|x_translate}</p>
                                        {/if}
                                        {if $plan.segundo_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.segundo_texto_card} {else} {$plan.segundo_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"2. Libre de impuestos para el empleado"|x_translate}</p>
                                        {/if}
                                        {if $plan.tercer_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.tercer_texto_card} {else} {$plan.tercer_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"2. Deducible para la empresa"|x_translate}</p>
                                        {/if}
                                    {else if $plan.idprograma_salud_plan==3}
                                        {if $plan.primer_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.primer_texto_card} {else}  {$plan.primer_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"3. Mini programa!"|x_translate}</p>
                                        {/if}
                                        {if $plan.segundo_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.segundo_texto_card} {else} {$plan.segundo_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"3. Sin exención de impuestos (i)"|x_translate}</p>
                                        {/if}
                                        {if $plan.tercer_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.tercer_texto_card} {else} {$plan.tercer_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"3. Deducible para la empresa"|x_translate}</p>
                                        {/if}
                                    {else if $plan.idprograma_salud_plan==4}
                                        {if $plan.primer_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.primer_texto_card} {else}  {$plan.primer_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"4. Programa ilimitado!"|x_translate}</p>
                                        {/if}
                                        {if $plan.segundo_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.segundo_texto_card} {else} {$plan.segundo_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"4. Sin exención de impuestos (i)"|x_translate}</p>
                                        {/if}
                                        {if $plan.tercer_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.tercer_texto_card} {else} {$plan.tercer_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"4. Deducible para la empresa"|x_translate}</p>
                                        {/if}
                                    {else if $plan.idprograma_salud_plan==5}
                                        {if $plan.primer_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.primer_texto_card} {else}  {$plan.primer_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"5. Descubrimiento"|x_translate}</p>
                                        {/if}
                                        {if $plan.segundo_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.segundo_texto_card} {else} {$plan.segundo_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"5. Libre de impuestos para el empleado"|x_translate}</p>
                                        {/if}
                                        {if $plan.tercer_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.tercer_texto_card} {else} {$plan.tercer_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"5. Personalizable por el CSE"|x_translate}</p>
                                        {/if}
                                    {else if $plan.idprograma_salud_plan==6}
                                        {if $plan.primer_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.primer_texto_card} {else}  {$plan.primer_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"6. Con seguimiento"|x_translate}</p>
                                        {/if}
                                        {if $plan.segundo_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.segundo_texto_card} {else} {$plan.segundo_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"6. Libre de impuestos para el empleado"|x_translate}</p>
                                        {/if}
                                        {if $plan.tercer_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.tercer_texto_card} {else} {$plan.tercer_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"6. Personalizable por el CSE"|x_translate}</p>
                                        {/if}
                                    {else if $plan.idprograma_salud_plan==7}
                                        {if $plan.primer_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.primer_texto_card} {else}  {$plan.primer_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"7. Mini programa"|x_translate}</p>
                                        {/if}
                                        {if $plan.segundo_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.segundo_texto_card} {else} {$plan.segundo_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"7. Libre de impuestos para el empleado"|x_translate}</p>
                                        {/if}
                                        {if $plan.tercer_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.tercer_texto_card} {else} {$plan.tercer_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"7. Personalizable por el CSE"|x_translate}</p>
                                        {/if}
                                    {else}
                                        {if $plan.primer_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.primer_texto_card} {else}  {$plan.primer_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"1. Para comenzar"|x_translate}</p> 
                                        {/if}
                                        {if $plan.segundo_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.segundo_texto_card} {else} {$plan.segundo_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"1. Libre de impuestos para el empleado"|x_translate}</p>
                                        {/if}
                                        {if $plan.tercer_texto_card!=''}
                                            <p>{if $TRADUCCION_DEFAULT=="fr"}  {$plan.tercer_texto_card} {else} {$plan.tercer_texto_card_en} {/if}</p>
                                        {else}
                                            <p>{"1. Deducible para la empresa"|x_translate}</p>
                                        {/if}

                                    {/if}
                                </div>
                                {if  $plan.idprograma_salud_plan !=21 && $plan.idprograma_salud_plan !=22 && $plan.idprograma_salud_plan !=23}
                                    <div class="destacado-planes"  {if $plan.idprograma_salud_plan==20}style="border-top: 10px solid #3EBAC7;border-bottom: 10px solid #3EBAC7;"{/if}>
                                        {if $plan.idprograma_salud_plan!=18 && $plan.idprograma_salud_plan!=19 && $plan.idprograma_salud_plan!=20}
                                            <span class="span-dest-planes">{"Hasta 65 euros de reembolso"|x_translate}</span>
                                        {else}
                                            <span class="span-dest-planes">{"Hasta 30 euros de reembolso"|x_translate}</span>
                                        {/if}
                                    </div>
                                {/if}
                                {if $plan.idprograma_salud_plan==20}
                                    <br>
                                    <span class="span-dest-planes">{"Note : le budget engagé englobe l’ensemble des salariés et ne fait pas l’objet de remboursement."|x_translate}</span>   
                                {/if}


                            </div>
                        {/if}
                    {/if}
                {/foreach}

            </div>
            <div class="aclaracion-impuestos">{"(i) Por encima del límite de 171 euros / año y por empleado."|x_translate}</div>
        </div>
</section>

<input id="costo_plan" hidden/>
<div class="modal modal-plan-contratado" tabindex="-1" role="dialog" id="modal-plan-contratado" data-keyboard="false" data-backdrop="static">
    <div class="modal-dialog"  role="document">
        <div class="modal-content" >
            <button id="btnclosemodal" type="button" class="dp-dismiss custom close" data-dismiss="modal" aria-label="Close"></button>
            <div class="modal-body" id="modal-plan-contratado-body">
                <div class="pass-sante-registro-planes">
                    <div class="creacion-cuenta">
                        <div class="header-container text-center" style="margin-top: 0px;">
                            <div class="logo-container">
                                <img src="{$IMGS}logo_pass_bienetre.png"/>
                            </div>
                        </div>  
                        <div class="planes-wrapper"> 

                            <div class="okm-row" id="cant_packs_container">

                                <div class="mapc-registro-form-row">
                                    <label class="mapc-label">{"Cantidad de pack adquiridos"|x_translate}</label>
                                    <div class="mapc-input-line input-group" >
                                        <span class="input-group-addon button menos-cant" id="menos-cant" ><i class="fa fa-minus"></i></span>
                                        <input type="number" class="pul-np-dis" name="cant_packs" id="cant_packs" style="text-align: center;" value="1"/>
                                        <span class="input-group-addon button mas-cant" id="mas-cant"><i class="fa fa-plus"></i></span>
                                    </div>
                                </div>
                            </div>

                            <span class="precio-total-pack">

                            </span>
                        </div>
                        <div class="text-center button-container">
                            <a id="comprarPacks"  class="btn btn-cambiar-plan btn-default">{"Comprar"|x_translate}</a>
                        </div>
                    </div>         
                </div>
            </div>
        </div>
    </div>
</div>  


{literal}
    <script>
        $(function () {
            var id;
            var precio;
            var valorCancelacion;
            var id_contratado;


            $("#btnclosemodal").click(function () {
                $("#cant_packs").val(1);
                $("#sectPrin").removeClass("opp");
                $("#modal-plan-contratado").hide();
            });


            //listener modificar cantidad pack
            $(".mas-cant,.menos-cant").click(function () {
                let actual_val = parseInt($("#cant_packs").val());
                if (isNaN(actual_val)) {
                    return false;
                }

                if ($(this).hasClass("mas-cant")) {
                    $("#cant_packs").val(++actual_val);
                } else {
                    //minimo 1 pack, no seguimos restando
                    if (actual_val > 1) {
                        $("#cant_packs").val(--actual_val);
                    }
                }
                $("#cant_packs").trigger("change");


            });
            //detectamos el cambio de la cantidad y recalculamos el total
            $("#cant_packs").change(function () {
                if (isNaN(parseInt($("#costo_plan").val())) || isNaN(parseInt($("#cant_packs").val()))) {
                    return false;
                }
                $(".precio-total-pack").html("€" + (parseFloat($("#costo_plan").val()) * parseInt($("#cant_packs").val())).toFixed(1));
            });




            //eliminamos la consulta en borrador y recargamos
            $(".btn-suscribir").on("click", function () {
                precio = $(this).data("precio");

                id = $(this).data("id");
                valorCancelacion = $(this).data("cancelacion");
                id_contratado = $(this).data("id-contratado");

                if (id_contratado == 21) {
                    $("#costo_plan").val(precio);
                    $(".precio-total-pack").html("€" + (parseFloat($("#costo_plan").val())).toFixed(1));
                    $("#modal-plan-contratado").show();
                    $("#sectPrin").addClass("opp");

                } else {
                    cantidadEmpleados = 0;


                    if (id_contratado == 21 || id_contratado == 22 || id_contratado == 23) {
                        if (valorCancelacion == 2) {
                            valorCancelacionpar = 0;
                        } else {
                            valorCancelacionpar = valorCancelacion;
                        }
                        $("body").spin("large");

                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + 'empresa.php?action=1&modulo=home&submodulo=setear_plan_post_gratuito',
                                'plan_idplan_siguiente=' + id + "&cancelar_suscripcion=" + valorCancelacionpar
                                + "&cantidadEmpleados=" + cantidadEmpleados,
                                function (data) {
                                    $("body").spin(false);
                                    if (data.result) {
                                        if (id_contratado == 21 || id_contratado == 23) {
                                            window.location.href = BASE_PATH + "entreprises/paypack.html";
                                        }
                                        if (id_contratado == 22) {
                                            window.location.href = BASE_PATH + "entreprises/paymonth.html";
                                        }
                                    } else {
                                        x_alert(data.msg);
                                    }
                                }
                        );
                    } else {
                        var title = $(".plan-title[data-id=" + id + "]").text();
                        if (id) {


                            jConfirm({
                                title: title,
                                text: x_translate('Está por actualizar su suscripción. ¿Desea continuar?'),
                                confirm: function () {
                                    $("body").spin("large");
                                    x_doAjaxCall(
                                            'POST',
                                            BASE_PATH + 'empresa.php?action=1&modulo=home&submodulo=actualizar_suscripcion',
                                            'id=' + id + "&precio=" + precio,
                                            function (data) {
                                                $("body").spin(false);
                                                if (data.result) {
                                                    x_alert(data.msg, function () {
                                                        window.location.href = BASE_PATH + "entreprises/";
                                                    });

                                                } else {
                                                    x_alert(data.msg);
                                                }
                                            }
                                    );
                                },
                                cancel: function () {

                                },
                                confirmButton: x_translate("Si"),
                                cancelButton: x_translate("No")
                            });
                        }
                    }
                }

            });


            $("#comprarPacks").on("click", function () {

                cantidadEmpleados = $("#cant_packs").val();


                if (valorCancelacion == 2) {
                    valorCancelacionpar = 0;
                } else {
                    valorCancelacionpar = valorCancelacion;
                }
                $("body").spin("large");

                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'empresa.php?action=1&modulo=home&submodulo=setear_plan_post_gratuito',
                        'plan_idplan_siguiente=' + id + "&cancelar_suscripcion=" + valorCancelacionpar
                        + "&cantidadEmpleados=" + cantidadEmpleados,
                        function (data) {
                            $("body").spin(false);
                            if (data.result) {
                                if (id_contratado == 21 || id_contratado == 23) {
                                    window.location.href = BASE_PATH + "entreprises/paypack.html";
                                }
                                if (id_contratado == 22) {
                                    window.location.href = BASE_PATH + "entreprises/paymonth.html";
                                }
                            } else {
                                x_alert(data.msg);
                            }
                        }
                );

            });



        });
    </script>
{/literal}