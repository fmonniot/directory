/**
 * Created by francois on 31/01/14.
 */

//Flot Line Chart
$(document).ready(function() {

    var series = [],
        element = $("#flot-line-chart"),
        options = {
            series: {
                lines: {
                    show: true
                },
                points: {
                    show: true
                }
            },
            grid: {
                hoverable: true //IMPORTANT! this is needed for tooltip to work
            },
            xaxis: {
                mode: 'time',
                timeformat: "%b %d",
                minTickSize: [1, 'day'],
                labelWidth: 50
            },
            tooltip: true,
            tooltipOpts: {
                content: function(label, xval, yval) {
                    return '<strong>'+yval + '</strong> ' + label + ' the <strong>' +
                        moment(xval).format('d MMMM YYYY') + '</strong>';
                },
                shifts: {
                    x: -60,
                    y: 25
                }
            }
        };

    $.ajax({
        url: '/admin/statistics/visitors',
        method: 'GET',
        dataType: 'json',
        success: function(response){

            var data = [];
            // Replace object by array
            for(var i = 0; i < response.entries.length; i++) {
                data.push([response.entries[i].time, response.entries[i].count])
            }
            series = [{
                data: data,
                label: "Visitors"
            }];

            $.plot(element, series, options);
        }
    });
});

//Flot Bar Chart
$(document).ready(function() {

    $.ajax({
        url: '/admin/statistics/professions',
        method: 'GET',
        dataType: 'json',
        success: function(response){

            var data = [];
            var ticks = [];
            // Replace object by array
            for(var i = 0; i < response.terms.length; i++) {
                data.push([i, response.terms[i].count])
                ticks.push([i, response.terms[i].term]);
            }

            var element = $("#flot-bar-chart"),
                dataset = [{ label: "People by profession", data: data, color: "#5482FF" }],
                options = {
                    series: {
                        bars: {
                            show: true
                        }
                    },
                    grid: {
                        hoverable: true,
                        clickable : true
                    },
                    bars: {
                        align: "center",
                        barWidth: 0.5
                    },
                    xaxis: {
                        axisLabel: "Profession",
                        axisLabelUseCanvas: true,
                        axisLabelFontSizePixels: 12,
                        axisLabelFontFamily: 'Verdana, Arial',
                        axisLabelPadding: 10,
                        ticks: ticks,
                        labelWidth: 100
                    },
                    tooltip: true,
                    tooltipOpts: {
                        content: function(label, xval, yval) {
                            return '<strong>'+yval+'</strong> people in <strong>' + ticks[xval][1] + '</strong>';
                        },
                        shifts: {
                            x: -60,
                            y: 25
                        }
                    }
                };

            $.plot(element, dataset, options);

            element.bind('plotclick', function (event, pos, item) {
                window.location.href = "admin/people?profession="+ticks[item.datapoint[0]][1];
            });
        }
    });
});