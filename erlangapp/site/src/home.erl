-module (home).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

main() -> #template { file="./site/templates/bare.html"}.

title() -> "Home".

body() -> 

    #container_12 {class=bodyContainer, body=[
        left(),
        mid(),
        #p{class='names', text="Santiago Villarroel, Santino Castagno, Carlos Campos , Manuel Latorre - Lenguajes Declarativos 2022"}
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
    wf:comet_global(fun()->refresh() end,chatpool),
    CurrentUser =  wf:user() , 
    ListaChat= messenger:get_historial_chat(),
    #panel {class='messagesContainer',body=[
         #panel{class='chatHeader', body=[
            #label{class='userName', text=CurrentUser},
            #button{class='button_logout',postback=log_off , text="Cerrar Sesión"}
         ]},
        #panel{class='chatPanel',body=[
            #list{class='chat',body=[
                #listitem{class='messageItem', body=[
                    #panel{class='messageCardContainer', body=[
                        #p{class='messageCard_UserInfo', text= [Nombre,":"]},
                        #p{class='messageCard_message', text=[Mensaje]}
                    ]}
                %[Nombre],": ",[Mensaje]
                ]
            
            
            }|| {Nombre,Mensaje} <- ListaChat]}
        ]},
        #panel{class='sendMensaje',body=[
            #textbox { id=messageTextBox, class='textBox', next=sendButton },
            #button { id=sendButton, class='buttonSend',text="Enviar", postback=chat }
        ]}
    ]}.

event(chat) ->
        Mensaje = wf:q(messageTextBox),
        %?PRINT("HOLA"). %messenger:server(user_list),
        messenger:message_all(Mensaje),
        wf:send_global(chatpool,{reload});
event(log_off) ->
        wf:logout(),
        messenger:logoff(),
        wf:redirect("/login").
refresh()->
    receive
        {reload} -> wf:redirect("/home")
    end,
    wf:flush(),
    refresh().
