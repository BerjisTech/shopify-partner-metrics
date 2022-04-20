"use strict";
document.addEventListener('DOMContentLoaded', async () => {
    $(document).on('turbolinks:load', () => {

        /*------------------------
        1 Page Loader
        --------------------------*/
        jQuery("#load").fadeOut()
        jQuery("#loading").delay(0).fadeOut("slow")

        /*------------------------
        2 Back To Top
        --------------------------*/
        $('#back-to-top').fadeOut();
        $(window).on("scroll", function () {
            if ($(this).scrollTop() > 250) {
                $('#back-to-top').fadeIn(1400)
            } else {
                $('#back-to-top').fadeOut(400)
            }
        });
        // scroll body to 0px on click
        $('#top').on('click', function () {
            // $('top').tooltip('hide');
            $('body,html').animate({
                scrollTop: 0
            }, 800);
            return false;
        })

        /*------------------------
        4 Accordion
        --------------------------*/
        $('.iq-accordion .iq-accordion-block .accordion-details').hide()
        $('.iq-accordion .iq-accordion-block:first').addClass('accordion-active').children().slideDown('slow')
        $('.iq-accordion .iq-accordion-block').on("click", function () {
            if ($(this).children('div').is(':hidden')) {
                $('.iq-accordion .iq-accordion-block').removeClass('accordion-active').children('div').slideUp('slow')
                $(this).toggleClass('accordion-active').children('div').slideDown('slow')
            }
        })


        /*------------------------
        5 Header
        --------------------------*/
        $('.navbar-nav li a').on('click', function (e) {
            var anchor = $(this)
            $('html, body').stop().animate({
                scrollTop: $(anchor.attr('href')).offset().top - 0
            }, 1500)
            e.preventDefault()
        })
        $(window).on('scroll', function () {
            if ($(this).scrollTop() > 100) {
                $('header').addClass('menu-sticky')
            } else {
                $('header').removeClass('menu-sticky')
            }
        })
    })
})