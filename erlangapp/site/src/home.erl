-module (home).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

main() -> #template { file="./site/templates/bare.html"}.

title() -> "Home".

body(nombreUsuario) -> 
    #panel { class='form',body=[
        #label{class='userName', text=nombreUsuario}
        
    ]}.



