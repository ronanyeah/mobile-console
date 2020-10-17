module Types exposing (Flags, Model, Msg(..), View(..))


type alias Model =
    { view : View }


type Msg
    = SetView View


type alias Flags =
    {}


type View
    = Graphiql
    | Data
    | Arch
    | Settings
