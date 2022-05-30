%% -*- mode: nitrogen -*-
-module (index).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

main() ->
        case wf:role(manager) of
            true ->
                #template { file="./site/templates/bare.html" };
            false ->
                wf:redirect_to_login("/login")
        end.

title() -> "Welcome to Nitrogen".

body() ->
    #container_12 {class=bodyContainer, body=[
        %#grid_8 { alpha=true, prefix=2, suffix=2, omega=true, body=inner_body() },
        inner_body() %Podemos insertar los componentes asi nomas
    ]}.

inner_body() -> 
    [
        #h1 { text="Welcome to Nitrogen" },
        #p{},
        "
        If you can see this page, then your Nitrogen server is up and
        running. Click the button below to test postbacks.
        ",
        #p{}, 	
        #button { id=button, text="Click me!", postback=click },
		#p{},
        "
        Run <b>./bin/dev help</b> to see some useful developer commands.
        ",
		#p{},
		"
		<b>Want to see the ",#link{text="Sample Nitrogen jQuery Mobile Page",url="/mobile"},"?</b>
		"
    ].
	
event(click) ->
    wf:replace(button, #panel { 
        body="You clicked the button!", 
        actions=#effect { effect=highlight }
    }).


test() -> 
    #panel {class=form,body=[
        #label{class=formTitle, text="Iniciar sesión"},
        #textbox{class=field, size=10, placeholder="Nombre de usuario"},
        #password{class=field, size=10, placeholder="Contraseña"},
        #button{id=loginButton,class=formButton, text="Iniciar sesion", postback=login}
    ]}.