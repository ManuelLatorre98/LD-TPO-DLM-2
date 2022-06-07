%% -*- mode: nitrogen -*-
-module (login).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").
%-import(messenger,[logon/1]).

main() -> #template { file="./site/templates/bare.html" }.
        

title() -> "Login".

body() ->
    #container_12 {class=bodyContainer, body=[
        join() %Podemos insertar los componentes asi nomas
    ]}.


join() -> 
    #panel {class=form,body=[
        #label{class='formTitle colorTitulo', text="Iniciar sesión"},
        #textbox{id=nombreUsuario ,class='field', size=10, placeholder="Nombre de usuario"},
        %#password{id=password,class=field, size=10, placeholder="Contraseña"},
        #button{class='formButton', text="Iniciar sesion", postback=login}
    ]}.

 event(login) ->
        User = wf:q(nombreUsuario),
        messenger:logon(list_to_atom(User)),
        %?PRINT(messenger:server(user_list)), %messenger:server(user_list),
        wf:user(User),
        wf:redirect_from_login("/home").

%K2DNKVSOZt6iT1W3Vpbhjlt6emd9sK9g6OIedMhMKotcDEbZ71SlhQSi7J3SuXz