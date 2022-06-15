%% -*- mode: nitrogen -*-
-module (login).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").
%-import(messenger,[logon/1]).

main() -> #template { file="./site/templates/bare.html" }.
        

title() -> "Unconnect log in".

body() ->
    #panel {class=loginContainer, body=[
        join(), %Podemos insertar los componentes asi nomas
        #p{class='names', text="Santiago Villarroel, Santino Castagno, Carlos Campos , Manuel Latorre - Lenguajes Declarativos 2022"}
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
        
        #label{class='formTitle', text="Iniciar sesión"},
        
        #textbox{id=nombreUsuario ,class='textLogon', size=10, placeholder="Nombre de usuario"},
        %#password{id=password,class=field, size=10, placeholder="Contraseña"},
        #button{class='button_logon', text="Iniciar Sesión", postback=login}
    ]}.

 event(login) ->
        User = wf:q(nombreUsuario),
        messenger:logon(list_to_atom(User)),
        %?PRINT(messenger:server(user_list)), %messenger:server(user_list),
        wf:user(User),
        ?PRINT(User),
        messenger:logon(User),
        wf:send_global(chatpool,{reload}),
        wf:redirect_from_login("/home").

%K2DNKVSOZt6iT1W3Vpbhjlt6emd9sK9g6OIedMhMKotcDEbZ71SlhQSi7J3SuXz