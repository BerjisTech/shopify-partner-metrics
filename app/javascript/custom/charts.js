import Chart from 'chart.js/auto'

document.addEventListener("DOMContentLoaded", function (event) {
    document.addEventListener('turbolinks:load', () => {
        let chart_pane = document.getElementById('chart_pane')

        if (chart_pane === undefined || chart_pane === null) return

        let ctx = chart_pane.getContext('2d')

        if (window.location.href == `${base_url}dashboard`) {
            var myChart = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: JSON.parse(ctx.canvas.dataset.labels),
                    datasets: [{
                        data: JSON.parse(ctx.canvas.dataset.data),
                    }]
                },
            })
        }
    })
})