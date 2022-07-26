import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        console.log("project connect");


        $(document).on('turbo:load', function () {
            $("#project_client_name").autocomplete({
                source: "/clients/search.json",
                minLength: 3,
                response: function (event, ui) {
                    console.log(ui.content);
                    if (ui.content.length == 0) {
                        $("#project_client_name").val("");
                    }
                },
                select: function (event, ui) {
                    ui.item.label = ui.item.full_name;
                    $("#project_client_id").val(ui.item.user_id);
                }
            });
        });

    }


    setStatus(event) {
        let status = $("#project_status").val();
        console.log(`setStatus called ${status}`);
        let form = $("#project_status_form");
        // Set the action of the form to the current url, so we can request the same data with new currency
        let actionUrl = window.location.href.split("?")[0];
        console.log(actionUrl);
        form.attr('action', actionUrl);

        let query = window.location.search.substring(1);
        console.log(`query = ${query}`)
        let vars = query.split('&');
        console.log(`vars = ${vars}`);

        // We need to make sure all params in the URL are sent back
        // So add them to the form
        vars.forEach(keyVal => {
            let keyValArr = keyVal.split('=');
            if (keyValArr[0] != "status") {
                form.append(`<input type='text' hidden="hidden" name='${keyValArr[0]}' value='${keyValArr[1]}' />`);
            }
        });

        // Make the call
        let submit = form.find("input[type='submit']");
        submit.click();

    }

    setDisplayType(event) {
        console.log("setDisplayType called");
        event.preventDefault();
        
        let form = $("#display_type_form");
        
        let query = decodeURIComponent(window.location.search.substring(1));
        console.log(`query = ${query}`)
        let vars = query.split('&');
        console.log(`vars = ${vars}`);

        // We need to make sure all params in the URL are sent back
        // So add them to the form
        vars.forEach(keyVal => {
            let keyValArr = keyVal.split('=');
            if (keyValArr[1] && keyValArr[0] != "display") {
                let value = keyValArr[1].replace("+", " ");
                form.append(`<input type='text' hidden="hidden" name='${keyValArr[0]}' value='${value}' />`);
            }
        });
        
        form.append(`<input type='text' hidden="hidden" name='display' value='${event.target.dataset.display}' />`);

        // Make the call
        let submit = form.find("input[type='submit']");
        submit.click();

    }

}


