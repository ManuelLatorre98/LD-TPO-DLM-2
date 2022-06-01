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

title() -> "Unconnec".

body() ->
    #panel {class=bodyContainer, body=[
        %#grid_8 { alpha=true, prefix=2, suffix=2, omega=true, body=inner_body() },
        head()
        %inner_body() %Podemos insertar los componentes asi nomas
    ]}.	

head() -> 
    #panel {class=header,body=[
        #button{class='logoutButton', text="Log Out", postback=logout}
    ]}.

event(logout) ->
    wf:logout(),
    wf:redirect_to_login("/login").