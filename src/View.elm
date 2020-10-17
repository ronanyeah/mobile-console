module View exposing (view)

import Element exposing (Attribute, Element, centerX, centerY, column, el, fill, height, none, padding, paragraph, px, row, spaceEvenly, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Html.Attributes
import Img
import Palette exposing (darkGray, grey, light, orange, white, yellow)
import Types exposing (Model, Msg, View)


view : Model -> Html Msg
view model =
    [ [ Element.newTabLink []
            { url = "https://hasura.io/"
            , label =
                Element.image [ height <| px 30 ]
                    { src = "/hasura.svg"
                    , description = ""
                    }
            }
      , model.view
            |> viewName
            |> text
            |> el [ Font.color light ]
      ]
        |> row
            [ width fill
            , spaceEvenly
            , Background.color darkGray
            , height <| px 75
            , Element.paddingXY 20 10
            ]
    , viewBody model.view
    , [ Types.Graphiql
      , Types.Data
      , Types.Arch
      , Types.Settings
      ]
        |> List.map
            (\v ->
                viewIcon v model.view
            )
        |> row
            [ width fill
            , spaceEvenly
            , Background.color darkGray
            , height <| px 75
            , Element.paddingXY 20 10
            ]
    ]
        |> column
            [ cappedWidth 450
            , cappedHeight 900
            , centerX
            , centerY
            ]
        |> Element.layoutWith
            { options =
                [ Element.noHover
                , Element.focusStyle
                    { borderColor = Nothing
                    , backgroundColor = Nothing
                    , shadow = Nothing
                    }
                ]
            }
            [ width fill
            , Background.color grey
            , height fill
            , Font.family
                [ Font.typeface "Gudea"
                ]
            ]


viewBody : View -> Element Msg
viewBody v =
    case v of
        Types.Graphiql ->
            [ text "GraphQL Endpoint"
                |> el [ Font.bold ]
            , [ text "POST"
                    |> el
                        [ Font.color orange
                        , Font.bold
                        , Font.size 20
                        ]
              , Input.text
                    [ Html.Attributes.disabled True
                        |> Element.htmlAttribute
                    , width fill
                    ]
                    { onChange = always <| Types.SetView Types.Graphiql
                    , label = Input.labelHidden ""
                    , placeholder = Nothing
                    , text = "https://hello-world.us-west-2.elb.amazonaws.com/v1/graphql"
                    }
              , Input.button
                    [ Font.size 25 ]
                    { onPress = Nothing
                    , label = text "📋"
                    }
              ]
                |> row
                    [ width fill
                    , spacing 10
                    ]
            , [ "Explorer"
                    |> text
                    |> el [ centerX, Font.bold, padding 10, Font.size 20 ]
              , Element.image [ height <| px 75, centerX, centerY ]
                    { src = "/gql.png"
                    , description = ""
                    }
              ]
                |> column
                    [ height fill
                    , width fill
                    , Background.color white
                    , padding 10
                    , Border.shadow
                        { offset = ( 2, 2 )
                        , blur = 4
                        , size = 0
                        , color = darkGray
                        }
                    ]
            ]
                |> column [ height fill, width fill, spacing 10 ]
                |> el [ height fill, width fill, padding 20 ]

        Types.Data ->
            Input.button
                [ Background.color yellow
                , Font.color darkGray
                , Border.rounded 5
                , padding 15
                , centerX
                ]
                { onPress = Nothing
                , label = text "Create Table"
                }
                |> el [ height fill, width fill, padding 20 ]

        Types.Arch ->
            [ viewArch Img.cogs "Actions"
            , viewArch Img.plug "Remote Schemas"
            , viewArch Img.cloud "Events"
            ]
                |> column [ centerX, spacing 10, padding 20 ]
                |> el [ height fill, width fill ]

        Types.Settings ->
            [ [ viewText "Current server version" "v1.3.2"
              , viewText "Latest stable server version" "v1.3.2"
              , viewText "Console asset version" "1599646455904"
              , viewText "Postgres version" "PostgreSQL 12.3 on x86_64-pc-linux-gnu, compiled by gcc (GCC) 4.8.5 20150623 (Red Hat 4.8.5-11), 64-bit"
              ]
                |> column [ spacing 20 ]
            , none
                |> el [ width fill, height <| px 1, Background.color darkGray ]
            , Element.newTabLink [ centerX ]
                { url = "https://hasura.io/help"
                , label = text "Help ↗️"
                }
            ]
                |> column [ spacing 20 ]
                |> el [ height fill, width fill, padding 20 ]


viewText : String -> String -> Element msg
viewText a b =
    [ text a
        |> el [ Font.bold ]
    , [ text b ]
        |> paragraph []
    ]
        |> column [ spacing 5 ]


viewArch : Html msg -> String -> Element msg
viewArch elem str =
    Input.button
        [ Background.color light
        , Element.focused
            [ Background.color yellow
            ]
        , width fill
        , padding 20
        , Border.rounded 20
        , Border.shadow
            { offset = ( 3, 3 )
            , blur = 0
            , size = 0
            , color = darkGray
            }
        ]
        { onPress = Nothing
        , label =
            [ elem
                |> Element.html
                |> el [ width <| px 30, height <| px 30 ]
            , text str
            ]
                |> row
                    [ spacing 20
                    ]
        }


viewIcon : View -> View -> Element Msg
viewIcon v current =
    let
        icon =
            case v of
                Types.Graphiql ->
                    Img.flask

                Types.Data ->
                    Img.data

                Types.Arch ->
                    Img.arch

                Types.Settings ->
                    Img.cog
    in
    Input.button
        [ height <| px 30
        , width <| px 30
        , (if v == current then
            yellow

           else
            light
          )
            |> Font.color
        ]
        { onPress = Just <| Types.SetView v
        , label = Element.html icon
        }


viewName : View -> String
viewName v =
    case v of
        Types.Graphiql ->
            "GRAPHIQL"

        Types.Data ->
            "DATA"

        Types.Arch ->
            "ARCHITECTURE"

        Types.Settings ->
            "SETTINGS"


cappedWidth : Int -> Attribute msg
cappedWidth n =
    Element.fill |> Element.maximum n |> Element.width


cappedHeight : Int -> Attribute msg
cappedHeight n =
    Element.fill |> Element.maximum n |> Element.height
