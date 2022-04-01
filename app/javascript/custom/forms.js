// ES6

document.addEventListener('DOMContentLoaded', async () => {
    $(document).on('turbolinks:load', () => {
        $('[action*="/apps"] .shopify_extras').hide()
        $('[action*="/apps"] [name="app[platform_id]"]').on('change', (e) => {
            let selected = $(e.target).val()
            let platform = $(`[value="${selected}"]`).html()
            if (platform == 'Shopify') {
                $('[action*="/apps"] .shopify_extras').show()
            } else {
                $('[action*="/apps"] .shopify_extras').hide()
            }
        })
    })
})