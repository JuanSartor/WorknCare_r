

<article class="col-md-6">
    <div class="card card-blue grid-overview">
        <div class="card-header">
            <h1 class="card-title">{"Medicamentos"|x_translate}</h1>
            <div class="card-value value icon-card">
                <span class="dp-medicine"></span>
            </div>	
        </div>
        <div class="card-body">
            <ul class="slider-for">
                
                {foreach from=$list_medicamentos item=medicamento}
                <li>
                    <div class="row">
                        <div class="data col-md-6"><em>{"Medicamento / droga"|x_translate}</em>{$medicamento.nombre_medicamento}</div>
                        <div class="data col-md-6"><em>{"Posología"|x_translate}</em>{$medicamento.posologia}</div>
                    </div>
                </li>
                {foreachelse}
                <li>
                    <div class="row">
                        <div class="data col-md-11"><em><h6>{"No posee registro de medicamentos"|x_translate}</h6></em></div>
                    </div>
                </li>
                {/foreach}
            </ul>
        </div>
        
    </div>
</article>

{literal}
<script>
    $('#div_medicamentos .slider-for').slick({
			  slidesToShow: 1,
			  slidesToScroll: 1,
			  arrows: false,
			  dots:true,
			  centerMode: false,
			  fade: true
			});
</script>
{/literal}
