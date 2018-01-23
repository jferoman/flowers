(function(window, document, $, undefined){

  if(document.getElementById("chartjs-linechart-sowing")) {

    var ctx = document.getElementById("chartjs-linechart-sowing");
    var myLineChart = new Chart(ctx, {
      type: 'line',
      data: {
        labels: Object.keys(gon.sowing),
        datasets: [
          {
            label: "Flores sembradas",
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
          }
        ]
      },//end data
      options: {
        scales: {
          yAxes: [{
            ticks: {
              beginAtZero:true
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
  } // End if

})(window, document, window.jQuery);
