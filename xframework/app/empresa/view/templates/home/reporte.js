//inciializamos la impresion de pantalla

$(".btn-imprimir").click(function () {
    window.print();
});

// las variables las marca como que no existen pero estan definidaas en reporte.tpl

// grafico de torta - presupuesto utilizado
var ctx2 = document.getElementById('myChart2').getContext('2d');
var coloresTorta = Array();
valoresPresupuesto.forEach(function () {
    coloresTorta.push(color());
});
//reemplazamos el ultomo color (presupuesto restante) por gris
coloresTorta[valoresPresupuesto.length - 1] = "rgb(205,205,205)";

new Chart(ctx2, {
    type: 'pie',
    data: {
        labels:
                mesesPresupuesto
        ,
        datasets: [{
                label: '',
                data: valoresPresupuesto,
                backgroundColor: coloresTorta,
                hoverOffset: 3
            }]
    },
    options: {
        scales: {
            y: {
                beginAtZero: true,
                display: false
            },
            x: {
                display: false

            }
        },
        datasets: {
            pie: {
                radius: 140}
        },
        layout: {
            padding: 0
        }
    }
});

// grafico de linea
var ctx4 = document.getElementById('myChart4').getContext('2d');
new Chart(ctx4, {
    type: 'line',
    data: {
        labels: mesesTasa,
        datasets: [{
                label: x_translate('Beneficiarios'),
                data: valoresTasa,
                fill: false,
                borderColor: 'rgb(255, 99, 132)',
                tension: 0.2
            }
        ]
    },
    options: {
        scales: {
            y: {
                beginAtZero: true,
                title: {
                    display: true,
                    text: x_translate('% Beneficiarios inscriptos')
                },
                max: 100,
                ticks: {
                    callback: function (value, index, values) {
                        return value + '%';
                    }
                }
            }
        },
        plugins: {
            legend: {

                labels: {
                    color: 'rgb(255, 255, 255)',
                    boxWidth: 0
                }
            }
        }
    }
});

// grafica de barras verticales
var ctx1 = document.getElementById('myChart').getContext('2d');
var coloresBarrasVerticales = Array();
valoresImporte.forEach(function () {
    coloresBarrasVerticales.push(color());
});
new Chart(ctx1, {
    type: 'bar',
    data: {
        labels: mesesImporte,
        datasets: [{
                label: '',
                data: valoresImporte,
                backgroundColor: coloresBarrasVerticales,
                borderColor: coloresBarrasVerticales,
                borderWidth: 1
            }]
    },
    options: {
        scales: {
            y: {
                beginAtZero: true,
                title: {
                    display: false,
                    text: "EUR"
                },
                ticks: {
                    callback: function (value, index, values) {
                        return '€' + value;
                    }
                }
            }
        },
        plugins: {
            legend: {
                labels: {
                    color: 'rgb(255, 255, 255)',
                    boxWidth: 0
                }
            }
        }
    }
});

// grafica de barras horizontales - programas 
var ctx3 = document.getElementById('myChart3').getContext('2d');
var coloresBarrasHorizontales = Array();
valoresProgramas.forEach(function () {
    coloresBarrasHorizontales.push(color());
});
new Chart(ctx3, {
    type: 'bar',
    data: {
        labels: labelProgramas,
        datasets: [{
                axis: 'y',
                label: x_translate('Consultas realizadas'),
                data: valoresProgramas,
                fill: false,
                backgroundColor: coloresBarrasHorizontales,
                borderColor: coloresBarrasHorizontales,
                borderWidth: 1
            }]
    },
    options: {
        indexAxis: 'y',
        plugins: {
            legend: {

                labels: {
                    color: 'rgb(255, 255, 255)',
                    boxWidth: 0
                }
            }
        },
        scales: {

            x: {
                ticks: {
                    precision: 0
                },
                title: {
                    display: true,
                    text: x_translate('Consultas realizadas')
                }
            }
        },
    }
});


// grafico de un porcentaje de dona

var ctx5 = document.getElementById('myChart5').getContext('2d');

new Chart(ctx5, {
    type: 'doughnut',
    data: {
        datasets: [{

                data: [porcentajeUso, 100 - porcentajeUso],
                backgroundColor:
                        [color(), "rgb(255,255,255)"],
                hoverBackgroundColor: [color(), "rgb(255,255,255)"]

            }]
    },
    options: {
        scales: {
            y: {
                beginAtZero: true,
                display: false
            },
            x: {
                display: false
            }
        },
        datasets: {
            doughnut: {
                radius: 140,
                circumference: 360,
            }
        },
        layout: {
            padding: 0
        }
    }
});

function color() {
    var colors_list = [
        "rgb(14,194,161)",
        "rgb(232,5,116)",
        "rgb(255,129,140)",
        "rgb(0,125,139)",
        "rgb(168,242,243)",
        "rgb(250,200,113)",
        "rgb(2,184,193)",
        "rgb(255,169,18)",
        "rgb(54,199,195)",
        "rgb(241,141,92)",
        "rgb(187,39,111)",
        "rgb(224,121,171)",
        "rgb(68,125,124)",
        "rgb(243,210,64)",
        "rgb(255,111,111)",
        "rgb(231,76,60)"];
    var r = Math.floor(Math.random() * 15);
    return colors_list[r];
}
