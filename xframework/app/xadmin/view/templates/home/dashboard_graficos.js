$(document).ready(function () {

// request para Consultas Express
    var url = BASE_PATH + "xadmin.php?";
    var queryStr = "action=1&modulo=home&submodulo=cargar_dashboard_consultasExpress";

    x_doAjaxCall("POST",
            url,
            queryStr,
            function (data) {
                graficarConsultasExpressLinea(data.lista5, data.lista4, data.lista3, 1);
                graficarConsultasExpressDona(data.lista5, data.lista4, data.lista3, 1);
            },
            "",
            "",
            true,
            true);

    // request para Video Consulta
    var url = BASE_PATH + "xadmin.php?";
    var queryStr = "action=1&modulo=home&submodulo=cargar_dashboard_videoConsultas";

    x_doAjaxCall("POST",
            url,
            queryStr,
            function (data) {
                graficarConsultasExpressLinea(data.lista5vc, data.lista4vc, data.lista3vc, 2);
                graficarConsultasExpressDona(data.lista5vc, data.lista4vc, data.lista3vc, 2);
            },
            "",
            "",
            true,
            true);

/////////////////////////////////////////
// metodo que grafica el diagrama de lineas 
///////////////////////////////////////////
    function graficarConsultasExpressLinea(lista5, lista4, lista3, bandera) {

        fechaActual = new Date();
        fechaDefinitiva = Array();
        fechaDefinitiva[0] = fechaActual.getFullYear();
        fechaDefinitiva[1] = fechaActual.getMonth();
        fechasLabel = Array();

// creo los datos para el eje x 
        for (var i = 1; i < 13; i++) {

            if (fechaDefinitiva[1] > 0 && fechaDefinitiva[1] > 9) {
                fechasLabel.push(fechaDefinitiva[0] + '-' + fechaDefinitiva[1]);
                fechaDefinitiva[1]--;
            } else if (fechaDefinitiva[1] > 0 && fechaDefinitiva[1] < 10) {

                fechasLabel.push(fechaDefinitiva[0] + '-' + '0' + fechaDefinitiva[1]);
                fechaDefinitiva[1]--;
            } else {
                fechaDefinitiva[0]--;
                fechaDefinitiva[1] = 12;
                fechasLabel.push(fechaDefinitiva[0] + '-' + fechaDefinitiva[1]);
                fechaDefinitiva[1]--;
            }
        }

//  creo el array con todas las fechas  para la lista 5
        fechas5 = Array();
        lista5.forEach(function (elemento) {
            fechas5.push(elemento.fecha);
        });
        //  creo el array con todas las fechas  para la lista 4
        fechas4 = Array();
        lista4.forEach(function (elemento) {
            fechas4.push(elemento.fecha);
        });
        //  creo el array con todas las fechas  para la lista 3
        fechas3 = Array();
        lista3.forEach(function (elemento) {
            fechas3.push(elemento.fecha);
        });


        // si no esta incluida alguna fecha la agrego con el valor 0
        fechasLabel.forEach(function (mes) {
            if (!fechas5.includes(mes)) {
                var objNuevo = new Object();
                objNuevo.fecha = mes;
                objNuevo.cantidad = '0';
                lista5.push(objNuevo);
            }
            if (!fechas4.includes(mes)) {
                var objNuevo4 = new Object();
                objNuevo4.fecha = mes;
                objNuevo4.cantidad = '0';
                lista4.push(objNuevo4);
            }
            if (!fechas3.includes(mes)) {
                var objNuevo3 = new Object();
                objNuevo3.fecha = mes;
                objNuevo3.cantidad = '0';
                lista3.push(objNuevo3);
            }
        });

// obtengo las cantidades para los ejes y
// ordeno la lista
        lista4.sort(function (a, b) {
            var c = new Date(a.fecha);
            var d = new Date(b.fecha);
            return c - d;
        });
        cantidad4 = Array();
        lista4.forEach(function (elemento) {
            cantidad4.push(elemento.cantidad);

        });

        // ordeno la lista
        lista5.sort(function (a, b) {
            var c = new Date(a.fecha);
            var d = new Date(b.fecha);
            return c - d;
        });
        cantidad5 = Array();
        lista5.forEach(function (elemento) {
            cantidad5.push(elemento.cantidad);

        });



        // ordeno la lista
        lista3.sort(function (a, b) {
            var c = new Date(a.fecha);
            var d = new Date(b.fecha);
            return c - d;
        });

        cantidad3 = Array();
        lista3.forEach(function (elemento) {
            cantidad3.push(elemento.cantidad);

        });

        if (bandera == '1') { //  aca ingresa para hacer el grafico de linea de CONSULTAS EXPRESS
            var ctx = document.getElementById('myChart').getContext('2d');
            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: fechasLabel.sort(),
                    datasets: [{
                            label: x_translate('Finalizadas'),
                            data: cantidad4,
                            fill: false,
                            borderColor: 'rgb(255, 99, 132)',
                            tension: 0.2
                        },
                        {
                            label: x_translate('Vencidas'),
                            data: cantidad5,
                            fill: false,
                            borderColor: 'rgb(54, 162, 235)',
                            tension: 0.2
                        },
                        {
                            label: x_translate('Declinadas'),
                            data: cantidad3,
                            fill: false,
                            borderColor: 'rgb(91, 202, 131)',
                            tension: 0.2
                        }
                    ]
                },
                options: {
                    scales: {
                        y: {
                            beginAtZero: true
                        },
                        x: {
                            display: false
                        }
                    }
                }
            });
        } else {  //  aca ingresa para hacer el grafico de linea de VIDEO CONSULTAS
            var ctx2 = document.getElementById('myChart2').getContext('2d');
            new Chart(ctx2, {
                type: 'line',
                data: {
                    labels: fechasLabel.sort(),
                    datasets: [{
                            label: x_translate('Finalizadas'),
                            data: cantidad4,
                            fill: false,
                            borderColor: 'rgb(255, 99, 132)',
                            tension: 0.2
                        },
                        {
                            label: x_translate('Vencidas'),
                            data: cantidad5,
                            fill: false,
                            borderColor: 'rgb(54, 162, 235)',
                            tension: 0.2
                        },
                        {
                            label: x_translate('Declinadas'),
                            data: cantidad3,
                            fill: false,
                            borderColor: 'rgb(91, 202, 131)',
                            tension: 0.2
                        }
                    ]
                },
                options: {
                    scales: {
                        y: {
                            beginAtZero: true,

                        },
                        x: {
                            display: false
                        }
                    }


                }
            });

        }



    }

