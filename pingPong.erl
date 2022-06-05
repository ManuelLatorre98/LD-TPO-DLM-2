-module(pingPong).
-export([start/0, ping/2, pong/0]).

ping(0, Pong_PID) ->
    Pong_PID ! finishied,
    io:format("PING FINALIZA~n",[]);

ping(N, Pong_PID) ->
    Pong_PID ! {ping, self()},
    receive 
        pong ->
            io:format("PING RECIBE PONG~n",[])
    end,
    ping(N - 1, Pong_PID).

pong() ->
    receive
        finishied ->
            io:format("Pong finishied~n",[]);
        {ping, Ping_PID} ->
            io:format("Pong recibe ping~n",[]),
            Ping_PID ! pong,
            pong()
        end.

start() ->
    Pong_PID = spawn(pingPong, pong, []),
    spawn(pingPong, ping, [3,Pong_PID]).