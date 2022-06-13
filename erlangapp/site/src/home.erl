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
    
    #panel {class='leftContainer' ,body=[
        #label{class='connectedUsersTitle', text="Usuarios Conectados:"},
        #panel{class='connectedUsersContainer', body=[
            #list{
                class='listaUsuarios',  
                body=[#listitem{class= 'userCard', body=Usuario}|| Usuario <- UsuariosConectados]
            }]
        }
         
    ]}.

mid() -> 
    CurrentUser =  wf:user() , 
    ListaChat= messenger:get_historial_chat(),
    #panel {class='messagesContainer',body=[
        % #panel{class='chatHeader', body=[
        %     #label{class='namePage', text="Messenger"},
        %     #label{class='userName', text=CurrentUser}
        % ]},
        #panel{class='chatPanel',body=[
            #list{
            class='chat',  
            body=[#listitem{class='messageList', body=[
                #panel{class='messageCardContainer', body=[
                    #p{class='messageCard_UserInfo', text= [Nombre,":"]},
                    #p{class='messageCard_message', text=[Mensaje]}
                ]}
                %[Nombre],": ",[Mensaje]
                ]
            
            
            }|| {Nombre,Mensaje} <- ListaChat]}
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

