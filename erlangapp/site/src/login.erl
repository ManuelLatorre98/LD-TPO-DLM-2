%% -*- mode: nitrogen -*-
-module (login).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").


main() -> #template { file="./site/templates/bare.html" }.
        

title() -> "Unconnect log in".

body() ->
    #panel {class=bodyContainer, body=[
        join() %Podemos insertar los componentes asi nomas
    ]}.


join() -> 
    wf:wire(submit, nombreUsuario, #validate { validators=[
            #is_required { text="Required." }
        ]}),
        % wf:wire(submit, password, #validate { validators=[
        %     #is_required { text="Required." },
        %     #custom { 
        %         text="Invalid password.", 
        %         function=fun(_, Value) -> Value == "password" end
        %     }
        % ]}),
    #panel {class=form,body=[
        #flash {},
        #label{class='formTitle colorTitulo', text="Iniciar sesión"},
        #textbox{id=nombreUsuario ,class='field', size=10, placeholder="Nombre de usuario"},
        %#password{id=password,class=field, size=10, placeholder="Contraseña"},
        #button{class='formButton', text="Iniciar sesion", postback=login}
    ]}.

 event(login) ->
        User = list_to_atom(wf:q(nombreUsuario)),
        wf:user(User),
        ?PRINT(User),
        messenger:logon(User),
        wf:redirect_from_login("/home").

