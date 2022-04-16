const { formatSchema } = require("webpack/lib/WebpackOptionsValidationError")

window.initial_shopify_import = (app_id) => {
    console.log(`app_id : ${app_id}`)
}

window.create_app_from_test = (r) => {
    console.log(r)
    $.ajax({
        url: r.path,
        method: 'POST',
        data: r,
        success: (r) => { },
        error: (e) => { toastr.error('Something went wrong') }
    })
}

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
                    console.log(response)
                    $(`.active_${$(e.target).attr('data-target')}_loader`).hide()
                    $(`<div class="my-2 py-2 active_${$(e.target).attr('data-target')}_block" style="font-size: 12px !important;"></div>`).insertBefore(e.target)

                    response.data.forEach((line) => {
                        $(`.active_${$(e.target).attr('data-target')}_block`).append(`<div class="d-flex align-items-center justify-content-start py-2">${line}</div>`)
                    })

                    if (response.status === true) {
                        $('[data-target="test_running_data"]').remove()
                        $('[data-target="import_running_data"]').show()
                    }
                },
                error: (error) => {
                    $(`.active_${$(e.target).attr('data-target')}_loader`).hide()
                    console.log(error)
                    toastr.error('Something went wrong')
                }
            })
        })

        $('.shopify_test_button').on('click', (e) => {
            $('.shopify_test_button .spinner-border').show()
            $('.initial_import').remove()

            $.ajax({
                url: $('.shopify_test_button').data('path'),
                method: 'GET',
                success: (response) => {
                    console.log(response)

                    if (typeof response != 'object') {
                        toastr.error('Something went wrong, Kindly contact support')
                        $('.shopify_test_button .spinner-border').hide()
                        return
                    }

                    if (response.status == false) {
                        toastr.error("We couldn't find the API Key, App Code or Partner ID")
                        $('.shopify_test_button .spinner-border').hide()
                        $(`<a href="${response.current_api_path}" class="shopify-button override-danger btn btn-lg shopify_test_button d-flex align-items-center justify-content-center" target="_BLANK">edit API details</a>`).insertAfter($('.shopify_test_button'))
                        return
                    }

                    $('.shopify_test_results').empty()

                    if (response.data.length > 0) {
                        response.data.forEach((r) => {
                            $('.shopify_test_results').append(
                                `
                                <tr>
                                    <td>${r.app['app_name']}</td>
                                    <td>
                                        <a href="#" class="create_this" data_form='${JSON.stringify(r)}'>Create this app</a> or 
                                        <a href="${response.current_app_path}" class="edit_current" target="_BLANK">edit current app</edit>
                                    </td>
                                </tr>
                            `
                            )
                        })

                        $('.create_this').on('click', (e) => {
                            e.preventDefault()
                            e.stopPropagation()
                            let r = JSON.parse($(e.target).attr('data_form'))
                            create_app_from_test(r)
                        })
                    }
                    else {
                        $('.shopify_test_button').remove()
                    }
                    if (response.ok.length > 0) {
                        $('.api_test_results .alert').hide()
                        response.ok.forEach((r) => {
                            $('.shopify_test_results').append(
                                `
                                <tr>
                                    <td>${r.app['app_name']}</td>
                                    <td>
                                        Ok
                                    </td>
                                </tr>
                            `
                            )

                            $('.test_api_connection_block').append(`
                                <span class="pointer d-flex my-3 border-bottom align-items-center justify-content-between" onclick="initial_shopify_import('${r.app_id}')">
                                    Import Data For ${r.app['app_name']}
                                    <div class="spinner-border" style="display: none; width: 20px; height: 20px;" role="status">
                                        <span class="sr-only"></span>
                                    </div>
                                </span>
                            `)
                        })
                    }

                    $('.shopify_test_button .spinner-border').hide()

                    $('.api_test_results').show()
                },
                error: (error) => {
                    toastr.error('Something went wrong. Kindly contact support')
                    $('.shopify_test_button .spinner-border').hide()
                }
            })
        })

        $('[data-target="import_running_data"]').on('click', (e) => {
            let path = $(e.target).attr('data-path')
            console.log(path)
            $.ajax({
                url: path,
                method: 'POST',
                data: {
                    authenticity_token: $(e.target).attr('form_authenticity_token')
                },
                success: (r) => {
                    toastr.info('Hooray! Your first data has been imported')
                    setTimeout(() => { window.location.reload() }, 500)
                },
                error: (e) => { 
                    console.log(e)
                    console.error(e)
                    toastr.error('Something went wrong. Kindly check that the endpoint is online') }
            })
        })
    })
})