function sendCommand(command) {
    var jqxhr = $.ajax("/answer?keys=" + command)
        .done(function (msg) {
            console.log(msg);
            $('#answer').text(msg);
        })
        .fail(function () {
            console.log("error");
        })
        .always(function (msg) {
            console.log("complete " + msg);
        });
}

$(document).ready(function () {
    $(window).keydown(function (e) {
        $('#text').text(e.keyCode);
        console.log(e);
        sendCommand(e.keyCode);
    });
    $(window).keyup(function (e) {
        $('#text').text(e.keyCode);
        console.log(e);
        sendCommand("32");
    });
});
