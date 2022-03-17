// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import "bootstrap"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import toastr from "toastr/toastr";

Rails.start()
Turbolinks.start()
ActiveStorage.start()

const jQuery = $
global.toastr = require("toastr")

if (window.location.href.includes('/register')) {
    require("packs/registrations")
} else {
    require("custom")
}