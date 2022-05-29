%% -*- mode: nitrogen -*-
-module (login).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

main() -> #template { file="./site/templates/bare.html" }.
        

title() -> "Login".

body() ->
    #container_12 {class=bodyContainer, body=[
        %#grid_8 { alpha=true, prefix=2, suffix=2, omega=true, body=inner_body() },
        join() %Podemos insertar los componentes asi nomas
    ]}.

%body() -> 
%    #panel { style="margin: 50px;", body=[
%        #flash {},
%        #label { text="Username" },
%        #textbox { id=username, next=password },
%        #br {},
%        #label { text="Password" },
%        #password { id=password, next=submit },
%        #br {},
%        #button { text="Login", id=submit, postback=login }
 %   ]}.
join() -> 
    #panel {class=form,body=[
        #flash {},
        #label{class=formTitle, text="Iniciar sesión"},
        #textbox{class=field, size=10, placeholder="Nombre de usuario"},
        #password{class=field, size=10, placeholder="Contraseña"},
        #button{class=formButton, text="Iniciar sesion", postback=login}
    ]}.

 event(login) ->
        case wf:q(password) == "password" of
            true ->
                wf:role(managers, true),
                wf:redirect_from_login("/");
            false ->
                wf:flash("Invalid password.")
        end.