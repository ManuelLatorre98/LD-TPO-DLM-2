%%% Message passing utility.  
%%% User interface:
%%% logon(Name)
%%%     One user at a time can log in from each Erlang node in the
%%%     system messenger: and choose a suitable Name. If the Name
%%%     is already logged in at another node or if someone else is
%%%     already logged in at the same node, login will be rejected
%%%     with a suitable error message.
%%% logoff()
%%%     Logs off anybody at that node
%%% message(ToName, Message)
%%%     sends Message to ToName. Error messages if the user of this 
%%%     function is not logged on or if ToName is not logged on at
%%%     any node.
%%%
%%% One node in the network of Erlang nodes runs a server which maintains
%%% data about the logged on users. The server is registered as "messenger"
%%% Each node where there is a user logged on runs a client process registered
%%% as "mess_client" 
%%%
%%% Protocol between the client processes and the server
%%% ----------------------------------------------------
%%% 
%%% To server: {ClientPid, logon, UserName}
%%% Reply {messenger, stop, user_exists_at_other_node} stops the client
%%% Reply {messenger, logged_on} logon was successful
%%%
%%% To server: {ClientPid, logoff}
%%% Reply: {messenger, logged_off}
%%%
%%% To server: {ClientPid, logoff}
%%% Reply: no reply
%%%
%%% To server: {ClientPid, message_to, ToName, Message} send a message
%%% Reply: {messenger, stop, you_are_not_logged_on} stops the client
%%% Reply: {messenger, receiver_not_found} no user with this name logged on
%%% Reply: {messenger, sent} Message has been sent (but no guarantee)
%%%
%%% To client: {message_from, Name, Message},
%%%
%%% Protocol between the "commands" and the client
%%% ----------------------------------------------
%%%
%%% Started: messenger:client(Server_Node, Name)
%%% To client: logoff
%%% To client: {message_to, ToName, Message}
%%%
%%% Configuration: change the server_node() function to return the
%%% name of the node where the messenger server runs

-module(messenger).
-export([start_server/0,get_user_list/0, server/1, logon/1, logoff/0,message_all/1, client/2,get_historial_chat/0]).

%%% Change the function below to return the name of the node where the
%%% messenger server runs
server_node() ->
    %%'messenger@manuel.'
    's@10.147.17.151'.
%%% This is the server process for the "messenger"
%%% the user list has the format [{ClientPid1, Name1},{ClientPid22, Name2},...]
server(User_List) ->
    receive
        {From, logon, Name} ->
            New_User_List = server_logon(From, Name, User_List),
            server(New_User_List);
        {From, logoff} ->
            New_User_List = server_logoff(From, User_List),
            server(New_User_List);
        {From,message_to_all,Message}->
            server_transfer_all(From, Message, User_List),
            server(User_List);
        {From,user_list} ->
            From ! {messenger,data, User_List},
            server(User_List)
    end.

%%% Start the server
start_server() ->
    register(messenger, spawn(messenger, server, [[]])).

%%% Server adds a new user to the user list
server_logon(From, Name, User_List) ->
    %% check if logged on anywhere else
    case lists:keymember(Name, 2, User_List) of
        true ->
            From ! {messenger, stop, user_exists_at_other_node},  %reject logon
            User_List;
        false ->
            From ! {messenger, logged_on},
            [{From, Name} | User_List]        %add user to the list
    end.

%%% Server deletes a user from the user list
server_logoff(From, User_List) ->
    lists:keydelete(From, 1, User_List).


server_transfer_all(From, Message, User_List) ->
    case lists:keysearch(From, 1, User_List) of
        false ->
            From ! {messenger, stop, you_are_not_logged_on};
        {value, {From, Name}} ->
            send_to_all(User_List,Name,Message), 
            From ! {messenger, sent}
    end.


send_to_all([{ToPid,_}|T],Name,Message)-> 
    ToPid ! {message_from, Name, Message},
    send_to_all(T,Name,Message);
send_to_all([],_,_)->ok.


%%% User Commands
logon(Name) ->
    case whereis(mess_client) of 
        undefined ->
            register(mess_client, 
                     spawn(messenger, client, [server_node(), Name]));
        _ -> already_logged_on
    end.

logoff() ->
    mess_client ! logoff.

get_user_list() -> 
    mess_client ! {self(),user_list},
    ListaUsuarios=await_result(),
    ListaNombres=get_nombres(ListaUsuarios,[]),
    ListaNombres.
    
get_nombres([{_,Nombre}|T],NewList)-> 
    get_nombres(T,[Nombre|NewList]);


get_nombres([],NewList)->NewList.

get_historial_chat() ->
    mess_client ! {self(),historial_chat},
    Historial=await_result(),
    Historial.


message_all(Message) -> 
    case whereis(mess_client) of % Test if the client is running
        undefined ->
            not_logged_on;
        _ -> mess_client ! {message_all, Message},
             ok
    end.
%%% The client process which runs on each server node
client(Server_Node, Name) ->
    {messenger, Server_Node} ! {self(), logon, Name},
    await_result(),
    client_aux(Server_Node,[]).

client_aux(Server_Node,ListaHistorial) ->
    receive
        logoff ->
            {messenger, Server_Node} ! {self(), logoff},
            exit(normal);
        {message_all, Message} ->
            {messenger, Server_Node} ! {self(), message_to_all, Message},
            await_result(),
            client_aux(Server_Node,ListaHistorial);
        {message_from, FromName, Message} ->
            NewListaHistorial=ListaHistorial++[{FromName,Message}],
            io:format("Message from ~p: ~p~n", [FromName, Message]),
            client_aux(Server_Node,NewListaHistorial);
        {From,user_list} -> 
            {messenger, Server_Node} ! {self(),user_list},
            Aux = await_result(),
            From ! {lista,Aux},
            client_aux(Server_Node,ListaHistorial);
        {From,historial_chat}->
            From ! {lista,ListaHistorial},
            client_aux(Server_Node,ListaHistorial)
                
    end.

%%% wait for a response from the server
await_result() ->
    receive
        {messenger, stop, Why} -> % Stop the client 
            io:format("~p~n", [Why]),
            exit(normal);
        {messenger, What} ->  % Normal response
            io:format("~p~n", [What]);
        {messenger, data ,What}->
            io:format("chequeo respuesta :~p~n", [What]),
            What;
        {lista,Respuesta} ->
            Respuesta
    end.





