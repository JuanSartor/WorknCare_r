<article class="col-md-6 ">
    <div class="card card-white estilo-de-vida">
        <div class="card-header">
            <h1 class="card-title">{"Estilo de vida"|x_translate}</h1>
        </div>

        <div class="card-body">
            <div class="indices-porcentaje">
                {*<ul>
                    <li>0%</li>
                    <li>{"Recomendable"|x_translate}</li>
                    <li>100%</li>
                </ul>
                <span class="line"></span>*}
            </div>
            <table>
                <tbody>
                    <tr class="row-ac">
                        <td><span></span>{"Actividad física"|x_translate}</td>
                        <td>
                            <div class="progress">

                                {if $info_estilo_vida.porc_actividad_fisica == 0}
                                <div class="progress-bar progress-bar-success" role="progressbar" style="width:0%"></div>
                                <div class="progress-bar progress-bar-warning" role="progressbar" style="width:0%"></div>
                                <div class="progress-bar progress-bar-danger" role="progressbar" style="width:0%"></div>
                                {else}
                                <div class="progress-bar progress-bar-success" role="progressbar" style="width:{$info_estilo_vida.porc_actividad_fisica_verde}%"></div>
                                <div class="progress-bar progress-bar-warning" role="progressbar" style="width:{$info_estilo_vida.porc_actividad_fisica_amarillo}%"></div>
                                <div class="progress-bar progress-bar-danger" role="progressbar" style="width:{$info_estilo_vida.porc_actividad_fisica_rojo}%"></div>
                                {/if}
                            </div>			
                        </td>
                    </tr>
                    <tr class="row-ct">
                        <td><span></span>{"Consumo de tabaco"|x_translate}</td>
                        <td>
                            <div class="progress">
                                {if $info_estilo_vida.porc_consumo_tabaco == 0}
                                <div class="progress-bar progress-bar-success" role="progressbar" style="width:0%"></div>
                                <div class="progress-bar progress-bar-warning" role="progressbar" style="width:0%"></div>
                                <div class="progress-bar progress-bar-danger" role="progressbar" style="width:0%"></div>
                                {else}
                                <div class="progress-bar progress-bar-success" role="progressbar" style="width:{$info_estilo_vida.porc_consumo_tabaco_verde}%"></div>
                                <div class="progress-bar progress-bar-warning" role="progressbar" style="width:{$info_estilo_vida.porc_consumo_tabaco_amarillo}%"></div>
                                <div class="progress-bar progress-bar-danger" role="progressbar" style="width:{$info_estilo_vida.porc_consumo_tabaco_rojo}%"></div>
                                {/if}
                            </div>			
                        </td>		
                    </tr>
                    <tr class="row-ca">
                        <td><span></span>{"Consumo de alcohol"|x_translate}</td>
                        <td>
                            <div class="progress">
                                {if $info_estilo_vida.porc_consumo_alcohol == 0}
                                <div class="progress-bar progress-bar-success" role="progressbar" style="width:0%"></div>
                                <div class="progress-bar progress-bar-warning" role="progressbar" style="width:0%"></div>
                                <div class="progress-bar progress-bar-danger" role="progressbar" style="width:0%"></div>
                                {else}
                                <div class="progress-bar progress-bar-success" role="progressbar" style="width:{$info_estilo_vida.porc_consumo_alcohol_verde}%"></div>
                                <div class="progress-bar progress-bar-warning" role="progressbar" style="width:{$info_estilo_vida.porc_consumo_alcohol_amarillo}%"></div>
                                <div class="progress-bar progress-bar-danger" role="progressbar" style="width:{$info_estilo_vida.porc_consumo_alcohol_rojo}%"></div>
                                {/if}
                            </div>			
                        </td>		
                    </tr>
                    <tr class="row-cag">
                        <td><span></span>{"Consumo de azúcares y grasas"|x_translate}</td>
                        <td>
                            <div class="progress">
                                {if $info_estilo_vida.porc_azucares_grasas == 0}
                                <div class="progress-bar progress-bar-success" role="progressbar" style="width:0%"></div>
                                <div class="progress-bar progress-bar-warning" role="progressbar" style="width:0%"></div>
                                <div class="progress-bar progress-bar-danger" role="progressbar" style="width:0%"></div>
                                {else}
                                <div class="progress-bar progress-bar-success" role="progressbar" style="width:{$info_estilo_vida.porc_azucares_grasas_verde}%"></div>
                                <div class="progress-bar progress-bar-warning" role="progressbar" style="width:{$info_estilo_vida.porc_azucares_grasas_amarillo}%"></div>
                                <div class="progress-bar progress-bar-danger" role="progressbar" style="width:{$info_estilo_vida.porc_azucares_grasas_rojo}%"></div>
                                {/if}
                            </div>			
                        </td>		
                    </tr>
                    <tr class="row-cs">
                        <td><span></span>{"Consumo de sal"|x_translate}</td>
                        <td>
                            <div class="progress">
                                {if $info_estilo_vida.porc_consumo_sal == 0}
                                <div class="progress-bar progress-bar-success" role="progressbar" style="width:0%"></div>
                                <div class="progress-bar progress-bar-warning" role="progressbar" style="width:0%"></div>
                                <div class="progress-bar progress-bar-danger" role="progressbar" style="width:0%"></div>
                                {else}
                                <div class="progress-bar progress-bar-success" role="progressbar" style="width:{$info_estilo_vida.porc_consumo_sal_verde}%"></div>
                                <div class="progress-bar progress-bar-warning" role="progressbar" style="width:{$info_estilo_vida.porc_consumo_sal_amarillo}%"></div>
                                <div class="progress-bar progress-bar-danger" role="progressbar" style="width:{$info_estilo_vida.porc_consumo_sal_rojo}%"></div>
                                {/if}
                            </div>			
                        </td>		
                    </tr>	
                </tbody>					
            </table>

            <p>{"Valores recomendables por la OMS"|x_translate}</p>
        </div>
    </div>
</article>					
<!-- estilo de vida -->		
