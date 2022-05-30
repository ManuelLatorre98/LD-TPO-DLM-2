%% -*- mode: nitrogen -*-
-module (login).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

main() -> #template { file="./site/templates/bare.html" }.
        

title() -> "Login".

body() ->
    #container_12 {class=bodyContainer, body=[
        join() %Podemos insertar los componentes asi nomas
    ]}.


join() -> 
    #panel {class=form,body=[
        #flash {},
        #label{class=formTitle, text="Iniciar sesión"},
        #textbox{class=field, size=10, placeholder="Nombre de usuario"},
        #password{id=password,class=field, size=10, placeholder="Contraseña"},
        #button{class=formButton, text="Iniciar sesionn", postback=login}
    ]}.

 event(login) ->
        case wf:q(password) == "password" of
            true ->
                wf:role(manager, true),
                wf:redirect_from_login("/");
            false ->
                wf:flash("Invalid password.")
        end.