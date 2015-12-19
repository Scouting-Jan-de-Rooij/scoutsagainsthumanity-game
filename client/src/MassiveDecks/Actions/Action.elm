module MassiveDecks.Actions.Action where

import Task
import Effects

import MassiveDecks.Models.State exposing (InitialState)
import MassiveDecks.Models.Game exposing (Lobby, LobbyAndHand)
import MassiveDecks.Models.Player as Player
import MassiveDecks.Models.Notification as Notification
import MassiveDecks.Actions.Event exposing (Event, events, catchUpEvents)


type APICall a
  = Request
  | Result a


type Action
  = NoAction
  | DisplayError String
  | RemoveErrorPanel Int
  | SetInputError String (Maybe String)
  | UpdateInputValue String String
  | NewLobby (APICall Lobby)
  | JoinExistingLobby
  | JoinLobby String Player.Secret (APICall LobbyAndHand)
  | AddDeck
  | AddGivenDeck String (APICall LobbyAndHand)
  | FailAddDeck String
  | StartGame
  | Pick Int
  | Play
  | Withdraw Int
  | Notification Lobby
  | Consider Int
  | Choose Int
  | NextRound
  | SetInitialState InitialState
  | AnimatePlayedCards (List Int)
  | GameEvent Event
  | AddAi
  | DismissPlayerNotification (Maybe Notification.Player)
  | LeaveLobby
  | Skip (List Player.Id)
  | UpdateLobbyAndHand LobbyAndHand
  | Batch (List Action)


eventEffects : Lobby -> Lobby -> Effects.Effects Action
eventEffects oldLobby newLobby =
  events oldLobby newLobby |> eventsToEffects


catchUpEffects : Lobby -> Effects.Effects Action
catchUpEffects lobby =
  catchUpEvents lobby |> eventsToEffects


eventsToEffects : List Event -> Effects.Effects Action
eventsToEffects events
  = events
  |> List.map GameEvent
  |> List.map Task.succeed
  |> List.map Effects.task
  |> Effects.batch
