module Update exposing (update)

import Types exposing (Model, Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Types.SetView v ->
            ( { model | view = v }, Cmd.none )
