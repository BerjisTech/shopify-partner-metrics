window.pull_for_table = (path, app_id, platform_id, from, to, target_div) => {
    $(`#${target_div}`).html(`<div class="d-flex align-items-center justify-content-center"><img src="${base_url}assets/loader.gif" style="width: 150px; height: auto;" /></div>`)
    $.ajax({
        url: path,
        data: {
            'authenticity_token': $('[name="csrf-token"]')[0].content,
            'from': from,
            'to': to,
            'app_id': app_id,
            'platform_id': platform_id
        },
        method: 'POST',
        success: (response) => {
            console.log(response)
            $(`#${target_div}`).html(response)
        },
        error: (error) => {
            $(`#${target_div}`).html(`<div class="d-flex align-items-center justify-content-center"><img src="${base_url}assets/error.jpg" style="width: 150px; height: auto;" /></div>`)
            console.error(error.responseText)
            toastr.error('Something went wrong')
        }
    })
}
document.addEventListener('DOMContentLoaded', async () => {
    $(document).on('turbolinks:load', () => {

    })
})