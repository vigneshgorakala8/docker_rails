// Trend Graph JavaScript
$(function () {

  /**
   * Create the chart when all data is loaded
   * @returns {undefined}
   */

  Highcharts.setOptions({
    lang: {
      rangeSelectorZoom: '',
      rangeSelectorFrom: '',
      rangeSelectorTo: '–',
    },
  });

  Highcharts.stockChart('patient_graph', {
    scrollbar: { enabled: false },
    credits: { enabled: false },
    legend: {
      enabled: true,
      title: { text: "PA Metrics" }
    },
    chart: {
      zoomType: "x",
      alignTicks: false,
      height: 500,
    },
    tooltip: {
      valueSuffix: " mmHg",
      dateTimeLabelFormats: { week:"%A, %b %e, %Y" },
    },

    navigator: {
      height: 60,
      xAxis: {
        dateTimeLabelFormats: {
          day: '%b %e',
          week: '%b %e',
        },
      },
      yAxis: {
        softMin: 0,
        softMax: 100,
        title: {
          text: "Mean Trend"
        },
      },
    },

    plotOptions: {
      areaspline: { },
      series: {
        turboThreshold: 9000,
        states: {
          hover: { enabled: false }
        },
        events: {
          click: function(event) {
            link_to(this, event);
          }
        }
      }
    },

    xAxis: {
      dateTimeLabelFormats: {
        day: '%b %e',
        week: '%b %e',
      },
    },

    yAxis: [
      { // Primary yAxis
        title: {
          text: 'PA Pressure (mmHg)',
        },
        softMin: 0,
        softMax: 100,
        opposite: false,
        labels: {
          align: "right",
          x: -2,
        },
      },
      { // Secondary yAxis
        title: {
          text: 'Heart Rate (bpm)',
        },
        softMin: 40,
        softMax: 120,
        tickInterval: 10,
        gridLineWidth: 1,
        opposite: true,
        showEmpty: false,
        labels: {
          align: "left",
          x: 2,
        }
      },
      // Tertiary yAxis (conditionally rendered)
      // { 
      //   title: {
      //     text: 'Cardiac Output (L/min)',
      //   },
      //   softMin: 0,
      //   softMax: 10,
      //   gridLineWidth: 0,
      //   opposite: true,
      //   showEmpty: false,
      //   labels: {
      //     align: "left",
      //     x: 2,
      //   },
      // }
    ],

    series: [
      {
        type: "line",
        color: "#FF0000",
        name: "PA Systolic",
        showInNavigator: true,
        data: [] // Will be populated with @metrics.systolic
      },
      {
        type: "line",
        color: "#990000",
        name: "PA Systolic Trend",
        data: [], // Will be populated with @metrics.systolic_trend
        visible: false
      },
      {
        type: "line",
        color: "#00FF00",
        name: "PA Diastolic",
        data: [] // Will be populated with @metrics.diastolic
      },
      {
        type: "line",
        color: "#009900",
        name: "PA Diastolic Trend",
        data: [], // Will be populated with @metrics.diastolic_trend
        visible: false
      },
      {
        type: "line",
        color: "#0000FF",
        name: "PA Mean",
        data: [] // Will be populated with @metrics.mean
      },
      {
        type: "line",
        color: "#000099",
        name: "PA Mean Trend",
        data: [], // Will be populated with @metrics.mean_trend
        visible: false
      },
      {
        type: "line",
        color: "#800080",
        name: "Heart Rate",
        data: [], // Will be populated with @metrics.heart_rate
        visible: false,
        tooltip: { valueSuffix: " bpm" },
        yAxis: 1
      },
      // Cardiac Output series (conditionally rendered)
      // {
      //   type: "line",
      //   color: "#009800", 
      //   name: "Cardiac Output",
      //   data: [], // Will be populated with @cardiac_output
      //   visible: false,
      //   tooltip: { valueSuffix: " L/min" },
      //   yAxis: 2
      // },
      {
        type: "flags",
        color: "#FF8C00",
        name: "Suspect Readings",
        data: [], // Will be populated with @trend_graph.suspect_readings_flags
        shape: "circlepin"
      }
    ]
  });
});

// Suspect Readings lines visibility
suspect_readings_lines = []; // Will be populated with @trend_graph.suspect_readings_lines
var suspects_visible = true;
$("span:contains('Suspect Readings')").on('click', function () {
  if (suspects_visible) {
    var chart = $("#patient_graph").highcharts();
    suspects_visible = false;
    for (var i = 0; i <suspect_readings_lines.length; i++) {
      chart.xAxis[0].removePlotLine(suspect_readings_lines[i]['id']);
    };

  } else {
    var chart = $("#patient_graph").highcharts();
    suspects_visible = true;
    for (var i = 0; i <suspect_readings_lines.length; i++) {
      chart.xAxis[0].addPlotLine(suspect_readings_lines[i]);
    };

  };
})

// click graph functionality
function link_to (series, e) {
  if (series.name == 'Suspect Readings') {
    load_reading(e['point']['id'], e['point']['options']['x']);
  } else if (['PA Systolic', 'PA Diastolic', 'PA Mean'].includes(series.name)) {
    load_waveform(series, e['point']['id'] );
  };
}

function load_reading (reading_id, js_timestamp) {
  var formatted_date = new Date(js_timestamp).toISOString().substr(0, 10);
  window.location = '/patients/PATIENT_ID/readings?date=' + formatted_date + '&id=' + reading_id ; // URL will be dynamically generated
}

// function load_waveform (series, id) {
//   $.get('<%= patient_waveform_url(@patient) %>?trend_graph=true&reading_id=' + id, function (data) {
//     data;
//   })
// }

function load_waveform(series, id) {
  const waveformElement = document.querySelector('[data-controller="trend-waveform"]');
  
  if (!waveformElement) {
    console.error("Waveform element not found.");
    return;
  }

  // Get the Stimulus application and find the controller
  const application = window.Stimulus || window.Application;
  if (!application) {
    console.error("Stimulus application not found.");
    return;
  }

  // Get the controller instance from the element
  const waveformController = application.getControllerForElementAndIdentifier(waveformElement, "trend-waveform");

  if (!waveformController) {
    console.error("Waveform controller not found.");
    return;
  }

  const url = `/patients/${series}/waveform?trend_graph=true&reading_id=${id}`;
  waveformController.loadWaveform(url, id);
}

// Stimulus Controller Definition
const WaveformController = class extends Stimulus.Controller {
  static targets = ["panel", "waveform", "content", "waveformContent", "showButton", "hideButton"];

  connect() {
    console.log("WaveformController connected");
  }

  showWaveform(event) {
    if (event) event.preventDefault();
    this.panelTarget.classList.add("collapse", "show");
  }

  updateContent(html) {
    if (this.hasContentTarget) {
      this.contentTarget.innerHTML = html;
    }
    this.showWaveform();
  }

  loadWaveform(url, id) {
    console.log("Loading waveform", url);
    fetch(url)
      .then(response => response.text())
      .then(html => {
        if (this.hasWaveformTarget) {
          this.waveformTarget.innerHTML = html;
        }
        if (this.hasPanelTarget) {
          this.panelTarget.classList.add("show");
        }
      })
      .catch(error => console.error('Error loading waveform:', error));
  }
};

// Register the controller with Stimulus
if (typeof Stimulus !== 'undefined' && Stimulus.register) {
  Stimulus.register("trend-waveform", WaveformController);
} else if (typeof application !== 'undefined' && application.register) {
  application.register("trend-waveform", WaveformController);
}
