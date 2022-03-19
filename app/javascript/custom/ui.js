document.addEventListener('DOMContentLoaded', async () => {
    $(document).on('turbolinks:load', () => {
        console.log('UI Functions')

        $('.nav-hider').on('click', () => {
            hide_nav()
        })

        $('.nav-shower').on('click', () => {
            show_nav()
        })

        function show_nav() {
            $('.main-nav').css({ "-webkit-transform": "translate(0px,0px)" });
            $('.nav-hider').show(300)
        }

        function hide_nav() {
            $('.main-nav').css({ "-webkit-transform": "translate(-550px,0px)" });
            $('.nav-hider').hide(300)
        }
    })
})