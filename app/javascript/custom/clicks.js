// ES6


window.initial_shopify_import = (app_id) => {
    console.log(`app_id : ${app_id}`)
}

window.create_app_from_test = (r) => {
    console.log(r)
    $.ajax({
        url: r.path,
        method: 'POST',
        data: r,
        success: (r) => {
            toastr.info(`${r.app['app_name']} data has been queued for import`)
        },
        error: (e) => { toastr.error('Something went wrong') }
    })
}

window.update_billing = (path, apps) => {
    $.ajax({
        url: path,
        method: 'POST',
        data: {
            'authenticity_token': $('[name="csrf-token"]')[0].content,
            apps: apps
        },
        success: (response) => { },
        error: (response) => { }
    })
}

document.addEventListener('DOMContentLoaded', async () => {
    $(document).on('turbolinks:load', () => {
        let billing_batch_action_apps = []
        let downgrade_path = `${base_url}billing/downgrade`
        let upgrade_path = `${base_url}billing/upgrade`
        let pay_all_path = `${base_url}billing/pay_all`

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
                            toastr.info(`${r.app['app_name']} data has been queued for import`)
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
                    toastr.error('Something went wrong. Kindly check that the endpoint is online')
                }
            })
        })

        $('.shopify_csv_import_data').on('submit', (e) => {
            e.preventDefault()
            $('.shopify_csv_import_data [type="file"]').hide()
            $('.shopify_csv_import_data progress').show()

            let file = $('.shopify_csv_import_data [type="file"]').val()
            let path = $('.shopify_csv_import_data').attr('action')

            console.log(`${path} <-> ${file}`)

            $.ajax({
                url: path,
                data: new FormData($('.shopify_csv_import_data')[0]),
                method: 'POST',
                cache: false,
                contentType: false,
                processData: false,
                success: (response) => {
                    toastr.info('Data fully imported. You can now go back to you apps page')
                    $('.shopify_csv_import_data').hide()
                    console.log(response)
                    if (response.status === null)
                        window.location.href = `${base_url}apps`
                },
                error: (e) => {
                    $('.shopify_csv_import_data progress').hide()
                    $('.shopify_csv_import_data [type="file"]').show()
                    toastr.error('Something went wrong')
                    console.log(e)
                    console.log(e.responseText)
                }
            })
        })

        $('.billing_batch_actions a').on('click', (e) => {
            e.preventDefault()
            e.stopPropagation()

            let action = $(e)[0].currentTarget.dataset.action

            console.log(billing_batch_action_apps)

            if (billing_batch_action_apps.length == 0) { return toastr.error('No apps selected') }
            if (action == 'downgrade') { return update_billing(downgrade_path, billing_batch_action_apps) };
            if (action == 'upgrade') { return update_billing(upgrade_path, billing_batch_action_apps) };
            if (action == 'pay_all') { return update_billing(pay_all_path, billing_batch_action_apps) };

        })

        $('.billing_page_select').on('change', (e) => {
            let app_id = $(e)[0].currentTarget.name
            if ($(e)[0].currentTarget.checked === true) { return billing_batch_action_apps.push(app_id) }
            if ($(e)[0].currentTarget.checked === false) { return billing_batch_action_apps.splice(billing_batch_action_apps.indexOf(app_id, 1)) }
        })
    })
})