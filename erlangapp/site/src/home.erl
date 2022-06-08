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
    UsuariosConectados= messenger:get_user_list(),
    #panel {class='usuariosConectados' ,body=[
         #label{class='userName', text="Usuarios Conectados:"},  
         #list{
            class='listaUsuarios',  
            body=[#listitem{body=Usuario}|| Usuario <- UsuariosConectados]}
    ]}.

mid() -> 
    CurrentUser =  wf:user() ,
    ListaChat= messenger:get_historial_chat(),
    #panel {class='mensaje',body=[
        #label{class='userName', text=CurrentUser},
        #panel{class='chatPanel',body=[
            #list{
            class='chat',  
            body=[#listitem{body=[[Nombre],": ",[Mensaje]]}|| {Nombre,Mensaje} <- ListaChat]}
        ]},
        #panel{class='sendMensaje',body=[
            #textbox { id=messageTextBox, class='cajaTexto', next=sendButton },
            #button { id=sendButton, text="Enviar", postback=chat }
        ]}
    ]}.

event(chat) ->
        Mensaje = wf:q(messageTextBox),
        %?PRINT("HOLA"). %messenger:server(user_list),
        messenger:message_all(Mensaje).

