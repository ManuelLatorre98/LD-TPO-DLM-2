-module (home).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

main() -> #template { file="./site/templates/bare.html"}.

title() -> "Home".

body() -> 

    #container_12 {class=bodyContainer, body=[
        
        join()
    ]}.
    
join() -> 
    CurrentUser =  wf:user() ,
    #panel {class=form,body=[
        
     
        #label{class='userName', text=CurrentUser},
        #label{text="HOLA"}
        
    ]}.


