(function(window, document, $, undefined){

  if(document.getElementById("chartjs-linechart-sowing")) {

    var ctx = document.getElementById("chartjs-linechart-sowing");
    var myLineChart = new Chart(ctx, {
      type: 'line',
      data: {
        labels: Object.keys(gon.weeks),
        datasets: [
          {
            label: "Siembras ejecutadas",
            fill: false,
            backgroundColor: "rgba(50,124,95,0.4)",
            borderColor: "rgba(50,124,95,1)",
            borderCapStyle: 'butt',
            borderDashOffset: 0.0,
            borderJoinStyle: 'miter',
            pointBorderColor: "rgba(50,124,95,1)",
            pointBackgroundColor: "#fff",
            pointBorderWidth: 1,
            pointHoverRadius: 5,
            pointHoverBackgroundColor: "rgba(50,124,95,1)",
            pointHoverBorderColor: "rgba(220,220,220,1)",
            pointHoverBorderWidth: 2,
            pointRadius: 0,
            pointHitRadius: 10,
            data: Object.values(gon.sowing),
            spanGaps: false,
          },
          {
            label: "Esquejes Teóricos",
            fill: false,
            backgroundColor: "rgba(75,134,192,0.4)",
            borderColor: "rgba(75,134,192,1)",
            borderCapStyle: 'butt',
            borderDashOffset: 0.0,
            borderJoinStyle: 'miter',
            pointBorderColor: "rgba(75,134,192,1)",
            pointBackgroundColor: "#000",
            pointBorderWidth: 1,
            pointHoverRadius: 5,
            pointHoverBackgroundColor: "rgba(75,134,192,1)",
            pointHoverBorderColor: "rgba(75,134,192,1)",
            pointHoverBorderWidth: 2,
            pointRadius: 0,
            pointHitRadius: 10,
            data: [],
            spanGaps: false,
          }
        ]
      },//end data
      options: {
              scales: {
                xAxes: [{
            gridLines: {
              display: false,
              color: "black"
            },
            scaleLabel: {
              display: true,
              labelString: "Semana - año",
              fontColor: "red"
            }
          }],
          yAxes: [{
            ticks: {
              beginAtZero:true
            },
            scaleLabel: {
              display: true,
              labelString: "Cantidad de Esquejes",
              fontColor: "green"
            }
          }]
        },
        title: {
          display: true,
          text: "Cumplimiento siembras",
          fontSize: 18
        }
      }, //end options
    });
  } // End if - chartjs-linechart-sowing

  if(document.getElementById("chartjs-linechart-production")) {

    var ctx = document.getElementById("chartjs-linechart-production");
    var myLineChart = new Chart(ctx, {
      type: 'line',
      data: {
        labels: Object.keys(gon.weeks),
        datasets: [
          {
            label: "Producción Ejecutada",
            fill: false,
            backgroundColor: "rgba(50,124,95,0.4)",
            borderColor: "rgba(50,124,95,1)",
            borderCapStyle: 'butt',
            borderDashOffset: 0.0,
            borderJoinStyle: 'miter',
            pointBorderColor: "rgba(50,124,95,1)",
            pointBackgroundColor: "#fff",
            pointBorderWidth: 1,
            pointHoverRadius: 5,
            pointHoverBackgroundColor: "rgba(50,124,95,1)",
            pointHoverBorderColor: "rgba(220,220,220,1)",
            pointHoverBorderWidth: 2,
            pointRadius: 0,
            pointHitRadius: 10,
            data: Object.values(gon.production),
            spanGaps: false,
          },
          {
            label: "Plano se siembra",
            fill: false,
            backgroundColor: "rgba(75,134,192,0.4)",
            borderColor: "rgba(75,134,192,1)",
            borderCapStyle: 'butt',
            borderDashOffset: 0.0,
            borderJoinStyle: 'miter',
            pointBorderColor: "rgba(75,134,192,1)",
            pointBackgroundColor: "#000",
            pointBorderWidth: 1,
            pointHoverRadius: 5,
            pointHoverBackgroundColor: "rgba(75,134,192,1)",
            pointHoverBorderColor: "rgba(75,134,192,1)",
            pointHoverBorderWidth: 2,
            pointRadius: 0,
            pointHitRadius: 10,
            data: Object.values(gon.proy_production),
            spanGaps: false,
          },
          {
            label: "Total Proyectado",
            fill: false,
            backgroundColor: "rgba(139,71,137,0.4)",
            borderColor: "rgba(139,71,137,1)",
            borderCapStyle: 'butt',
            borderDashOffset: 0.0,
            borderJoinStyle: 'miter',
            pointBorderColor: "rgba(139,71,137,1)",
            pointBackgroundColor: "#000",
            pointBorderWidth: 1,
            pointHoverRadius: 5,
            pointHoverBackgroundColor: "rgba(139,71,137,1)",
            pointHoverBorderColor: "rgba(139,71,137,1)",
            pointHoverBorderWidth: 2,
            pointRadius: 0,
            pointHitRadius: 10,
            data: Object.values(gon.cuttings_and_prod),
            spanGaps: false,
          }
        ]
      },//end data
      options: {
              scales: {
                xAxes: [{
            gridLines: {
              display: false,
              color: "black"
            },
            scaleLabel: {
              display: true,
              labelString: "Semana - año",
              fontColor: "red"
            }
          }],
          yAxes: [{
            ticks: {
              beginAtZero:true
            },
            scaleLabel: {
              display: true,
              labelString: "Cantidad producida",
              fontColor: "green"
            }
          }]
        },
        title: {
          display: true,
          text: "Siembra",
          fontSize: 18
        }
      }, //end options
    });
  } // End if - chartjs-linechart-production

})(window, document, window.jQuery);
