-module (home).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

main() -> #template { file="./site/templates/bare.html"}.

title() -> "Home".

body() -> 

    #container_12 {class=bodyContainer, body=[
        left(),
        mid()
    ]}.
    

left() ->
    #panel {class='usuariosConectados' ,body=[
         #label{class='userName', text="Usuarios Conectados:"}   

    ]}.

mid() -> 
    CurrentUser =  wf:user() ,
    #panel {class='mensaje',body=[
        
     
        #label{class='userName', text=CurrentUser},
        #textbox { id=messageTextBox, class='cajaTexto', next=sendButton },
        #button { id=sendButton, text="Enviar", postback={chat} }

        
    ]}.


