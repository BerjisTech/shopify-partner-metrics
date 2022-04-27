//= require active_admin/base
window.re_run = (activity) => {
    alert(`rurapanthe/rerun_import`)
    $.ajax({
        path: `rurapanthe/rerun_import`,
        method: 'GET',
        data: {
            activity: activity
        },
        success: (r) => {
            console.log(r)
        },
        error: (r) => {
            console.log(r)
        }
    })
}

document.addEventListener("DOMContentLoaded", function (event) {

})