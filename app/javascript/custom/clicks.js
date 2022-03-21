document.addEventListener('DOMContentLoaded', async () => {
    $(document).on('turbolinks:load', () => {
        $('[data-target="test_running_data"]').on('click', (e) => {
            $(`.active_${$(e.target).attr('data-target')}_loader`).show()

            if ($(`.active_${$(e.target).attr('data-target')}_block`)) {
                $(`.active_${$(e.target).attr('data-target')}_block`).remove()
            }

            let path = $(e.target).attr('data-path')
            $.ajax({
                url: path,
                method: 'GET',
                success: (response) => {
                    $(`.active_${$(e.target).attr('data-target')}_loader`).hide()
                    $(`<div class="my-2 py-2 active_${$(e.target).attr('data-target')}_block" style="font-size: 12px !important;"></div>`).insertBefore(e.target)

                    response.forEach((line) => {
                        $(`.active_${$(e.target).attr('data-target')}_block`).append(`<div class="d-flex align-items-center justify-content-start py-2">${line}</div>`)
                    })
                },
                error: (error) => {
                    $(`.active_${$(e.target).attr('data-target')}_loader`).hide()
                    console.log(error)
                    toastr.error('Something went wrong')
                }
            })
        })
    })
})