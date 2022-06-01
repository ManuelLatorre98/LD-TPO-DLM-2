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
    wf:wire(submit, username, #validate { validators=[
            #is_required { text="Required." }
        ]}),
        wf:wire(submit, password, #validate { validators=[
            #is_required { text="Required." },
            #custom { 
                text="Invalid password.", 
                function=fun(_, Value) -> Value == "password" end
            }
        ]}),
    #panel {class=form,body=[
        #flash {},
        #label{class='formTitle', text="Iniciar sesión"},
        #textbox{id='username',class='field', size=10, placeholder="Nombre de usuario"},
        #password{id='password',class=field, size=10, placeholder="Contraseña"},
        #button{id='submit',class='formButton', text="Iniciar sesion", postback=login}
    ]}.

 event(login) ->
        wf:role(manager, true),
        wf:redirect_from_login("/").