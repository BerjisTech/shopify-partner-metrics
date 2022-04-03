// ES6

document.addEventListener('DOMContentLoaded', async () => {
    $(document).on('turbolinks:load', () => {
        $('.shopify_extras').hide()
        $('.display_shopify_extras').on('input', (e) => {
            let selected = $(e.target).val()
            let platform = $(`[value="${selected}"]`).html()
            if (platform == 'Shopify') {
                $('.shopify_extras').show()
            } else {
                $('.shopify_extras').hide()
            }
        })
    })
})