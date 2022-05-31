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
        #label{class='formTitle colorTitulo', text="Iniciar sesión"},
        #textbox{class='field', size=10, placeholder="Nombre de usuario"},
        #password{id=password,class=field, size=10, placeholder="Contraseña"},
<<<<<<< HEAD
        #button{class=formButton, text="Iniciar sesion", postback=login}
=======
        #button{class='formButton', text="Iniciar sesionn", postback=login}
>>>>>>> 5a7e5788ce98fda7c5f513213df8198978c604cd
    ]}.

 event(login) ->
        case wf:q(password) == "password" of
            true ->
                wf:role(manager, true),
                wf:redirect_from_login("/");
            false ->
                wf:flash("Invalid password.")
        end.