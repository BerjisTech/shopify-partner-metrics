"use strict"

document.addEventListener("DOMContentLoaded", function (event) {
    console.log('Registration')
    const mail_format = /(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])/

    let user_good = $('.user-good')
    let submit_button = $('[type="submit"]')
    let email_set = $('.email-set')
    let ps_set = $('.ps-set')
    let ps_confirm = $('.ps-confirm')

    user_good.remove()
    submit_button.remove()
    email_set.remove()
    ps_set.remove()
    ps_confirm.remove()

    function is_email_valid(response) {
        $('.validity').html(response.valid)
        $('.next_button').html('<span class="btn btn-lg btn-info form-control text-white go_to_email">Next</span>')
        $('.go_to_email').on('click', () => {
            email_set.insertBefore('.next_button')
            $('[name="user[email]"]').on('input', (e) => {
                let email = $(e.target).val()
                if (email.match(mail_format)) {
                    ps_set.insertBefore('.next_button')
                    ps_confirm.insertBefore('.next_button')
                }
                else {
                    ps_set.remove()
                    ps_confirm.remove()
                }
            })
        })
    }

    $('[name="user[username]"]').on('input', (e) => {
        let user_name = $(e.target).val()
        if (user_name == '') {
            $('[name="user[email]"]').html('')
            email_set.remove()
            ps_set.remove()
            ps_confirm.remove()
            $('.user-good').hide()
            $('.alerts').html(`<span class="alert alert-danger user_alert">You need a username to proceed <span class="material-icons point_me" onclick="document.querySelector('.alerts').html('')">cancel</span></psan>`)
            return;
        }
        $.ajax({
            url: `${base_url}verify_email`,
            data: $('.new_user').serialize(),
            method: 'POST',
            success: (response) => {
                console.log(response)
                if (response.validity === null) {
                    is_email_valid(response)
                } else {
                    $('[name="user[email]"]').html('')
                    email_set.remove()
                    ps_set.remove()
                    ps_confirm.remove()
                    $('.validity').html(response.not_valid)
                    $('.next_button').html('')
                }
            },
            error: (e) => {
                console.log(e.responseText)
            }
        })
    })
})