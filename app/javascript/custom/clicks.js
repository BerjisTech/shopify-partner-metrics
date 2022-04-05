const { formatSchema } = require("webpack/lib/WebpackOptionsValidationError")

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
                            console.log(r)
                            $.ajax({
                                url: r.path,
                                method: 'POST',
                                data: r,
                                success: (r) => { },
                                error: (e) => { toastr.error('Something went wrong') }
                            })
                        })
                    } else {
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
    })
})