/////////////////////////////////////////
// metodo que grafica el diagrama de donas 
///////////////////////////////////////////

    function graficarConsultasExpressDona(lista5, lista4, lista3, bandera) {

        suma4 = 0;
        lista4.forEach(function (elemento) {
            suma4 = suma4 + Number(elemento.cantidad);

        });

        suma5 = 0;
        lista5.forEach(function (elemento) {
            suma5 = suma5 + Number(elemento.cantidad);

        });

        suma3 = 0;
        lista3.forEach(function (elemento) {
            suma3 = suma3 + Number(elemento.cantidad);

        });

// aca ingresa para graficar la dona de CONSULTAS EXPRESS
        if (bandera == '1') {
            var ctx3 = document.getElementById('myChart3').getContext('2d');
            new Chart(ctx3, {
                type: 'doughnut',
                data: {
                    labels: [
                        x_translate('Finalizadas'),
                        x_translate('Vencidas'),
                        x_translate('Declinadas')

                    ],
                    datasets: [{
                            label: 'My First Dataset',
                            data: [suma4, suma5, suma3],
                            backgroundColor: [
                                'rgb(255, 99, 132)',
                                'rgb(54, 162, 235)',
                                'rgb(91, 202, 131)'
                            ],
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
                        doughnut: {
                            radius: 250}
                    }
                }
            });
        } else {  // aca ingresa para graficar la dona de VIDEO CONSULTAS
            var ctx4 = document.getElementById('myChart4').getContext('2d');
            new Chart(ctx4, {
                type: 'doughnut',
                data: {
                    labels: [
                        x_translate('Finalizadas'),
                        x_translate('Vencidas'),
                        x_translate('Declinadas')
                    ],
                    datasets: [{
                            label: 'My First Dataset',
                            data: [suma4, suma5, suma3],
                            backgroundColor: [
                                'rgb(255, 99, 132)',
                                'rgb(54, 162, 235)',
                                'rgb(91, 202, 131)'

                            ],
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
                        doughnut: {
                            radius: 250}
                    }
                }
            });
        }
    }
});
