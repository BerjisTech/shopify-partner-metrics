import Chart from 'chart.js/auto'

document.addEventListener("DOMContentLoaded", function (event) {
    document.addEventListener('turbolinks:load', () => {

        window.fetch_graph_data = (from = 0, to = 30, chart_pane_id) => {
            let chart_pane = $(`#${chart_pane_id} #chart_pane`)
            let chart_image = $(`#${chart_pane_id} #chart_image`)
            let chart_area = $(`#${chart_pane_id} #chart_area`)
            let data_path = $(`#${chart_pane_id}`).data('path')

            chart_pane.hide()
            chart_image.show()
            chart_area.hide()

            $.ajax({
                url: data_path,
                method: 'POST',
                data: {
                    'authenticity_token': $('[name="csrf-token"]')[0].content,
                    'from': from,
                    'to': to
                },
                success: (response) => {
                    chart_image.hide()
                    if (response.type == 'error' || response.type == 'info') {
                        chart_area.show()
                        chart_area.html(response.message)
                    }
                    else {
                        chart_pane.show()
                        draw_graph(response, chart_pane_id)
                    }
                },
                error: (error) => {
                    chart_area.hide()
                    chart_image.hide()
                    console.log(error.responseText)
                    console.error(error.responseText)
                    chart_area.html('<div style="width: 100%; height: 100%;" class="m-3 p-3 d-flex align-items-center justify-content-center">There has been an error fetching your transactions</div>')
                }
            })
        }

        window.colors = ["#ea795d", "#de7412", "#8bf9f3", "#729782", "#6a65d2", "#57755b", "#49fdc4", "#422bda", "#3b5837", "#2e50cc", "#2e50cc", "#26351c", "#1b5ca1", "#162bb1", "#0b0e06", "#0a5b76", "#050c8f"]

        window.draw_graph = (data_set, chart_pane_id) => {
            if (data_set.values.length == 0 && data_set.sets.length == 0)
                return


            if (dataChart !== undefined)
                dataChart.destroy()

            $(`#${chart_pane_id} #chart_pane`).remove()
            $(`#${chart_pane_id}`).append(`<canvas id="chart_pane" width="100%" height="230px" style="max-height: 500px !important;"></canvas>`)

            let chart_pane = $(`#${chart_pane_id} #chart_pane`)

            if (chart_pane === undefined || chart_pane === null) return

            let ctx = chart_pane[0].getContext('2d')

            chart_pane.empty()
            let compiled_data = []
            let stacked = false

            if (data_set.blocks > 0) {
                for (let count = 0; count < data_set.sets.length; count++) {
                    compiled_data.push({
                        label: data_set.sets[count].title,
                        data: data_set.sets[count].values,
                        backgroundColor: data_set.sets[count].color,
                    })
                }
                stacked = true
            } else {
                let background = '#41BB71'
                if (data_set.chart_type == 'doughnut' || data_set.chart_type == 'pie')
                    background = colors

                compiled_data.push({
                    label: data_set.title,
                    data: data_set.values,
                    backgroundColor: background,
                })
            }

            let options = null
            if (data_set.chart_type !== 'doughnut') {
                options = {
                    plugins: {
                        title: {
                            display: true,
                            text: data_set.title
                        },
                    },
                    responsive: true,
                    scales: {
                        x: {
                            stacked: stacked,
                        },
                        y: {
                            stacked: stacked
                        }
                    }
                }
            } else {
                options = {
                    responsive: true,
                    plugins: {
                        legend: {
                            position: 'top',
                        },
                        title: {
                            display: true,
                            text: data_set.title
                        }
                    }
                }
            }

            console.log(compiled_data)
            console.log(options)

            var dataChart = new Chart(ctx, {
                type: data_set.chart_type,
                data: {
                    labels: data_set.keys,
                    datasets: compiled_data
                },
                options: options
            });
        }

        // let chart_pane = document.getElementById('chart_pane')

        // if (chart_pane === undefined || chart_pane === null) return

        // let ctx = chart_pane.getContext('2d')

        if ($('.fetch_data')) {
            $('.fetch_data').on('change', (e) => {
                fetch_graph_data($(e.target).val(), 0, $(e.target).data('pane'))
            })
        }
    })
})