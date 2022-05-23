%% -*- mode: nitrogen -*-
-module(index).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

main() -> #template{file = "./site/templates/bare.html"}.

title() -> "Welcome to Nitrogen".

body() ->
    #container_12{
        body = [
            #grid_8{alpha = true, prefix = 2, suffix = 2, omega = true, body = inner_body()}
        ]
    }.

inner_body() ->
    [
        #h1{class = header, text = "Welcome to Nitrogen"},
        #h1{style = "color:red;", text = "Welcome to Nitrogen"},
        #p{},
        "\n"
        "        If you can see this page, then your Nitrogen server is up and\n"
        "        running. Click the button below to test postbacks probando.\n"
        "        ",
        #p{},
        #button{id = button, text = "Click me!", postback = click},
        #p{},
        "\n"
        "        Run <b>./bin/dev help</b> to see some useful developer commands.\n"
        "        ",
        #p{},
        "\n"
        "		<b>Want to see the ",
        #link{text = "Sample Nitrogen jQuery Mobile Page", url = "/mobile"},
        "?</b>\n"
        "		"
    ].

event(click) ->
    wf:replace(button, #panel{
        body = "You clicked the button!",
        actions = #effect{effect = highlight}
    }).
