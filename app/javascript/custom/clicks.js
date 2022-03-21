document.addEventListener('DOMContentLoaded', async () => {
    $(document).on('turbolinks:load', () => {
        $('[data-target="test_running_data"]').on('click', (e) => {
            path = $(e.target).attr('data-path')
            $.ajax({
                url: path,
                method: 'GET',
                success: (response) => {
                    $(`<div class=></div>`)
                },
                error: (error) => {
                    console.log(error)
                    toastr.error('Something went wrong')
                }
            })
        })
    })
})